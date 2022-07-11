import 'package:flutter_mlkit_demo/ml/object_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

import 'object_detector_mode.dart';
import 'object_detector_type.dart';


class ObjectDetectorOptions{
  final DetectionMode mode;
  final ObjectDetectorType type = ObjectDetectorType.base;
  final bool classifyObjects;
  final bool multipleObjects;

  ObjectDetectorOptions(
      {required this.mode,
        required this.classifyObjects,
        required this.multipleObjects});

  /// Returns a json representation of an instance of [ObjectDetectorOptions].
  Map<String, dynamic> toJson() => {
    'mode': mode.index,
    'type': type.name,
    'classify': classifyObjects,
    'multiple': multipleObjects,
  };
}


class LocalObjectDetectorOptions extends ObjectDetectorOptions {
  /// Indicates that it uses a custom local model to process images.
  @override
  final ObjectDetectorType type = ObjectDetectorType.local;

  final int maximumLabelsPerObject;
  final double confidenceThreshold;
  final String modelPath;

  LocalObjectDetectorOptions(
      {required DetectionMode mode,
        required this.modelPath,
        required bool classifyObjects,
        required bool multipleObjects,
        this.maximumLabelsPerObject = 10,
        this.confidenceThreshold = 0.5}
      ) : super(
      mode: mode,
      classifyObjects: classifyObjects,
      multipleObjects: multipleObjects
  );
}