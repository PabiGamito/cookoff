import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookoff/injector.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:cookoff/providers/camera_provider.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/providers/user_provider.dart';

class TestInjector implements Injector {
  @override
  final AuthProvider authProvider;
  @override
  final ChallengeProvider challengeProvider;
  @override
  final Firestore firestore;
  @override
  final UserProvider userProvider;

  TestInjector(
      {this.authProvider,
      this.challengeProvider,
      this.firestore,
      this.userProvider});

  @override
  // TODO: implement cameraProvider
  CameraControllerProvider get cameraProvider => null;
}
