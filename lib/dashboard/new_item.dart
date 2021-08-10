import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/*
* Author Neha Yadav
* Create: 10/07/2021
* */
class NewItem extends StatefulWidget {
  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  PickedFile? _imageFile = PickedFile("");
  dynamic _pickImageError;
  late String name, des;
  final _formKey = GlobalKey<FormState>();
  double _currentSliderValue = 1;
  String? _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  bool isLoading = false;

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: null,
        maxHeight: null,
        imageQuality: 60,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    return Semantics(
        child: InkWell(
          onTap: () {
            showOptionsDialog(context);
          },
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Semantics(
              label: 'image_picker_example_picked_image',
              child: _imageFile?.path != null && _imageFile!.path.isNotEmpty
                  ? Image.file(
                      File(_imageFile!.path),
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo,
                            size: 60,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Click Add Photo",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
        label: 'image_picker_example_picked_images');
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Name", border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        } else {
                          setState(() {
                            name = value;
                          });
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _previewImages(),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Description",
                          border: OutlineInputBorder()),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        } else {
                          setState(() {
                            des = value;
                          });
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Choose Asking Price"),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _currentSliderValue,
                            min: 1,
                            max: 250,
                            label: _currentSliderValue.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _currentSliderValue = value;
                              });
                            },
                          ),
                        ),
                        Text("£${_currentSliderValue.toInt()}"),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            await uploadFileAndSubmitData(_imageFile!.path);
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
          isLoading
              ? Container(
                  color: Colors.black26,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(child: CircularProgressIndicator()))
              : SizedBox()
        ],
      ),
    );
  }

  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose Photo"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Camera"),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _onImageButtonPressed(ImageSource.camera,
                          context: context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Gallery"),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _onImageButtonPressed(ImageSource.gallery,
                          context: context);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> uploadFileAndSubmitData(String filePath) async {
    File file = File(filePath);
    try {
      String refImage = "images/${DateTime.now()}.jpg";

      var result = await firebase_storage.FirebaseStorage.instance
          .ref(refImage)
          .putFile(file);
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(refImage)
          .getDownloadURL();
      var userId = FirebaseAuth.instance.currentUser!.uid;
      print(userId);
      var user = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      FirebaseFirestore.instance.collection('items').add({
        "itemName": name,
        "photo": downloadURL,
        "description": des,
        "price": _currentSliderValue.round(),
        "username": user['username'],
        "user_id": userId,
        "timestamp": FieldValue.serverTimestamp(),
        "sale": true,
        "under_offer": false,
      });
      print("downloadURL ${downloadURL}");
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Item successfully added.",
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 16.0);
      Navigator.of(context).pop();
    } on firebase_core.FirebaseException catch (e) {
      print("Error ${e.message}");
    }
  }
}
