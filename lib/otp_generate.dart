import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,home: first_page(),
    ));
}
class first_page extends StatefulWidget {
  const first_page({super.key});

  @override
  State<first_page> createState() => _first_pageState();
}

class _first_pageState extends State<first_page> {

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  String v_id = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP GENERATE"),
      ),
      body: Column(children: [
        TextField(
          controller: t1,
        ),
        ElevatedButton(onPressed: () async {

          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: '+91${t1.text}',
            verificationCompleted: (PhoneAuthCredential credential) async {
              await auth.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              if (e.code == 'invalid-phone-number') {
                print('The provided phone number is not valid.');
              }
            },
            codeSent: (String verificationId, int? resendToken) {
                v_id = verificationId;
                setState(() { });
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );

        }, child: Text("SEND OTP")),
        SizedBox(height: 10,),
        TextField(
          controller: t2,
        ),
        ElevatedButton(onPressed: () async {

          // Update the UI - wait for the user to enter the SMS code
          String smsCode = 'xxxx';

          // Create a PhoneAuthCredential with the code
          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: v_id, smsCode: smsCode);

          await auth.signInWithCredential(credential);

        }, child: Text("VERIFY OTP"))
      ]),
    );
  }
}
