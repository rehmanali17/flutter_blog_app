import 'package:blog_app/edit_blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyBlogs extends StatefulWidget {
  final user;
  MyBlogs({Key? key, this.user}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyBlogs> {
  Future getUserBlogs() async {
    var id = widget.user['u_id'];
    var response = await http
        .get(Uri.parse('http://localhost:3000/user/posts/getUserPosts/$id'));
    if (response.statusCode == 200) {
      var result = (json.decode(response.body))['posts'];
      return result;
    }
  }

  void deleteBlog(id) async {
    var response = await http
        .delete(Uri.parse("http://localhost:3000/user/posts/delete/$id"));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      showAlert(context, result['message']);
      Future.delayed(Duration(seconds: 1), () {
        setState(() {});
      });
    }
  }

  // ignore: non_constant_identifier_names
  Widget SingleBlog(record) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!, width: 2.0),
      ),
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 20,
                child: TextButton(
                  onPressed: () {
                    deleteBlog(record['post_id']);
                  },
                  child: FaIcon(FontAwesomeIcons.trashAlt),
                ),
              ),
              Container(
                height: 20,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditBlog(data: [record, widget.user])));
                  },
                  child: FaIcon(FontAwesomeIcons.edit),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4.0,
          ),
          Divider(),
          Container(
            height: 230,
            child: Image(
              image: MemoryImage(base64Decode(record['post_image'])),
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          Divider(),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(record['post_content']),
          ),
          SizedBox(
            height: 8.0,
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Blogs'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          child: Column(children: [
            FutureBuilder(
              future: getUserBlogs(),
              builder: (BuildContext _, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data.runtimeType == String) {
                    return Center(
                      child: Text('No Blog Posts'),
                    );
                  } else {
                    List results = snapshot.data;
                    return Column(
                      children:
                          results.map((record) => SingleBlog(record)).toList(),
                    );
                  }
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}
