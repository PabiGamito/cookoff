import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:cookoff/widgets/auth_builder.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import '../test_injector.dart';

void main() {
  var mockAuthProvider = MockAuthProvider();
  var injector = TestInjector(authProvider: mockAuthProvider);

  testWidgets('Main screen renders login page on no user',
      (WidgetTester tester) async {
    when(mockAuthProvider.userStream())
        .thenAnswer((_) => Stream.fromFuture(Future.value(null)));

    await tester.pumpWidget(MaterialApp(
      home: InjectorWidget(
        child: AuthBuilder(
          authorizedScreen: Text('authorized'),
          unauthorizedScreen: Text('unauthorized'),
          loadingBloc: LoadingAuthBloc.instance,
        ),
        injector: injector,
      ),
    ));

    await tester.pump();
    expect(find.text('unauthorized'), findsOneWidget);
  });

  testWidgets('Main screen renders home screen on user login',
      (WidgetTester tester) async {
    when(mockAuthProvider.userStream())
        .thenAnswer((_) => Observable.just(NullUser()));

    await tester.pumpWidget(MaterialApp(
      home: InjectorWidget(
        child: AuthBuilder(
          authorizedScreen: Text('authorized'),
          unauthorizedScreen: Text('unauthorized'),
          loadingBloc: LoadingAuthBloc.instance,
        ),
        injector: injector,
      ),
    ));

    await tester.pump();
    expect(find.text('authorized'), findsOneWidget);
  });
}

class MockAuthProvider extends Mock implements AuthProvider {}
