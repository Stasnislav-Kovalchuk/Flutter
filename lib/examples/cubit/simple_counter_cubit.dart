import 'package:bloc/bloc.dart';
import 'simple_counter_state.dart';

/// Very small Cubit example used as a template.
/// Keeps a counter and demonstrates an async loader moved into the Cubit.
class SimpleCounterCubit extends Cubit<SimpleCounterState> {
  SimpleCounterCubit() : super(const SimpleCounterState());

  void increment() => emit(state.copyWith(value: state.value + 1));

  void reset() => emit(const SimpleCounterState());

  /// Example of moving async work into the Cubit (e.g., API or storage call).
  /// `fetch` is injected so tests can mock it.
  Future<void> loadInitialValue(Future<int> Function() fetch) async {
    emit(state.copyWith(loading: true));
    try {
      final v = await fetch();
      emit(state.copyWith(value: v, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
