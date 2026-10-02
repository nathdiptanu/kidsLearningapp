import '../../domain/monetization/store_models.dart';

/// Store adapter. Implementations may use Google Play. Tests use a fake.
abstract interface class StoreBillingPort {
  Future<CatalogLoad> loadOffer({
    required String productId,
    String basePlanId = '',
    String offerId = '',
  });

  Future<StorePurchaseQuery> queryPurchases(String productId);

  /// Opens the store sheet. The returned flag means the sheet started,
  /// not that the parent owns the subscription.
  Future<bool> buy(StoreOffer offer);

  Future<bool> acknowledge(String purchaseKey);

  Stream<List<StorePurchaseFact>> get purchaseUpdates;

  Future<bool> openManagement(String productId);

  Future<void> dispose();
}
