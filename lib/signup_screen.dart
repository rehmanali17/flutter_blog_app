// import 'package:flutter/material.dart';

// class SignUp extends StatefulWidget {
//   SignUp({Key? key}) : super(key: key);

//   @override
//   _SignUpState createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: null,
//     );
//   }
// }

import 'package:blog_app/login_screen.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:email_validator/email_validator.dart';
import 'dart:convert';
// import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:core';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name;
  String? email;
  String? password;
  int? age;

  final _formKey = GlobalKey<FormState>();

  bool isNumeric(String str) {
    return int.tryParse(str) != null;
  }

  showResultAlert(BuildContext context, name, email, phone, password) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: 120.0,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "User Name: ",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                      Text(name)
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Email: ",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                      Text(email)
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Mobile No: ",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                      Text(phone)
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Password: ",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                      Text(password)
                    ],
                  ),
                ],
              ),
            ),
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
  void Register(name, email, password, age) async {
    await http
        .post(Uri.parse('http://localhost:3000/user/signup'),
            headers: <String, String>{'Content-Type': 'application/json'},
            body: json.encode({
              "name": name,
              "email": email,
              "password": password,
              "age": age
            }))
        .then((result) {
      if (json.decode(result.body)['message'] == "Registered Successfully") {
        showAlert(context, json.decode(result.body)['message']);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LogIn()));
        });
      } else {
        showAlert(context, json.decode(result.body)['message']);
      }
    }).catchError((error) {
      showAlert(context, error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    'Blog App',
                    style: TextStyle(color: Colors.blue[600], fontSize: 40.0),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextFormField(
                    onSaved: (value) => name = value,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        prefixIcon: Icon(Icons.person_outline),
                        labelText: 'Name',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
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
                    onSaved: (value) => email = value,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        prefixIcon: Icon(Icons.alternate_email),
                        labelText: 'Email',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                    validator: (String? value) {
                      if (value == "") {
                        return 'Email cannot be Empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextFormField(
                    onSaved: (value) => age = int.parse(value!),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Age',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
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
                    onSaved: (value) => password = value,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Enter Password',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                    validator: (String? value) {
                      if (value == "") {
                        return 'Password cannot be Empty';
                      } else if (value!.length < 5 ||
                          !(value.contains(new RegExp(r'[A-Z0-9a-z]')))) {
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
                          Register(name!, email!, password!, age!.toString());
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22.0),
                        ),
                      )),
                  SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    children: [
                      Text("Already have an account?"),
                      SizedBox(
                        width: 5.0,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LogIn()));
                          },
                          child: Text('Log In'))
                    ],
                  )
                ],
              ))),
    ));
  }
}
