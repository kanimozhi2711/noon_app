import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:noon_app/AppConfig.dart';

class ApiService {
  // Future<String> detectPlatform() async {
  //   if (kIsWeb) {
  //     return "Web Browser";
  //   } else if (Platform.isAndroid) {
  //     bool isEmulator = await checkIfEmulator();
  //     return isEmulator ? "Android Emulator" : "Android Device";
  //   } else if (Platform.isIOS) {
  //     bool isEmulator = await checkIfEmulator();
  //     return isEmulator ? "iPhone Simulator" : "iPhone Device";
  //   } else {
  //     return "Unknown Platform";
  //   }
  // }
  //
  //static const String baseUrl = "http://localhost:5000";

  //static const String baseUrl = "http://10.0.2.2:5000";
  // static String baseUrl = "http://localhost:5000";
  //
  // Future<String> getBaseUrl() async {
  //   String platform = await detectPlatform();
  //   if (platform == "Web Browser") {
  //     baseUrl = "http://localhost:5000";
  //   } else if (platform == "Android Emulator") {
  //     return "http://10.0.2.2:5000";
  //   } else {
  //     return "http://192.168.1.100:5000"; // Use PC's local IP for real devices
  //   }
  // }

  // Fetch all products
  static Future<List<dynamic>> fetchProducts() async {
    String baseUrl = await AppConfig.getBaseUrl();
    final response = await http.get(Uri.parse("$baseUrl/products"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
      String baseUrl = await AppConfig.getBaseUrl();
    } else {
      throw Exception("Failed to load products");
    }
  }

  // Add a new product
  static Future<void> addProduct(
      String name, String description, double price, dynamic imageUrl) async {
    if (kIsWeb) {
      String baseUrl = await AppConfig.getBaseUrl();
      String base64Image = base64Encode(imageUrl as Uint8List);
      final response = await http.post(Uri.parse("$baseUrl/products"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": name,
            "description": description,
            "price": price,
            "image_url": base64Image,
          }));
      if (response.statusCode == 200) {
        print("✅ Product added successfully!");
      } else {
        print("❌ Failed to add product: ${response.body}");
      }
    } else {
      String baseUrl = await AppConfig.getBaseUrl();
      var request =
          http.MultipartRequest("POST", Uri.parse("$baseUrl/uploads"));
      request.fields["name"] = name;
      request.fields["description"] = description;
      request.fields["price"] = price.toString();
      request.files
          .add(await http.MultipartFile.fromPath("image", imageUrl.path));
    }
  }

  static Future<void> addBannerList(
      String name, String description, double price, dynamic imageUrl) async {
    if (kIsWeb) {
      String baseUrl = await AppConfig.getBaseUrl();
      String base64Image = base64Encode(imageUrl as Uint8List);
      final response = await http.post(Uri.parse("$baseUrl/products"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": name,
            "description": description,
            "price": price,
            "image_url": base64Image,
          }));
      if (response.statusCode == 200) {
        print("✅ Product added successfully!");
      } else {
        print("❌ Failed to add product: ${response.body}");
      }
    } else {
      String baseUrl = await AppConfig.getBaseUrl();
      var request =
          http.MultipartRequest("POST", Uri.parse("$baseUrl/uploads"));
      request.fields["name"] = name;
      request.fields["description"] = description;
      request.fields["price"] = price.toString();
      request.files
          .add(await http.MultipartFile.fromPath("image", imageUrl.path));
    }
  }

  Future<bool> checkIfEmulator() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return (androidInfo.isPhysicalDevice == false);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return (iosInfo.isPhysicalDevice == false);
    }
    return false;
  }
}
