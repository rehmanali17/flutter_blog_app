import 'package:blog_app/create_blog_screen.dart';
import 'package:blog_app/single_blog_screen.dart';
import 'package:blog_app/edit_profile_screen.dart';
import 'package:blog_app/my_blogs_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  final user;
  Home({Key? key, this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future getUserBlogs() async {
    var response = await http
        .get(Uri.parse('http://localhost:3000/user/posts/getAllPosts'));
    if (response.statusCode == 200) {
      var result = (json.decode(response.body))['posts'];
      return result;
    }
  }

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
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Blog(data: [widget.user, record])));
              },
              child: Container(
                height: 230,
                child: Image(
                  image: MemoryImage(base64Decode(record['post_image'])),
                ),
              )),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blogs'),
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
      drawer: Drawer(
        child: Container(
          color: Colors.white10,
          child: ListView(
            children: [
              DrawerHeader(
                child: Container(
                    child: Center(
                  child: Container(
                    child: CircleAvatar(
                      radius: 80.0,
                      backgroundImage: AssetImage('blog.png'),
                    ),
                  ),
                )),
              ),
              ListTile(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home(user: widget.user)));
                  },
                  title: Container(
                    height: 20.0,
                    child: Center(
                        child: Text(
                      'Home',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold),
                    )),
                  )),
              Divider(),
              ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateBlog(user: widget.user)));
                  },
                  title: Container(
                    height: 20.0,
                    child: Center(
                        child: Text(
                      'Create Blog',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold),
                    )),
                  )),
              Divider(),
              ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyBlogs(user: widget.user)));
                  },
                  title: Container(
                    height: 20.0,
                    child: Center(
                        child: Text(
                      'My Blogs',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold),
                    )),
                  )),
              Divider(),
              ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditProfile(user: widget.user)));
                  },
                  title: Container(
                    height: 20.0,
                    child: Center(
                        child: Text(
                      'Edit Profile',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold),
                    )),
                  )),
              Divider(),
              ListTile(
                  onTap: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  title: Container(
                    height: 20.0,
                    child: Center(
                        child: Text(
                      'Log Out',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold),
                    )),
                  )),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
