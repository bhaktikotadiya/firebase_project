import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/two.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
    runApp(MaterialApp(
      home: first(),
    ));
}
class first extends StatefulWidget {
  const first({super.key});

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // User canceled the sign-in process
      // return null;
      return Future.error("Google Sign-In failed: Missing accessToken or idToken");
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

// Check if both accessToken and idToken are available
    if (googleAuth==null && googleAuth!.accessToken == null && googleAuth!.idToken == null) {
      return Future.error("Google Sign-In failed: Missing accessToken or idToken");
    }
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Name, email address, and profile photo URL
      String name = user.displayName.toString();
      String email = user.email.toString();

     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
         return second(name,email);
       },));
     });

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      //   return second(name,email);
      // },));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(children:[
            ElevatedButton(onPressed: () {

              signInWithGoogle().then((value) {
                String name,email;
                    name = value.user!.displayName.toString();
                    email = value.user!.email.toString();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return second(name,email);
                        },));

              });

            }, child: Text("SUBMIT"))
        ]),
    );
  }
}
