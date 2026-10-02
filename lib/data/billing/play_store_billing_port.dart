import 'dart:async';

import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_identity.dart';
import '../../core/platform/store_billing_port.dart';
import '../../domain/monetization/store_models.dart';

/// Google Play adapter. It does not decide Premium and does not invent prices.
class PlayStoreBillingPort implements StoreBillingPort {
  PlayStoreBillingPort(this._billing) {
    _subscription = _billing.purchaseStream.listen(
      (purchases) {
        _remember(purchases);
        if (!_updates.isClosed) {
          _updates.add([for (final purchase in purchases) _fact(purchase)]);
        }
      },
      onError: (Object _) {
        if (!_updates.isClosed) {
          _updates.add(const []);
        }
      },
    );
  }

  final InAppPurchase _billing;
  final StreamController<List<StorePurchaseFact>> _updates =
      StreamController<List<StorePurchaseFact>>.broadcast();
  final Map<String, PurchaseDetails> _purchases = {};
  final Map<String, GooglePlayProductDetails> _products = {};
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  Stream<List<StorePurchaseFact>> get purchaseUpdates => _updates.stream;

  @override
  Future<CatalogLoad> loadOffer({
    required String productId,
    String basePlanId = '',
    String offerId = '',
  }) async {
    try {
      final available = await _billing.isAvailable();
      if (!available) {
        return const CatalogLoad(
          status: CatalogStatus.unavailable,
          message: 'Google Play billing is unavailable on this device. No price is shown.',
        );
      }
      final response = await _billing.queryProductDetails({productId});
      final error = response.error;
      final drafts = <OfferDraft>[];
      for (final details in response.productDetails) {
        if (details.id != productId) {
          continue;
        }
        final draft = _draft(details);
        if (draft == null) {
          continue;
        }
        drafts.add(draft);
        if (details is GooglePlayProductDetails) {
          _products[draft.offerToken] = details;
        }
      }
      final chosen = choosePurchaseDraft(
        drafts,
        basePlanId: basePlanId,
        offerId: offerId,
      );
      if (chosen == null) {
        if (error != null) {
          return _catalogFromCode(error.code);
        }
        return const CatalogLoad(
          status: CatalogStatus.missingProduct,
          message: 'Google Play did not return this subscription. No price is shown.',
        );
      }
      final offers = [for (final draft in drafts) ?storeOfferFromDraft(draft)];
      return CatalogLoad(
        status: CatalogStatus.ready,
        message: 'The price and period below come from Google Play.',
        purchaseOffer: storeOfferFromDraft(chosen),
        eligibleOffers: offers,
      );
    } on PlatformException catch (error) {
      return _catalogFromCode(error.code);
    } catch (_) {
      return const CatalogLoad(
        status: CatalogStatus.error,
        message:
            'The subscription details could not be loaded. No price is shown.',
      );
    }
  }

  @override
  Future<StorePurchaseQuery> queryPurchases(String productId) async {
    try {
      final available = await _billing.isAvailable();
      if (!available) {
        return const StorePurchaseQuery(
          connection: StoreConnection.unavailable,
        );
      }
      final addition = _billing
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final response = await addition.queryPastPurchases();
      final error = response.error;
      if (error != null) {
        return StorePurchaseQuery(connection: _connectionFromCode(error.code));
      }
      _remember(response.pastPurchases);
      return StorePurchaseQuery(
        connection: StoreConnection.ready,
        purchases: [
          for (final purchase in response.pastPurchases)
            if (purchase.productID == productId) _fact(purchase),
        ],
      );
    } on PlatformException catch (error) {
      return StorePurchaseQuery(connection: _connectionFromCode(error.code));
    } catch (_) {
      return const StorePurchaseQuery(connection: StoreConnection.error);
    }
  }

  @override
  Future<bool> buy(StoreOffer offer) async {
    final details = _products[offer.offerToken];
    if (details == null) {
      return false;
    }
    try {
      return await _billing.buyNonConsumable(
        purchaseParam: GooglePlayPurchaseParam(
          productDetails: details,
          offerToken: offer.offerToken,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> acknowledge(String purchaseKey) async {
    final details = _purchases[purchaseKey];
    if (details == null) {
      return false;
    }
    if (details is GooglePlayPurchaseDetails &&
        details.billingClientPurchase.isAcknowledged) {
      return true;
    }
    try {
      await _billing.completePurchase(details);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> openManagement(String productId) async {
    final uri = Uri.https('play.google.com', '/store/account/subscriptions', {
      'sku': productId,
      'package': AppIdentity.temporaryApplicationId,
    });
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> dispose() async {
    await _subscription.cancel();
    await _updates.close();
  }

  void _remember(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      _purchases[_fact(purchase).purchaseKey] = purchase;
    }
  }

  OfferDraft? _draft(ProductDetails details) {
    if (details is! GooglePlayProductDetails) {
      return null;
    }
    final index = details.subscriptionIndex;
    final offers = details.productDetails.subscriptionOfferDetails;
    if (index == null ||
        offers == null ||
        index < 0 ||
        index >= offers.length) {
      return null;
    }
    final offer = offers[index];
    return OfferDraft(
      productId: details.id,
      title: details.title,
      description: details.description,
      offerToken: offer.offerIdToken,
      basePlanId: offer.basePlanId,
      offerId: offer.offerId,
      phases: [
        for (final phase in offer.pricingPhases)
          PricedPhase(
            billingPeriod: phase.billingPeriod,
            formattedPrice: phase.formattedPrice,
          ),
      ],
    );
  }

  StorePurchaseFact _fact(PurchaseDetails purchase) {
    final google = purchase is GooglePlayPurchaseDetails ? purchase : null;
    final token = purchase.verificationData.serverVerificationData.trim();
    final key = token.isNotEmpty
        ? token
        : (purchase.purchaseID ?? purchase.productID);
    final phase = switch (purchase.status) {
      PurchaseStatus.pending => StorePurchasePhase.pending,
      PurchaseStatus.purchased ||
      PurchaseStatus.restored => StorePurchasePhase.purchased,
      PurchaseStatus.canceled => StorePurchasePhase.canceled,
      PurchaseStatus.error => StorePurchasePhase.error,
    };
    return StorePurchaseFact(
      productId: purchase.productID,
      purchaseKey: key,
      phase: phase,
      acknowledged: google != null
          ? google.billingClientPurchase.isAcknowledged
          : !purchase.pendingCompletePurchase,
      autoRenewing: google?.billingClientPurchase.isAutoRenewing,
    );
  }

  CatalogLoad _catalogFromCode(String code) {
    final connection = _connectionFromCode(code);
    return switch (connection) {
      StoreConnection.offline => const CatalogLoad(
        status: CatalogStatus.offline,
        message: 'Google Play could not be reached. No price is shown.',
      ),
      StoreConnection.unavailable => const CatalogLoad(
        status: CatalogStatus.unavailable,
        message: 'Google Play billing is unavailable on this device. No price is shown.',
      ),
      StoreConnection.ready || StoreConnection.error => const CatalogLoad(
        status: CatalogStatus.error,
        message:
            'The subscription details could not be loaded. No price is shown.',
      ),
    };
  }

  StoreConnection _connectionFromCode(String code) {
    final normalized = code.toLowerCase();
    if (normalized.contains('network') ||
        normalized.contains('serviceunavailable') ||
        normalized.contains('servicedisconnected') ||
        normalized.contains('servicetimeout')) {
      return StoreConnection.offline;
    }
    if (normalized.contains('billingunavailable')) {
      return StoreConnection.unavailable;
    }
    return StoreConnection.error;
  }
}
