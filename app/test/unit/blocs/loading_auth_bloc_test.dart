import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  LoadingAuthBloc loading = LoadingAuthBloc.instance;

  test('Initial state is loading = false', () {
    expect(loading.initialState, false);
  });
  test('State becomes passed in value', () {
    loading.dispatch(true);
    loading.dispatch(false);
    loading.dispatch(false);
    loading.dispatch(true);
    expectLater(loading.state, emitsInOrder([false, true, false, true]));
  });
}
