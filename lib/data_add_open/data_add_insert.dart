import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/data_add_open/data_show_view.dart';
import 'package:flutter/material.dart';


//RealTime Database

Future<void> main()
async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MaterialApp(
      home: adding(),debugShowCheckedModeBanner: false,
    ));
}
class adding extends StatefulWidget {
  // adding(id_key, val);

  dynamic? id_key;
  dynamic? val;
  adding([this.id_key,this.val]);

  // const adding({super.key});

  @override
  State<adding> createState() => _addingState();
}

class _addingState extends State<adding> {

  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      if(widget.id_key !=null)
      {
        Map m = widget.val['marks'];
          name.text = widget.val!['name'];
          contact.text = widget.val!['contact'];
          t1.text = m['sub1'];
          t2.text = m['sub2'];
          t3.text = m['sub3'];
        print(m);

          print("id_key = ${widget.id_key}");
          print("val = ${widget.val}");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        TextFormField(controller: name,decoration: InputDecoration(hintText: "name")),
        TextFormField(controller: contact,decoration: InputDecoration(hintText: "contact")),
        TextFormField(controller: t1,decoration: InputDecoration(hintText: "sub1")),
        TextFormField(controller: t2,decoration: InputDecoration(hintText: "sub2")),
        TextFormField(controller: t3,decoration: InputDecoration(hintText: "sub3")),
        ElevatedButton(onPressed: () async {

         if(widget.id_key!=null)
           {
             // DatabaseReference ref = FirebaseDatabase.instance.ref("data_table").push();
             // FirebaseDatabase.instance
             //     .ref('data_table/${widget.id_key}')
             //     .set({
             //         "name": "${name.text}",
             //         "contact": "${contact.text}",
             //         "marks": {
             //           "sub1": "${t1.text}",
             //           "sub2": "${t2.text}",
             //           "sub3": "${t3.text}",
             //         }
             //        }).then((_) {
             //   // Data saved successfully!
             // }).catchError((error) {
             //   // The write failed...
             // });
             //-------------
             DatabaseReference ref = FirebaseDatabase.instance.ref("data_table").child(widget.id_key!);
             await ref.update({
               "name": "${name.text}",
               "contact": "${contact.text}",
               "marks": {
                 "sub1": "${t1.text}",
                 "sub2": "${t2.text}",
                 "sub3": "${t3.text}",
               }
             });
           }
         else
         {
           DatabaseReference ref = FirebaseDatabase.instance.ref("data_table").push();
           await ref.set({
             "name": "${name.text}",
             "contact": "${contact.text}",
             "marks": {
               "sub1": "${t1.text}",
               "sub2": "${t2.text}",
               "sub3": "${t3.text}",
             }
           });
         }
        }, child: Text("ADD")),
        ElevatedButton(onPressed: () {
          
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return show();
          },));
          
        }, child: Text("VIEW")),
      ]),
    );
  }
}
