enum AgeBand {
  a('A', '3-4'),
  b('B', '4-5'),
  c('C', '5-6'),
  d('D', '6-7'),
  toddler('T', '2-3');

  const AgeBand(this.storageKey, this.label);

  final String storageKey;
  final String label;
  int get learningRank => this == toddler ? 0 : index + 1;
  static const ordered = [toddler, a, b, c, d];

  static AgeBand? fromStorage(String key) {
    for (final band in AgeBand.values) {
      if (band.storageKey == key) {
        return band;
      }
    }
    return null;
  }
}
