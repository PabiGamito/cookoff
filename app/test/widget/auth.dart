import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/providers/user_provider.dart';
import 'package:cookoff/widgets/auth.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import '../test_injector.dart';

void main() {
  var mockAuthProvider = MockAuthProvider();
  var mockUserProvider = MockUserProvider();

  var injector = TestInjector(authProvider: mockAuthProvider,
  userProvider: mockUserProvider);

  testWidgets('Main screen renders login page on no user',
      (WidgetTester tester) async {
    when(mockAuthProvider.profile)
        .thenAnswer((_) => Stream.fromFuture(Future.value(null)));

    await tester.pumpWidget(MaterialApp(
      home: InjectorWidget(
        child: AuthWidget(
          authProvider: mockAuthProvider,
          userProvider: mockUserProvider,
          authorizedScreen: Text('authorized'),
          unauthorizedScreen: Text('unauthorized'),
          authBloc: AuthBloc.instance,
          loadingBloc: LoadingAuthBloc.instance,),
        injector: injector,
      ),
    ));

    await tester.pump();
    expect(find.text('unauthorized'), findsOneWidget);
  });

  testWidgets('Main screen renders home screen on user login', (WidgetTester tester) async {
    when(mockAuthProvider.profile).thenAnswer((_) => Observable.just(NullUser()));
    when(mockUserProvider.friends(argThat(isA<String>()))).thenAnswer((_) => Observable.just([]));

    await tester.pumpWidget(MaterialApp(
      home: InjectorWidget(
        child: AuthWidget(
          authProvider: mockAuthProvider,
          userProvider: mockUserProvider,
          authorizedScreen: Text('authorized'),
          unauthorizedScreen: Text('unauthorized'),
          authBloc: AuthBloc.instance,
          loadingBloc: LoadingAuthBloc.instance,),
        injector: injector,
      ),
    ));

    await tester.pump();
    expect(find.text('authorized'), findsOneWidget);
  });

}

class MockAuthProvider extends Mock implements AuthProvider {}

class MockChallengeProvider extends Mock implements ChallengeProvider {}

class MockUserProvider extends Mock implements UserProvider {}
