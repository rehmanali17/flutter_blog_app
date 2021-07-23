import 'dart:convert';
import 'dart:ui';
import 'package:blog_app/my_blogs_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditBlog extends StatefulWidget {
  final data;
  EditBlog({Key? key, this.data}) : super(key: key);

  @override
  _EditBlogState createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  TextEditingController _content = TextEditingController();
  String? _imageFile;
  String _base64Image = "";
  ImageProvider<Object>? file;

  final ImagePicker _picker = ImagePicker();

  void takePhoto(ImageSource source) async {
    PickedFile? pickedFile = await _picker.getImage(
      source: source,
    );

    http.Response response = await http.get(Uri.parse(pickedFile!.path));
    _base64Image = base64Encode(response.bodyBytes);

    setState(() {
      _imageFile = pickedFile.path;
    });
  }

  Future getSingleBlog(id) async {
    var response = await http
        .get(Uri.parse("http://localhost:3000/user/posts/getSinglePost/$id"));
    if (response.statusCode == 200) {
      var result = (json.decode(response.body))['posts'];
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

  void editBlog(id) async {
    await http
        .put(Uri.parse("http://localhost:3000/user/posts/update/$id"),
            headers: <String, String>{'Content-Type': 'application/json'},
            body:
                json.encode({"content": _content.text, "image": _base64Image}))
        .then((result) {
      showAlert(context, (json.decode(result.body))['message']);
      Future.delayed(Duration(seconds: 1), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyBlogs(user: widget.data[1])));
      });
    }).catchError((error) {
      showAlert(context, error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Blog"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              padding: EdgeInsets.all(20.0),
              child: FutureBuilder(
                future: getSingleBlog(widget.data[0]['post_id']),
                builder: (BuildContext _, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var result = snapshot.data;
                    if (_base64Image.length == 0) {
                      _content..text = result['post_content'];
                      _base64Image = result['post_image'];
                      file = MemoryImage(base64Decode(result['post_image']));
                    } else {
                      file = NetworkImage(_imageFile!);
                    }
                    return Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => bottomSheet()));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50.0,
                              color: Colors.grey[300],
                              padding:
                                  EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                              child: Center(
                                child: Text(
                                  "Choose Image",
                                  style: TextStyle(fontSize: 25.0),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 25.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 140.0,
                          child: Center(
                            child: Stack(
                              children: [
                                Image(image: file!),
                                Positioned(
                                    bottom: 25.0,
                                    right: 25.0,
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: ((builder) =>
                                                bottomSheet()));
                                      },
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 28.0,
                                        color: Colors.teal[900],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        TextField(
                          maxLines: 9,
                          controller: _content,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter blog Content',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        TextButton(
                            onPressed: () {
                              if (_content.text == "") {
                                showAlert(context, "Enter some blog content");
                                return;
                              }
                              editBlog(widget.data[0]['post_id']);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50.0,
                              color: Colors.grey[300],
                              padding:
                                  EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                              child: Center(
                                child: Text(
                                  "Edit Blog",
                                  style: TextStyle(fontSize: 25.0),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 25.0,
                        )
                      ],
                    );
                  }
                },
              )),
        ));
  }

// Center(
//             child: Stack(
//           children: [
//             CircleAvatar(backgroundImage: file),
//             Positioned(
//                 bottom: 25.0,
//                 right: 25.0,
//                 child: InkWell(
//                   onTap: () {
//                     showModalBottomSheet(
//                         context: context,
//                         builder: ((builder) => bottomSheet()));
//                   },
//                   child: Icon(
//                     Icons.camera_alt,
//                     size: 28.0,
//                     color: Colors.teal[900],
//                   ),
//                 ))
//           ],
//         ))

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Choose Image',
            style: TextStyle(fontSize: 25.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera),
                  label: Text("Camera")),
              FlatButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text("Gallery")),
            ],
          )
        ],
      ),
    );
  }
}
