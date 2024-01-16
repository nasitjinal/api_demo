import 'dart:convert';
import 'dart:io';

import 'package:api_demo/view_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main()
{
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: first(),
  )
  );
}class first extends StatefulWidget {
  final l;
  first([this.l]);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  final ImagePicker picker = ImagePicker();
  XFile? photo;
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  TextEditingController t3=TextEditingController();
  bool t=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.l!=null)
    {
      t1.text=widget.l!['name'];
      t2.text=widget.l!['contact'];
      t3.text=widget.l!['city'];
      setState(() {

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:Text("API"),
          centerTitle: true,
        ),
        body: Column(
            children: [
              TextField(controller: t1,decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter Name"),),
              TextField(controller: t2,decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter Contact"),),
              TextField(controller: t3,decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter City"),),
              Row(
                children: [
                  ElevatedButton(onPressed: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: Text("choose any one"),
                        actions: [
                          Row(
                            children: [
                              TextButton(onPressed: () async {
                                photo = await picker.pickImage(source: ImageSource.camera);
                                t=true;
                                Navigator.pop(context);
                                setState(() {

                                });

                              }, child: Text("Camera")),
                              TextButton(onPressed: () async {
                                photo = await picker.pickImage(source: ImageSource.gallery);
                                t=true;
                                Navigator.pop(context);
                                setState(() {

                                });

                              }, child: Text("Galary")),
                            ],
                          ),
                        ],

                      );
                    },);
                  }, child: Text("upload image")),
                  Container(
                      height: 100,
                      width: 100,
                      child: (t)?Image.file(File(photo!.path)):null)
                ],
              ),
              ElevatedButton(onPressed: () async {
                String name=t1.text;
                String contact=t2.text;
                String city=t3.text;
                String image;
                image=base64Encode(await photo!.readAsBytes());
                var url;
                if(widget.l!=null)
                {
                  url = Uri.parse('https://systudent2.000webhostapp.com/add_api.php?name=$name&contact=$contact&city=$city&image=$image &id=${widget.l['id']}');

                }
                else
                {
                  url = Uri.parse('https://systudent2.000webhostapp.com/add_api.php');

                }

                var response = await http.post(url,body: {
                  'name':'$name',
                  'contact':'$contact',
                  'city':'$city',
                  'image':'$image',
                  'image_name':'${photo!.name}',
                });
                print('Response status: ${response.statusCode}');
                Map m=jsonDecode(response.body);
                print(m);

              }, child: Text("Submit")),
              ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return view_data();
                },));
              }, child: Text("View Data")),

            ],
            ),
        );
   }
}

