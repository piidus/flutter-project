
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

class ImageTaker extends StatefulWidget {
  const ImageTaker({super.key, required this.imageTake});
  final Function(Uint8List pickedImageBytes) imageTake;

  @override
  State<ImageTaker> createState() => _ImageTakerState();
}

class _ImageTakerState extends State<ImageTaker> {
  Uint8List? _capturedImageBytes;
  CameraController? cameraController;
  List<CameraDescription> cameras = [];
  bool isCameraInitialized = false;

  final GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initializeCameraForWeb();
    }
  }

  Future<void> _initializeCameraForWeb() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController = CameraController(
          cameras.first,
          ResolutionPreset.high,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );
        await cameraController!.initialize();
        if (mounted) {
          setState(() {
            isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      print("Camera initialization error on web: $e");
      if (mounted) {
        setState(() {
          isCameraInitialized = false;
        });
      }
    }
  }

  void imageHandler() async {
    XFile? pickedImage;

    if (kIsWeb) {
      print('kisweb');
      print('isCameraInitialized: $isCameraInitialized');
      print('cameraController: $cameraController');
      if (isCameraInitialized && cameraController != null) {
        pickedImage = await cameraController!.takePicture();
        print('Camera image taken: ${pickedImage.path}');
      }
    } else {
      final imagePicker = ImagePicker();
      pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );
    }

    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();
      widget.imageTake(imageBytes);

      setState(() {
        _capturedImageBytes = imageBytes;
      });
    }
  }

  void _takeScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes != null) {
        // Use the captured image for preview and pass it to the widget's function.
        widget.imageTake(pngBytes);
        setState(() {
          _capturedImageBytes = pngBytes;
        });
      }
    } catch (e) {
      print("Screenshot capture failed: $e");
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (kIsWeb && isCameraInitialized) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            key: _repaintBoundaryKey,
            child: AspectRatio(
              aspectRatio: cameraController!.value.aspectRatio,
              child: CameraPreview(cameraController!),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _takeScreenshot,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Take Screenshot',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (_capturedImageBytes != null) {
      content = GestureDetector(
        onTap: imageHandler,
        child: Image.memory(
          _capturedImageBytes!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    } else {
      content = GestureDetector(
        onTap: imageHandler,
        child: const Icon(
          Icons.camera_alt,
          size: 80,
          color: Colors.grey,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: content),
    );
  }
}
