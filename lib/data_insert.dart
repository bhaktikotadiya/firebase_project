import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/data_view.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(MaterialApp(
    home: add_data(),
    debugShowCheckedModeBanner: false,
  ));
}

class add_data extends StatefulWidget {
  String? id;
  Map<String, dynamic>? data;
  add_data([this.id,this.data]);

  // const add_data({super.key});

  @override
  State<add_data> createState() => _add_dataState();
}

class _add_dataState extends State<add_data> {

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      if(widget.id!=null)
      {
          t1.text = widget.data!['name'];
          t2.text = widget.data!['contact'];
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADD DETAILS"),
      ),
      body: Column(children: [
        TextField(
            controller: t1
        ),
        TextField(
            controller: t2
        ),
        ElevatedButton(onPressed: () {

          String name = t1.text;
          String contact = t2.text;

            if(widget.id!=null)
            {
              users
                  .doc(widget.id)
                  .update({'name' : name,'contact' : contact})
                  .then((value) => print("User Updated"))
                  .catchError((error) => print("Failed to update user: $error"));
            }
            else
            {
              users.add({
                'name': name,
                'contact': contact,
              })
                  .then((value) => print("User Added"))
                  .catchError((error) => print("Failed to add user: $error"));
            }


        }, child: Text("ADD")),
        ElevatedButton(onPressed: () {

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return view_data();
          },));

        }, child: Text("VIew"))
      ]),
    );
  }
}
