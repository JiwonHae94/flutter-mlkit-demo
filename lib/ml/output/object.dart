import 'dart:ui';

import '../object_detection.dart';
import 'object_label.dart';

class DetectedObject{
  final int? trakingId;
  final Rect boundingBox;
  final List<Label> labels;

  DetectedObject({required this.trakingId, required this.boundingBox, required this.labels});

  factory DetectedObject.fromJson(Map<dynamic, dynamic> json) {
    final labels = <Label>[];
    for(final dynamic label in json['labels']){
      labels.add(label);
    }

    return DetectedObject(
        trakingId: json['trackingId'],
        boundingBox: RectJson.fromJson(json['rect']),
        labels: labels
    );
  }


}