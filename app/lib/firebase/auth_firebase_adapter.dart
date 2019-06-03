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

  static const String friendsCollection = 'users';

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
    print("called");
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);
    registerUser(user);
  }

  // Add user to users in firestore if user doesn't exist
  Future registerUser(FirebaseUser user) async {
    if(!await _firestore
        .collection(friendsCollection)
        .document(user.uid)
        .get()
        .then((snapshot) => snapshot.exists)) {
      await _firestore.collection(friendsCollection).document(user.uid).setData({
        'name': user.displayName,
        'email': user.email,
        'profilePictureUrl': user.photoUrl,
        'friends': []
      });
    }
  }

  @override
  Future signOut() async {
    await _firebaseAuth.signOut();
  }
}
