import 'dart:convert';

import 'package:api_demo/first.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class view_data extends StatefulWidget {
  const view_data({super.key});

  @override
  State<view_data> createState() => _view_dataState();
}

//jinal

class _view_dataState extends State<view_data> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future get_data() async {
    var url = Uri.parse('https://systudent2.000webhostapp.com/view_api.php');
    var response = await http.get(url);
    Map m = jsonDecode(response.body);
    List l = m['res'];
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contact"),
      ),
      body: FutureBuilder(
        future: get_data(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List l = snapshot.data;
            return ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${l[index]['name']}"),
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://systudent2.000webhostapp.com/images/${l[index]['image']}")),
                  subtitle: Text("${l[index]['contact']}"),
                  trailing: Wrap(
                    children: [
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("are you sure for delete..."),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("No")),
                                    TextButton(
                                        onPressed: () async {
                                          var url = Uri.parse(
                                              'https://systudent2.000webhostapp.com/delete_api.php?id=${l[index]['id']}');
                                          var response = await http.get(url);
                                          print(response.body);
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: Text("Yes")),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.delete)),
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return first(l[index]);
                              },
                            ));
                          },
                          icon: Icon(Icons.edit)),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
