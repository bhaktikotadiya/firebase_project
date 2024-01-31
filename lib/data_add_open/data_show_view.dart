import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/data_add_open/data_add_insert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class show extends StatefulWidget {
  const show({super.key});

  @override
  State<show> createState() => _showState();
}

class _showState extends State<show> {

  List id_key = [];
  List val = [];
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('data_table');


  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   starCountRef.onValue.listen((DatabaseEvent event) {
  //     final data = event.snapshot.value;
  //     Map m = data as Map;
  //     print("m : $m");
  //     id_key = m.keys.toList();
  //     val = m.values.toList();
  //     print(id_key);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: starCountRef.onValue,
          builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.active)
              {
                final data = snapshot.data!.snapshot.value;
                Map m = data as Map;
                // print(m);
                id_key = m.keys.toList();
                val = m.values.toList();
                // print(val);
              }
                  return ListView.builder(
                    itemCount: val.length,
                    itemBuilder: (context, index) {
                      Map m = val[index]['marks'];
                        return ExpansionTile(
                          title: Text("${val[index]['name']}"),
                          subtitle: Text("${val[index]['contact']}"),
                          children: m.entries.map((e) => Text("${e.key} : ${e.value} ")).toList(),
                          trailing: Wrap(children: [
                            IconButton(onPressed: (){
                              starCountRef.child(id_key[index]).remove();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                return show();
                              },));
                            }, icon: Icon(Icons.delete)),
                            IconButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return adding(id_key[index],val[index]);
                              },));
                            }, icon: Icon(Icons.edit)),
                          ]),
                        );
                    },
                  );

          },
      ),
    );
  }
}
