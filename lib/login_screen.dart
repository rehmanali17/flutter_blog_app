import 'package:blog_app/home_screen.dart';
import 'package:blog_app/signup_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';

class LogIn extends StatefulWidget {
  LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String? email;
  String? password;

  final _formKey = GlobalKey<FormState>();

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
  void Login(email, password) async {
    await http
        .post(Uri.parse('http://localhost:3000/user/login'),
            headers: <String, String>{'Content-Type': 'application/json'},
            body: json.encode({"email": email, "password": password}))
        .then((result) {
      if (json.decode(result.body)['result'].runtimeType == String) {
        showAlert(context, (json.decode(result.body))['result']);
      } else {
        password = "";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Home(user: (json.decode(result.body))['result'])));
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
                    height: 70.0,
                  ),
                  Text(
                    'Blog App',
                    style: TextStyle(color: Colors.blue[600], fontSize: 40.0),
                  ),
                  SizedBox(
                    height: 40.0,
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
                          Login(email, password);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 7.0),
                        child: Text(
                          'Log in',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                      )),
                  SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    children: [
                      Text("Don't have an account?"),
                      SizedBox(
                        width: 5.0,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text('Sign up'))
                    ],
                  )
                ],
              ))),
    ));
  }
}
