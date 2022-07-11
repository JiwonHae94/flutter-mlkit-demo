import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../ml/object_detection.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
    required this.title,
    required this.customPaint,
    this.text,
    required this.onImage,
    this.onScreenModeChanged,
    this.initialDirection = CameraLensDirection.back
  }) : super(key: key);

  final CustomPaint? customPaint;
  final CameraLensDirection initialDirection;
  final String title;
  final String? text;

  final Function(InputImage inputImage) onImage;
  final Function(ScreenMode mode)? onScreenModeChanged;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  ScreenMode _mode = ScreenMode.liveFeed;
  CameraController? _controller;
  File? _image;
  ImagePicker? _imagePicker;
  int _cameraIndex = 0;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  final bool _allowPicker = true;
  bool _changingCameraLens = false;

  List<CameraDescription> cameras = [];

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();

    if(cameras.any(
        (element) =>
            element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90,
    )){
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
          element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 90),
        );
    } else{
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere(
            (element) => element.lensDirection == widget.initialDirection,
        )
      );
    }

    _startLiveFeed();
  }


  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  Future _startLiveFeed() async{
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false
    );
    _controller?.initialize().then((_){
      if(!mounted){
        return;
      }

      _controller?.getMinZoomLevel().then((value){
        zoomLevel = value;
        minZoomLevel = value;
      });

      _controller?.getMaxZoomLevel().then((value){
        zoomLevel = value;
        maxZoomLevel = value;
      });

      _controller?.startImageStream(_processCameraImage);
      setState((){});
    });
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
    Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex];
    final imageRotation =
    InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
    InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
          (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
    InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    widget.onImage(inputImage);
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
