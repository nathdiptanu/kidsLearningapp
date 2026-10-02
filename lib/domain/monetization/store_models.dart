import '../models/entitlement_snapshot.dart';

enum StorePurchasePhase { pending, purchased, canceled, error }

enum StoreConnection { ready, unavailable, offline, error }

enum CatalogStatus {
  ready,
  notConfigured,
  unavailable,
  missingProduct,
  offline,
  error,
}

enum BillingFlowOutcome {
  notConfigured,
  unavailable,
  missingProduct,
  offline,
  canceled,
  pending,
  unverified,
  purchased,
  restored,
  noPurchase,
  expired,
  error,
}

/// One subscription offer exactly as a store adapter reported it.
class StoreOffer {
  const StoreOffer({
    required this.productId,
    required this.title,
    required this.description,
    required this.formattedPrice,
    required this.billingPeriod,
    required this.offerToken,
    this.basePlanId,
    this.offerId,
    this.renewalFormattedPrice,
    this.renewalBillingPeriod,
  });

  final String productId;
  final String title;
  final String description;
  final String formattedPrice;
  final String billingPeriod;
  final String offerToken;
  final String? basePlanId;
  final String? offerId;
  final String? renewalFormattedPrice;
  final String? renewalBillingPeriod;
}

class CatalogLoad {
  const CatalogLoad({
    required this.status,
    required this.message,
    this.purchaseOffer,
    this.eligibleOffers = const [],
  });

  final CatalogStatus status;
  final String message;
  final StoreOffer? purchaseOffer;
  final List<StoreOffer> eligibleOffers;

  static const notConfigured = CatalogLoad(
    status: CatalogStatus.notConfigured,
    message: 'Premium is not active. Store purchases are not connected until a Play subscription id is configured. No price is available.',
  );

  bool get canPurchase =>
      status == CatalogStatus.ready && purchaseOffer != null;
}

class StorePurchaseFact {
  const StorePurchaseFact({
    required this.productId,
    required this.purchaseKey,
    required this.phase,
    required this.acknowledged,
    this.autoRenewing,
    this.expiryMillis,
    this.verifiedStatus,
  });

  final String productId;
  final String purchaseKey;
  final StorePurchasePhase phase;
  final bool acknowledged;

  /// Null when the client cannot tell whether the subscription renews.
  final bool? autoRenewing;

  /// Set only by a verification service. Play Billing does not provide it.
  final int? expiryMillis;

  /// Set only by a verification service.
  final EntitlementStatus? verifiedStatus;

  StorePurchaseFact copyWith({
    bool? acknowledged,
    int? expiryMillis,
    EntitlementStatus? verifiedStatus,
  }) {
    return StorePurchaseFact(
      productId: productId,
      purchaseKey: purchaseKey,
      phase: phase,
      acknowledged: acknowledged ?? this.acknowledged,
      autoRenewing: autoRenewing,
      expiryMillis: expiryMillis ?? this.expiryMillis,
      verifiedStatus: verifiedStatus ?? this.verifiedStatus,
    );
  }
}

class StorePurchaseQuery {
  const StorePurchaseQuery({
    required this.connection,
    this.purchases = const [],
  });

  final StoreConnection connection;
  final List<StorePurchaseFact> purchases;

  bool get succeeded => connection == StoreConnection.ready;
}

class BillingFlowResult {
  const BillingFlowResult({
    required this.snapshot,
    required this.outcome,
    required this.message,
  });

  final EntitlementSnapshot snapshot;
  final BillingFlowOutcome outcome;
  final String message;
}

class Reconciliation {
  const Reconciliation({
    required this.snapshot,
    required this.outcome,
    required this.message,
    required this.changed,
  });

  final EntitlementSnapshot snapshot;
  final BillingFlowOutcome outcome;
  final String message;
  final bool changed;
}

class PricedPhase {
  const PricedPhase({
    required this.billingPeriod,
    required this.formattedPrice,
  });

  final String billingPeriod;
  final String formattedPrice;
}

class OfferDraft {
  const OfferDraft({
    required this.productId,
    required this.title,
    required this.description,
    required this.offerToken,
    required this.phases,
    this.basePlanId,
    this.offerId,
  });

  final String productId;
  final String title;
  final String description;
  final String offerToken;
  final List<PricedPhase> phases;
  final String? basePlanId;
  final String? offerId;
}

/// Turns store phases into an offer. Empty or blank prices are rejected.
StoreOffer? storeOfferFromDraft(OfferDraft draft) {
  if (draft.offerToken.trim().isEmpty || draft.phases.isEmpty) {
    return null;
  }
  final first = draft.phases.first;
  if (first.formattedPrice.trim().isEmpty ||
      first.billingPeriod.trim().isEmpty) {
    return null;
  }
  final last = draft.phases.length > 1 ? draft.phases.last : null;
  final renewalPrice =
      last == null || last.formattedPrice == first.formattedPrice
      ? null
      : last.formattedPrice;
  return StoreOffer(
    productId: draft.productId,
    title: draft.title,
    description: draft.description,
    formattedPrice: first.formattedPrice,
    billingPeriod: first.billingPeriod,
    offerToken: draft.offerToken,
    basePlanId: draft.basePlanId,
    offerId: draft.offerId,
    renewalFormattedPrice: renewalPrice,
    renewalBillingPeriod: renewalPrice == null ? null : last?.billingPeriod,
  );
}

/// Picks the offer to buy. A configured offer id wins. Otherwise the regular
/// base plan is used so an introductory offer is not purchased silently.
OfferDraft? choosePurchaseDraft(
  List<OfferDraft> drafts, {
  String basePlanId = '',
  String offerId = '',
}) {
  final usable = drafts
      .where((draft) => storeOfferFromDraft(draft) != null)
      .toList();
  var list = usable;
  if (basePlanId.trim().isNotEmpty) {
    list = list.where((draft) => draft.basePlanId == basePlanId).toList();
  }
  if (offerId.trim().isNotEmpty) {
    list = list.where((draft) => draft.offerId == offerId).toList();
  }
  if (list.isEmpty) {
    return null;
  }
  if (offerId.trim().isNotEmpty) {
    return list.first;
  }
  final basePlans = list.where((draft) {
    final id = draft.offerId;
    return id == null || id.isEmpty;
  }).toList();
  return (basePlans.isNotEmpty ? basePlans : list).first;
}

/// Shows the store period. Unknown ISO values stay as the store sent them.
String describeBillingPeriod(String period) {
  return switch (period) {
    'P1Y' => 'every year',
    'P1M' => 'every month',
    'P1W' => 'every week',
    'P3M' => 'every 3 months',
    'P6M' => 'every 6 months',
    _ => period,
  };
}
