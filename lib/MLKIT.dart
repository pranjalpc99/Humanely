import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';


class MLKit  {
  //Uint8List bytes;
  //String imagepath="";

//  MLKit({this.filePath});


//  FirebaseVisionImage visionImage = FirebaseVisionImage.fromFilePath(imagepath.toString());



  Future<void> detectautomllabels() async{
    // final File imageFile = getImageFile();
    //final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
  }


  Future classifyImage(String imagepath) async {
    await Tflite.loadModel(model: "assets/model.tflite",labels: "assets/dict.txt");
    var output = await Tflite.runModelOnImage(path: imagepath);
    print("IMAGE LABELLL");
    print(output.toString());
  }


//  Future<void> detectLabels(String imagepath) async {
//    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFilePath(imagepath);
//    FirebaseVision.instance.modelManager().setupModel('<foldername(modelname)>', modelLocation);
//
//    //final VisionEdgeImageLabeler visionEdgeLabeler = FirebaseVision.instance.visionEdgeImageLabeler('<foldername>', VisionEdgeImageLabelerOptions(confidenceThreshold: 0.5)
//   // );
//
//  //  FirebaseVision.instance.modelManager().setupModel('<foldername(modelname)>', modelLocation);
//
// //   final VisionEdgeImageLabeler visionEdgeLabeler = FirebaseVision.instance.visionEdgeImageLabeler('<foldername(modelname)>', modelLocation);
//
//    final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
//    final ImageLabeler cloudLabeler = FirebaseVision.instance.cloudImageLabeler();
//
//    final List<ImageLabel> labels = await labeler.processImage(visionImage);
//    final List<ImageLabel> cloudLabels = await cloudLabeler.processImage(visionImage);
//
//    for (ImageLabel label in labels) {
//      final String text = label.text;
//      final String entityId = label.entityId;
//      final double confidence = label.confidence;
//      print("LABELLLL"+ text+"     "+confidence.toString());
//    }
//
//    cloudLabeler.close();

//    final LabelDetector labelDetector = FirebaseVision.instance.labelDetector();
//    final List<Label> labels = await labelDetector.detectInImage(visionImage);
//    for (Label label in labels) {
//      final String text = label.label;
//      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
//    }
}