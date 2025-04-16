import 'package:flutter/material.dart';

class UpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Updates"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Latest Updates:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "1. Bug fixes in the crime reporting feature.",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "2. UI improvements in the Track FIR screen.",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "3. New functionality to track FIR progress.",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 30),
              Text(
                "Maintenance Schedule:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "The app will undergo maintenance on 10th April from 12 AM to 2 AM.",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
