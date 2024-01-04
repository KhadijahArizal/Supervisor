import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          '753383357173-e2pqr9f4bnfuv1p94oqekvu51u3o1qbu.apps.googleusercontent.com');

//google sign in
  Future<void> handleSignin() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential authResult =
            await _auth.signInWithCredential(credential);
        User? user = authResult.user;

        // Set the photo URL if available
        if (googleUser.photoUrl != null) {
          await user?.updatePhotoURL(googleUser.photoUrl!);
        }
      }
    } catch (e) {
      print("Error signing in with Google $e");
    }
  }

  // Google sign out
  Future<void> handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print("Error signing out $e");
    }
  }

  // Get authenticated user
  User? get currentUser => _auth.currentUser;

}
