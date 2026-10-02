/// A grown-up's view of how much challenge suits a child right now. It is a
/// preference, not an assessment, and it never changes on its own.
enum Readiness {
  gentle('gentle', 'Take it gently', 'Fewer new items at a time'),
  steady('steady', 'Usual pace', 'The default for this age band'),
  more('more', 'Ready for more', 'More new items when lessons allow');

  const Readiness(this.storageKey, this.label, this.detail);

  final String storageKey;
  final String label;
  final String detail;

  static Readiness fromStorage(String? key) {
    for (final readiness in Readiness.values) {
      if (readiness.storageKey == key) {
        return readiness;
      }
    }
    return Readiness.steady;
  }
}
