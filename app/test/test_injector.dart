import 'package:cookoff/injector.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:cookoff/providers/camera_provider.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/providers/ingredient_provider.dart';
import 'package:cookoff/providers/user_provider.dart';

class TestInjector implements Injector {
  @override
  final AuthProvider authProvider;

  @override
  final CameraControllerProvider cameraProvider;

  @override
  final ChallengeProvider challengeProvider;

  @override
  final IngredientProvider ingredientProvider;

  @override
  final UserProvider userProvider;

  TestInjector(
      {this.authProvider,
      this.cameraProvider,
      this.challengeProvider,
      this.ingredientProvider,
      this.userProvider});
}
