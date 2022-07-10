import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key? key, required this.title}) : super(key: key);

  // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = 'ผลการประเมิน : เป็น COVID-19';
  ImagePicker picker = ImagePicker();
  var _image;
  var _reconi;
  var net_predict_spilt;
  bool send = false;
  var net_predict = 'NONE';
  var area;
  var link ='https://covid-detector-phoenix-assets.s3.us-east-2.amazonaws.com/heatmap/test.png';
  Widget _pic=Image.network('https://covid-detector-phoenix-assets.s3.us-east-2.amazonaws.com/heatmap/test.png');
  int status = 0;
  Future<void> getImagefile() async {
    var image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 224,maxHeight: 224
    );
    setState(() {
      _image = File(image!.path);
    });
    sendImage(_image);
    //status =0;
    //post(_image);
  }

  Future<void> getImagecam() async {
    var image = await picker.pickImage(source: ImageSource.camera,maxHeight: 224,maxWidth: 224);
    setState(() {
      _image = File(image!.path);
    });
    sendImage(_image);
  }

  /*loadmodel() async {
    Tflite.close();
    try {
      var res;
      res = await Tflite.loadModel(
          model: 'assets/vgg16lite.tflite', labels: 'assets/labels.txt');
      print(res);
    } on PlatformException {
      print('failed to load model');
    }
  }

  Future predict(File image) async {
    var reconi = await Tflite.runModelOnImage(
        path: image.path,   // required
        imageMean: 0.0,   // defaults to 117.0
        imageStd: 255.0,  // defaults to 1.0
        numResults: 2,    // defaults to 5
        threshold: 0.2,   // defaults to 0.1
        asynch: true      // defaults to true
    );
    print(reconi);
    result = reconi.toString();
    setState(() {
      _reconi = reconi;
    });
    //status=0;
  }

*/
  sendImage(File image) async {
    status = 1;
    if (image == null) return;
    await post(image);
    status = 0;
  }

  @override
  void initState() {
    super.initState();
    _pic = Image.network(link);
    /*loadmodel().then((val) {
      setState(() {});
    });*/
  }
  _updateImgWidget() async {
    setState(() {
      _pic = CircularProgressIndicator();
    });
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(link)).load(link))
        .buffer
        .asUint8List();
    setState(() {
      _pic = Image.memory(bytes);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 145, 198, 246),
      child: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text(
                    'scan',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'space',
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(children: [
                    ElevatedButton(
                      onPressed: getImagefile,
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter,
                            color: Colors.black,
                            size: 36.0,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'upload file',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.fromLTRB(50, 20, 50, 20)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 20))),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: getImagecam,
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.black,
                            size: 36.0,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'take photo',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.fromLTRB(50, 20, 50, 20)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 20))),
                    ),
                  ], mainAxisAlignment: MainAxisAlignment.center),
                  SizedBox(
                    height: 10,
                  ),
                  _image == null
                      ? Padding(
                          padding: const EdgeInsets.all(120.0),
                          child: Text('image unselected.',
                              style:
                                  TextStyle(fontSize: 15, fontFamily: 'space')),
                        )
                      : Image.file(_image),
                  status == 1
                      ? Dialog(
                          child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new Column(
                            children: [
                              new CircularProgressIndicator(),
                              new SizedBox(
                                height: 10,
                              ),
                              new Text(" Loading..."),
                            ],
                          ),
                        ))
                      : send == true
                          ? Column(children: [
                              net_predict_spilt[1] == 'Positive'
                                  ? Column(
                                      children: [
                                        Image.asset(
                                            'assets/image/positive.png'),
                                        _pic,
                                        SizedBox(height: 10),
                                        Text(
                                          'Area of abnormal: ' +
                                              net_predict_spilt[5]
                                                  .split('.')[0] +
                                              '.' +
                                              net_predict_spilt[5].split('.')[1]
                                                  [0] +
                                              net_predict_spilt[5].split('.')[1]
                                                  [1] +
                                              '%',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                            'Confidence: ' +
                                                net_predict_spilt[3] +
                                                '%',
                                            style: TextStyle(fontSize: 20)),
                                      ],
                                    )
                                  : net_predict_spilt[1] == 'Negative'
                                      ? Image.asset('assets/image/negative.png')
                                      // Text(net_predict[0]['predict']),
                                      : SizedBox(
                                          height: 1,
                                        ),
                            ])
                          : Text('')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future post(File img) async {
    var url =
        Uri.parse('https://covid-detector-phoenix.herokuapp.com/api/postData');
    Map<String, String> header = {"Content-type": "application/json"};
    //String jsondata = '{"name":"testApp","img": $img}';
    var request = http.MultipartRequest('POST', url);
    img.readAsBytes().asStream();
    request.files.add(http.MultipartFile(
        'img', img.openRead(), img.lengthSync(),
        filename: 'test.png'));
    request.headers.addAll(header);
    var responce = await http.Response.fromStream(await request.send());
    setState(() {
      net_predict = responce.body.toString();
      status = 0;
      send = true;
      _updateImgWidget();
      });
    print('--------------output-----------');
    print(responce.statusCode);
    print(net_predict);
    net_predict_spilt = net_predict.split(" ");
    print(net_predict_spilt);
  }

  // Future getheatmap(File img) async {
  //   net_predict = 'SERVER ERROR';
  //   var url = Uri.parse('http://75bd-202-29-146-227.ngrok.io/api/postData');
  //   Map<String, String> header = {"Content-type": "application/json"};
  //   //String jsondata = '{"name":"testApp","img": $img}';
  //   var request = await http.MultipartRequest('GET', url);
  //   img.readAsBytes().asStream();
  //   request.files.add(http.MultipartFile(
  //       'img', img.openRead(), img.lengthSync(),
  //       filename: 'test.png'));
  //   request.headers.addAll(header);
  //   var responce = await http.Response.fromStream(await request.send());
  //   print('--------------output-----------');
  //   print(responce.statusCode);
  //   net_predict = responce.body;
  // }
}
