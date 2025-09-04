// import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class ImageTaker extends StatefulWidget {
  // Correct the type to accept a platform-independent Uint8List
  const ImageTaker({super.key, required this.imageTake});
  final Function(Uint8List pickedImageBytes) imageTake;

  @override
  State<ImageTaker> createState() => _ImageTakerState();
}

class _ImageTakerState extends State<ImageTaker> {
  // Use XFile to store the picked image, as it's the return type of both methods.
  XFile? pickedImageFile;

  // CameraController and other variables for web live camera
  CameraController? cameraController;
  List<CameraDescription> cameras = [];
  bool isCameraInitialized = false;

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
      if (isCameraInitialized && cameraController != null) {
        pickedImage = await cameraController!.takePicture();
      }
    } else {
      final imagePicker = ImagePicker();
      pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );
    }

    if (pickedImage != null) {
      // Correctly read bytes and pass to the callback. This is platform-agnostic.
      final imageBytes = await pickedImage.readAsBytes();
      widget.imageTake(imageBytes);

      setState(() {
        pickedImageFile = pickedImage;
      });
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
    if (pickedImageFile != null) {
      // You must use the bytes to display the image.
      content = GestureDetector(
        onTap: imageHandler,
        child: FutureBuilder<Uint8List>(
          future: pickedImageFile!.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              return Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
                width: double.infinity,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      );
    } else {
      if (kIsWeb && isCameraInitialized) {
        content = GestureDetector(
          onTap: imageHandler,
          child: AspectRatio(
            aspectRatio: cameraController!.value.aspectRatio,
            child: CameraPreview(cameraController!),
          ),
        );
      } else {
        content = GestureDetector(
          onTap: imageHandler,
          child: const Icon(
            Icons.camera_alt,
            size: 80,
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: content,
    );
  }
}