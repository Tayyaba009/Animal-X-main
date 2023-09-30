// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// class ImageFilterPage extends StatefulWidget {
//   const ImageFilterPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _ImageFilterPageState createState() => _ImageFilterPageState();
// }

// class _ImageFilterPageState extends State<ImageFilterPage> {
//   File? _selectedImage;
//   File? _filteredImage;

//   Future<void> _pickImage() async {
//     final imagePicker = ImagePicker();
//     final pickedImage =
//         await imagePicker.pickImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//         _filteredImage = null;
//       });
//     }
//   }
// Future<void> _applyFilter() async {
//   if (_selectedImage == null) return;

//   final image = img.decodeImage(_selectedImage!.readAsBytesSync())!;
//   final filteredImage = img.gaussianBlur(image, radius: 55); // Adjust the blur radius as needed

//   final filteredImagePath = 'path_to_store_filtered_image.png';
//   final filteredImageFile = File(filteredImagePath);
//   await filteredImageFile.writeAsBytes(img.encodePng(filteredImage));

//   setState(() {
//     _filteredImage = filteredImageFile;
//   });
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Image Filter App')),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (_selectedImage != null)
//               Image.file(
//                 _filteredImage ?? _selectedImage!,
//               ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: const Text('Select Image'),
//             ),
//             ElevatedButton(
//               onPressed: _applyFilter,
//               child: const Text('Apply Filter'),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Implement the image download functionality
//         },
//         child: const Icon(Icons.download),
//       ),
//     );
//   }
// }
