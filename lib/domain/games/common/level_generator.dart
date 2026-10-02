class ValidationResult {
  const ValidationResult.valid() : isValid = true, reason = null;

  const ValidationResult.invalid(this.reason) : isValid = false;

  final bool isValid;
  final String? reason;
}

abstract interface class LevelGenerator<C, L> {
  L generate({required C constraints, required int seed});

  ValidationResult validate(L level);
}
