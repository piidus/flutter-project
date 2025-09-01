import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class ImageTaker extends StatefulWidget {
  const ImageTaker({super.key});

  @override
  State<ImageTaker> createState() => _ImageTakerState();
}

class _ImageTakerState extends State<ImageTaker> {
  File? imageFile;
  
  // define platform
  void imageHandler()async{ 
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera,
                    maxWidth: 50);
    if(pickedImage==null){
      return;
    }
    else{
      setState(() {
         imageFile = File(pickedImage.path);
      });
       
   
    }


  }
  // void imageHandler() async {
  //   imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        icon: const Icon(Icons.camera_alt),
        onPressed: imageHandler,

        label: const Text('Take Picture', style: TextStyle(color: Colors.white),),
      );
    if (imageFile != null) {
      content =  Image.file(
        imageFile!,
        // width: 100,
        // height: 100,
        fit: BoxFit.cover,
      );
    }
    // return Center(
    return Container(
      height: 100,
      width: 100,

      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: content
    );
  }
}
// ···
// class MyCameraDelegate extends ImagePickerCameraDelegate {
//   @override
//   Future<XFile?> takePhoto(
//       {ImagePickerCameraDelegateOptions options =
//           const ImagePickerCameraDelegateOptions()}) async {
//     return _takeAPhoto(options.preferredCameraDevice);
//   }

//   @override
//   Future<XFile?> takeVideo(
//       {ImagePickerCameraDelegateOptions options =
//           const ImagePickerCameraDelegateOptions()}) async {
//     return _takeAVideo(options.preferredCameraDevice);
//   }
  
//   Future<XFile?> _takeAPhoto(CameraDevice preferredCameraDevice) async {
//     return null;
//   }
  
//   Future<XFile?> _takeAVideo(CameraDevice preferredCameraDevice) async {
//     return null;
//   }
// }
// // ···
// void setUpCameraDelegate() {
//   final ImagePickerPlatform instance = ImagePickerPlatform.instance;
//   if (instance is CameraDelegatingImagePickerPlatform) {
//     instance.cameraDelegate = MyCameraDelegate();
//   }
// }