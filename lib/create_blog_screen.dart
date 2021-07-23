import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Image Demo',
//       home: MyHomePage(title: 'Image Uploader'),
//     );
//   }
// }

// class ResponseMessage {
//   String? message;

//   ResponseMessage({this.message});

//   factory ResponseMessage.fromJson(Map<String, dynamic> parsedJson) {
//     return ResponseMessage(
//       message: parsedJson['message'].toString(),
//     );
//   }
// }

class CreateBlog extends StatefulWidget {
  final user;
  CreateBlog({Key? key, this.user}) : super(key: key);

  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  TextEditingController _content = TextEditingController();
  String? _imageFile;
  String _base64Image = "";
  String? _fileName;
  String _response = "";
  Color? _responseColor;
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
      _fileName = "Image";
      file = NetworkImage(_imageFile!);
      _response = "";
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

  void postBlog(content) async {
    await http
        .post(Uri.parse('http://localhost:3000/user/posts/add'),
            headers: <String, String>{'Content-Type': 'application/json'},
            body: json.encode({
              "content": content,
              "image": _base64Image,
              "user": widget.user['u_id']
            }))
        .then((result) {
      showAlert(context, (json.decode(result.body))['message']);
      setState(() {
        _base64Image = '';
        _content.text = '';
      });
    }).catchError((error) {
      showAlert(context, error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Blog"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
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
                      padding: EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
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
                _base64Image.length == 0
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: 140.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            border:
                                Border.all(color: Colors.black45, width: 2.0)),
                      )
                    : Container(
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
                      labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 25.0,
                ),
                TextButton(
                    onPressed: () {
                      if (_base64Image.length == 0) {
                        showAlert(context, "Select an Image first");
                        return;
                      } else if (_content.text == "") {
                        showAlert(context, "Enter some blog content");
                        return;
                      }
                      postBlog(_content.text);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      color: Colors.grey[300],
                      padding: EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                      child: Center(
                        child: Text(
                          "Create Blog",
                          style: TextStyle(fontSize: 25.0),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_response.length == 0 ? "" : _response,
                        style: TextStyle(fontSize: 25, color: _responseColor))
                  ],
                )
              ],
            ),
          ),
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
