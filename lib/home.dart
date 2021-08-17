import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File _image;
  List _output;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadMode().then((value) {
      setState(() {});
    });
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 3,
      threshold: 0.3333,
      imageMean: 85,
      imageStd: 85,
    );
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadMode() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  pickGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                'Auto Scan Diagnose',
                style: TextStyle(fontSize: 18, color: Colors.cyan[800]),
              ),
              Text(
                'normal, Covid and Viral Pneumonia',
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.cyan[900],
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 60),
              Center(
                child: _loading
                    ? Column(
                        children: [
                          Image.asset(
                            'assets/images/auto.png',
                            height: 300,
                          ),
                          SizedBox(height: 50),
                        ],
                      )
                    : Container(
                        child: Column(
                          children: [
                            Container(
                              height: 250,
                              child: Image.file(_image),
                            ),
                            SizedBox(height: 20),
                            _output != null
                                ? Column(
                                    children: [
                                      Text(
                                        '${_output[0]['label']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        '${(_output[0]['confidence'] * 100).toStringAsFixed(2)}%',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  )
                                : Container(),
                            SizedBox(height: 10)
                          ],
                        ),
                      ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: pickGallery,
                      child: Container(
                        width: 240,
                        decoration: BoxDecoration(
                            color: Colors.cyan[900],
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 17,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.photo, color: Colors.white),
                            Text(
                              '   Choose a photo',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: 240,
                        decoration: BoxDecoration(
                            color: Colors.cyan[900],
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 17,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.camera, color: Colors.white),
                            Text(
                              '   Camera Roll',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
