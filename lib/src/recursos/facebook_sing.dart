import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<UserCredential> signInWithFacebook() async {
  final result = await FacebookAuth.instance.login();

  final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(result.accessToken!.token);

  return await FirebaseAuth.instance
      .signInWithCredential(facebookAuthCredential);
}

Future<void> facebookLogOut() async {
  try {
    await FacebookAuth.instance.logOut();
  } catch (e) {
    print(e);
  }
}
