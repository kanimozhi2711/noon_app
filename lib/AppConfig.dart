import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class AppConfig {
  static String baseUrl = "http://localhost:5000";

  // Function to get the base URL dynamically based on the platform
  static Future<String> getBaseUrl() async {
    String platform = await detectPlatform();
    if (platform == "Web Browser") {
      baseUrl = "http://localhost:5000"; // Use for web
    } else if (platform == "Android Emulator") {
      baseUrl = "http://10.0.2.2:5000"; // Use for Android Emulator
    } else if (platform == "Android Device" || platform == "iPhone Device") {
      baseUrl = "http://192.168.1.123:5000"; // Use for real devices
    } else {
      // If no matching platform, throw an exception or return a default value
      throw Exception("Unknown platform detected");
    }
    return baseUrl; // Return the updated base URL
  }

  // Detect the platform (Web, Android Emulator, or real device)
  static Future<String> detectPlatform() async {
    if (kIsWeb) {
      return "Web Browser";
    } else if (Platform.isAndroid) {
      bool isEmulator = await checkIfEmulator();
      return isEmulator ? "Android Emulator" : "Android Device";
    } else if (Platform.isIOS) {
      bool isEmulator = await checkIfEmulator();
      return isEmulator ? "iPhone Simulator" : "iPhone Device";
    }
    return "Unknown Platform"; // Default case, never return null
  }

  // Check if the device is an emulator
  static Future<bool> checkIfEmulator() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return !androidInfo.isPhysicalDevice; // True if it's an emulator
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return !iosInfo.isPhysicalDevice; // True if it's a simulator
    }
    return false;
  }
}
