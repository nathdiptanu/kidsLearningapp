import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/monetization/store_models.dart';

OfferDraft _draft({
  String token = 'token',
  String? offerId,
  String basePlanId = 'annual',
  List<PricedPhase> phases = const [
    PricedPhase(billingPeriod: 'P1Y', formattedPrice: '€12.00'),
  ],
}) {
  return OfferDraft(
    productId: 'configured-in-test',
    title: 'Premium',
    description: 'From the store',
    offerToken: token,
    basePlanId: basePlanId,
    offerId: offerId,
    phases: phases,
  );
}

void main() {
  test('store phases become the only price and blank prices are rejected', () {
    final offer = storeOfferFromDraft(
      _draft(
        phases: const [
          PricedPhase(billingPeriod: 'P1W', formattedPrice: '€1.00'),
          PricedPhase(billingPeriod: 'P1Y', formattedPrice: '€12.00'),
        ],
      ),
    );
    expect(offer?.formattedPrice, '€1.00');
    expect(offer?.billingPeriod, 'P1W');
    expect(offer?.renewalFormattedPrice, '€12.00');
    expect(describeBillingPeriod('P1Y'), 'every year');
    expect(describeBillingPeriod('P4D'), 'P4D');
    expect(
      storeOfferFromDraft(
        _draft(
          phases: const [
            PricedPhase(billingPeriod: 'P1Y', formattedPrice: '  '),
          ],
        ),
      ),
      isNull,
    );
    expect(storeOfferFromDraft(_draft(phases: const [])), isNull);
  });

  test(
    'the regular base plan is purchased unless an offer id is configured',
    () {
      final intro = _draft(token: 'intro', offerId: 'welcome');
      final base = _draft(token: 'base');
      expect(choosePurchaseDraft([intro, base])?.offerToken, 'base');
      expect(
        choosePurchaseDraft([intro, base], offerId: 'welcome')?.offerToken,
        'intro',
      );
      expect(choosePurchaseDraft([intro, base], basePlanId: 'missing'), isNull);
    },
  );
}
