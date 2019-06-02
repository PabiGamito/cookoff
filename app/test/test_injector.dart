import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookoff/injector.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/providers/user_provider.dart';

class TestInjector implements Injector {
  @override
  AuthProvider get authProvider => null;

  @override
  ChallengeProvider get challengeProvider => null;

  @override
  Firestore get firestore => null;

  @override
  UserProvider get userProvider => null;

}
