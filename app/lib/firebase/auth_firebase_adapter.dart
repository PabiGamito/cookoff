import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

class AuthFirebaseAdapter implements AuthProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // firebase user
  Observable<FirebaseUser> user;
  @override
  Observable<User> profile;

  AuthFirebaseAdapter() {
    user = Observable(_firebaseAuth.onAuthStateChanged);
    profile = user.map((user) {
      if (user != null) {
        return User(user.email, user.photoUrl, user.displayName, user.uid);
      } else {
        return null;
      }
    });
  }

  @override
  Future signIn() async {
    print("Sign in");
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    await _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future signOut() async {
    await _firebaseAuth.signOut();
  }
}
