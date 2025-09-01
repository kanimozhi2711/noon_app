import 'package:flutter/material.dart';

class bannerListAddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Second Screen")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Back to First Screen
          },
          child: Text("Go Back"),
        ),
      ),
    );
  }
}
