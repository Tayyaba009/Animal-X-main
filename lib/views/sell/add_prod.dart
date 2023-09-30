import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProd extends StatefulWidget {
  const AddProd({Key? key}) : super(key: key);

  @override
  State<AddProd> createState() => _AddProdState();
}

class _AddProdState extends State<AddProd> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  File? imageFile;
  String? imageUrl;

  File? videoFile;
  String? videoUrl;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> categoriesList = [];
  String selectedCategory = "";

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('categories').get();

      List<String> newCategoriesList = [];

      for (final doc in snapshot.docs) {
        final categoryName = doc['name'];
        newCategoriesList.add(categoryName);
      }

      setState(() {
        categoriesList.clear();
        categoriesList.addAll(newCategoriesList);
        if (categoriesList.isNotEmpty) {
          selectedCategory = categoriesList[0]; // Set the default category
        }
      });
    } catch (e) {
      print('Firestore Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                const Text(
                  "Want to Sell any Animal. Add here",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 115,
                            width: 115,
                            child: Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                CircleAvatar(
                                  radius: 0.0,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: (imageFile != null)
                                      ? Image.file(
                                    imageFile!,
                                    fit: BoxFit.cover,
                                  ).image
                                      : const NetworkImage(
                                      "https://media.gettyimages.com/id/157482029/photo/stack-of-books.jpg?s=612x612&w=gi&k=20&c=_Yaofm8sZLZkKs1eMkv-zhk8K4k5u0g0fJuQrReWfdQ="),
                                ),
                                Positioned(
                                  right: -16,
                                  bottom: 0,
                                  child: SizedBox(
                                    height: 46,
                                    width: 46,
                                    child: GestureDetector(
                                      onTap: getImage,
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.blue,
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.add_a_photo,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Add image of the animal",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        GestureDetector(
                          onTap: getVideo,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.video_library,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Upload Video',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            hintText: "Enter Name of the Animal",
                            labelText: "Animal Name",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Animal Name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: priceController,
                          decoration: const InputDecoration(
                            hintText: "Enter Price",
                            labelText: "Price",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Price is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: quantityController,
                          decoration: const InputDecoration(
                            hintText: "Enter Quantity",
                            labelText: "Quantity",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Quantity is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: phoneController,
                          decoration: const InputDecoration(
                            hintText: "Enter Your Phone Number",
                            labelText: "Phone Number",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone Number is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: ageController,
                          decoration: const InputDecoration(
                            hintText: "Enter Age",
                            labelText: "Age",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Age is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: weightController,
                          decoration: const InputDecoration(
                            hintText: "Enter Weight",
                            labelText: "Weight",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Weight is required';
                            }
                            // You can add additional validation for alphanumeric here.
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            hintText: "Enter Description",
                            labelText: "Description",
                          ),
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const SizedBox(height: 20),

                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          items: categoriesList.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue ?? "";
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: "Category",
                            hintText: "Select a category",
                          ),
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              addToFirestore();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF6C08B),
                          ),
                          child: Text("Add to list"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        imageFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> getVideo() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      setState(() {
        videoFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> addToFirestore() async {
    try {
      final String title = titleController.text;
      final double price = double.tryParse(priceController.text) ?? 0.0;
      final String phone = phoneController.text;
      final int quantity = int.tryParse(quantityController.text) ?? 0;
      final String age = ageController.text;
      final String weight = weightController.text;
      final String description = descriptionController.text;

      if (title.isEmpty || price <= 0 || quantity <= 0 || phone.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text('Please enter valid data.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      if (videoFile != null) {
        final String videoName =
        DateTime.now().microsecondsSinceEpoch.toString();
        final Reference storageRef =
        FirebaseStorage.instance.ref().child('videos/$videoName.mp4');

        UploadTask uploadTask = storageRef.putFile(videoFile!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        videoUrl = downloadUrl;
      }

      if (imageFile != null) {
        final String imageName =
        DateTime.now().microsecondsSinceEpoch.toString();
        final Reference storageRef =
        FirebaseStorage.instance.ref().child('images/$imageName.jpg');

        UploadTask uploadTask = storageRef.putFile(imageFile!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        imageUrl = downloadUrl;
      }

      await FirebaseFirestore.instance.collection('addprod').add({
        'title': title,
        'price': price,
        'quantity': quantity,
        'phone': phone,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'age': age,
        'weight': weight,
        'description': description,
        'category': selectedCategory,
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Product added successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetFields();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Firestore Error: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to add product: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void resetFields() {
    titleController.clear();
    priceController.clear();
    quantityController.clear();
    phoneController.clear();
    ageController.clear();
    weightController.clear();
    descriptionController.clear();

    setState(() {
      imageFile = null;
      imageUrl = null;
      videoFile = null;
      videoUrl = null;
      selectedCategory = categoriesList.isNotEmpty ? categoriesList[0] : "";
    });
  }
}

void main() {
  runApp(
    MaterialApp(
      home: AddProd(),
    ),
  );
}
