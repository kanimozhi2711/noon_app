import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'api_service.dart';
import 'bannerListAddPage.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  Uint8List? _webimage;
  XFile? _mobileImage;

  dynamic _image;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  // File? _image;
  final picker = ImagePicker();
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        var webimage = await pickedFile.readAsBytes();
        setState(() {
          _image = webimage;
        });
      } else {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
      setState(() {});
    }
  }

  Future addProduct() async {
    if (_image == null || nameController.text.isEmpty) return;
    try {
      await ApiService.addProduct(nameController.text, descController.text,
          double.parse(priceController.text), _image);
      Navigator.pop(context);
    } catch (e) {
      print("Error adding product: $e");
    }
  }

  Future addBannerList() async {
    if (_image == null || nameController.text.isEmpty) return;
    try {
      await ApiService.addProduct(nameController.text, descController.text,
          double.parse(priceController.text), _image);
      Navigator.pop(context);
    } catch (e) {
      print("Error adding product: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name")),
            TextField(
                controller: descController,
                decoration: InputDecoration(labelText: "Description")),
            TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Price")),
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15), // Rounded corners
                child: SizedBox(
                  height: 200, // ✅ Limit image height
                  width: 200, // ✅ Limit image width
                  child: kIsWeb
                      ? Image.memory(_image as Uint8List, fit: BoxFit.cover)
                      : Image.file(_image as File, fit: BoxFit.cover),
                ),
              )
            else
              Text("No image selected"),
            ElevatedButton(onPressed: pickImage, child: Text("Pick Image")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: addProduct, child: Text("Add Product")),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => bannerListAddPage()),
                  );
                },
                child: Text("Add BannerList")),
          ],
        ),
      ),
    );
  }
}
