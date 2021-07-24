import 'package:blog_app/edit_blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MySingleBlog extends StatefulWidget {
  final data;
  MySingleBlog({Key? key, this.data}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MySingleBlog> {
  // TextEditingController _comment = TextEditingController();

  Future getSingleBlog() async {
    var id = widget.data[1]['post_id'];
    var response = await http
        .get(Uri.parse("http://localhost:3000/user/posts/getSinglePost/$id"));
    if (response.statusCode == 200) {
      var result = (json.decode(response.body))['posts'];
      return result;
    }
  }

  Future getComments(id) async {
    var response = await http
        .get(Uri.parse("http://localhost:3000/user/posts/getPostComments/$id"));
    if (response.statusCode == 200) {
      var result = (json.decode(response.body))['comments'];
      return result;
    }
  }

  // void deleteBlog(id) async {
  //   var response = await http
  //       .delete(Uri.parse("http://localhost:3000/user/posts/delete/$id"));
  //   if (response.statusCode == 200) {
  //     var result = jsonDecode(response.body);
  //     showAlert(context, result['message']);
  //     Future.delayed(Duration(seconds: 1), () {
  //       setState(() {});
  //     });
  //   }
  // }

  // ignore: non_constant_identifier_names
  Widget SingleBlog(record) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!, width: 2.0),
      ),
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
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
            child: Text("Content:  " + record['post_content']),
          ),
          SizedBox(
            height: 4.0,
          ),
          Divider(),
          Container(
            alignment: Alignment.centerLeft,
            child: Text("Author:  " + record['u_name']),
          ),
          SizedBox(
            height: 8.0,
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget SingleComment(comment) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment['u_name'] + ": " + comment['post_comment']),
          Divider(),
        ],
      ),
    );
  }

  // void postComment(comment) async {
  //   var user = widget.data[0]['u_id'];
  //   var post = widget.data[1]['post_id'];
  //   await http
  //       .post(Uri.parse('http://localhost:3000/user/posts/postComment'),
  //           headers: <String, String>{'Content-Type': 'application/json'},
  //           body: json.encode({"comment": comment, "post": post, "user": user}))
  //       .then((result) {
  //     showAlert(context, (json.decode(result.body))['message']);
  //     setState(() {
  //       _comment..text = "";
  //     });
  //   }).catchError((error) {
  //     showAlert(context, error);
  //   });
  // }

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
        title: Text('Blog'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          child: Column(children: [
            FutureBuilder(
              future: getSingleBlog(),
              builder: (BuildContext _, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data.runtimeType == String) {
                    return Center(
                      child: Text('No Blog Post'),
                    );
                  } else {
                    var result = snapshot.data;
                    return Column(
                      children: [
                        SingleBlog(result),
                        SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: Text(
                            'Comments',
                            style: TextStyle(
                                color: Colors.blue[600], fontSize: 18.0),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FutureBuilder(
                            future: getComments(widget.data[1]['post_id']),
                            builder: (BuildContext _, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                if (snapshot.data.runtimeType == String) {
                                  return Center(
                                    child: Text('No Comments'),
                                  );
                                } else {
                                  List comments = snapshot.data;
                                  return Column(
                                    children: comments.map((comment) {
                                      // get index
                                      // var index = comments.indexOf(comment);
                                      return SingleComment(comment);
                                    }).toList(),
                                  );
                                }
                              }
                            }),
                        SizedBox(
                          height: 10.0,
                        ),
                        // TextField(
                        //     controller: _comment,
                        //     decoration: InputDecoration(
                        //       border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(15.0)),
                        //       labelText: 'Post New Comment',
                        //     )),
                        // SizedBox(
                        //   height: 10.0,
                        // ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     if (_comment.text == "") {
                        //       showAlert(context, "Enter Comment First");
                        //     } else {
                        //       postComment(_comment.text);
                        //     }
                        //   },
                        //   child: Text("Post"),
                        // )
                      ],
                    );
                  }
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}
