import 'package:flutter/services.dart';
import 'package:flutter_mlkit_demo/ml/object_detection.dart';
import 'package:flutter_mlkit_demo/ml/common/object_detector_option.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'output/object.dart';

class ObjectDetector{
  ObjectDetector({required this.options});

  final ObjectDetectorOptions options;

  final id = DateTime.now().microsecondsSinceEpoch.toString();

  Future<List<DetectedObject>> processImage(InputImage inputImage) async {
    // TODO implement method
    return List.empty();
  }
}