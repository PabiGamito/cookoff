import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

class AuthFirebaseAdapter implements AuthProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  static const String firestoreCollection = "users";

  // firebase user
  Observable<FirebaseUser> user;
  @override
  Observable<User> profile;

  AuthFirebaseAdapter() {
    user = Observable(_firebaseAuth.onAuthStateChanged);
    profile = user.switchMap((user) {
      if (user != null) {
        _firestore
            .collection(firestoreCollection)
            .document(user.uid)
            .snapshots()
            .map((snapshot) => User.fromJson(snapshot.data));
      } else {
        return null;
      }
    });
  }

  @override
  Future signIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);
    updateUser(user);
  }

  Future updateUser(FirebaseUser fireUser) async {
    User data = User(
        fireUser.email, fireUser.photoUrl, fireUser.displayName, fireUser.uid);
    await _firestore
        .collection(firestoreCollection)
        .document(fireUser.uid)
        .updateData(data.toJson());
  }

  @override
  Future signOut() async {
    await _firebaseAuth.signOut();
  }
}
