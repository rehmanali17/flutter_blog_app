import 'package:blog_app/home_screen.dart';
import 'package:blog_app/login_screen.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:email_validator/email_validator.dart';
import 'dart:convert';
// import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:core';

class EditProfile extends StatefulWidget {
  final user;
  EditProfile({Key? key, this.user}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? name;
  String? email;
  String? password;
  int? age;

  final _formKey = GlobalKey<FormState>();

  Future getSingleUser(id) async {
    var response = await http
        .get(Uri.parse("http://localhost:3000/user/getSingleUser/$id"));
    if (response.statusCode == 200) {
      var result = (json.decode(response.body))['result'];
      return result;
    }
  }

  showAlert(BuildContext context, msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(msg),
            actions: <Widget>[
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  // ignore: non_constant_identifier_names
  void Edit(name, password, age) async {
    var id = widget.user['u_id'];
    await http
        .put(Uri.parse("http://localhost:3000/user/update/$id"),
            headers: <String, String>{'Content-Type': 'application/json'},
            body: json.encode({"name": name, "password": password, "age": age}))
        .then((result) {
      showAlert(context, (json.decode(result.body))['message']);
      Future.delayed(Duration(seconds: 1), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Home(user: widget.user)));
      });
    }).catchError((error) {
      showAlert(context, error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
              child: Form(
                key: _formKey,
                child: FutureBuilder(
                    future: getSingleUser(widget.user['u_id']),
                    builder: (BuildContext _, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        var result = snapshot.data;
                        return Column(
                          children: [
                            SizedBox(
                              height: 45.0,
                            ),
                            TextFormField(
                              initialValue: result['u_name'],
                              onSaved: (value) => name = value,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  prefixIcon: Icon(Icons.person_outline),
                                  labelText: 'Name',
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              validator: (String? value) {
                                if (value == "") {
                                  return 'Name cannot be Empty';
                                } else if (value!.contains(new RegExp(
                                    r'[1234567890!@#$%^&*(),.<>`~/?;:"|{}]'))) {
                                  return 'Enter Valid Name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            TextFormField(
                              initialValue: result['u_age'].toString(),
                              onSaved: (value) => age = int.parse(value!),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Age',
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              validator: (String? value) {
                                if (value == "") {
                                  return 'Age cannot be Empty';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            TextFormField(
                              initialValue: result['u_password'],
                              onSaved: (value) => password = value,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  prefixIcon: Icon(Icons.lock),
                                  labelText: 'Enter Password',
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              validator: (String? value) {
                                if (value == "") {
                                  return 'Password cannot be Empty';
                                } else if (value!.length < 5 ||
                                    !(value.contains(
                                        new RegExp(r'[A-Z0-9a-z]')))) {
                                  return 'Password should be 5 atleast character Alphanumeric';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 35.0,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    Edit(name!, password!, age!);
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0),
                                  ),
                                )),
                            SizedBox(
                              height: 25.0,
                            )
                          ],
                        );
                      }
                    }),
              )),
        ));
  }
}
