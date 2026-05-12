class SimpleCounterState {
  final int value;
  final bool loading;
  final String? error;

  const SimpleCounterState({this.value = 0, this.loading = false, this.error});

  SimpleCounterState copyWith({int? value, bool? loading, String? error}) {
    return SimpleCounterState(
      value: value ?? this.value,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
