import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookoff/firebase/user_firebase_adapter.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebaseAdapter implements AuthProvider {
  static const String _collection = 'users';

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;

  final FirebaseMessaging _messaging = FirebaseMessaging();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Firebase user
  final Stream<FirebaseUser> _user;

  AuthFirebaseAdapter() : _user = _firebaseAuth.onAuthStateChanged;

  // Add user to users in firestore if user doesn't exist
  Future _registerUser(FirebaseUser user) async {
    var token = await _messaging.getToken();

    if (!await _firestore
        .collection(_collection)
        .document(user.uid)
        .get()
        .then((snapshot) => snapshot.exists)) {
      await _firestore.collection(_collection).document(user.uid).setData({
        'name': user.displayName,
        'email': user.email,
        'profilePictureUrl': user.photoUrl,
        'friends': [],
        'deviceTokens': [token],
      });
    }
  }

  @override
  Stream<User> userStream() => _user
      .where((user) => user != null)
      .asyncExpand((user) => UserFirebaseAdapter().userStream(user.uid));

  @override
  Future signIn() async {
    var googleUser = await _googleSignIn.signIn();
    var googleAuth = await googleUser.authentication;

    var credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    var user = await _firebaseAuth.signInWithCredential(credential);

    _registerUser(user);
  }

  @override
  Future signOut() async => await _firebaseAuth.signOut();
}
