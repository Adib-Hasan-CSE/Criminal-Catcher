import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrackFirScreen extends StatefulWidget {
  @override
  _TrackFirScreenState createState() => _TrackFirScreenState();
}

class _TrackFirScreenState extends State<TrackFirScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _firStatus =
      "Your FIR has been filled and is currently being reviewed by our team. You will be notified of any updates or changes to your case.";
  double _progressValue = 0.2; // Example progress value

  @override
  void initState() {
    super.initState();
    _getFirStatus();
  }

  // Fetch FIR status from Firestore
  void _getFirStatus() async {
    String userId = _auth.currentUser!.uid;
    DocumentSnapshot firDoc =
        await _firestore.collection("fir_reports").doc(userId).get();
    if (firDoc.exists) {
      setState(() {
        _firStatus = firDoc["status"] ?? "Status not available.";
        _progressValue = _calculateProgress(_firStatus);
      });
    } else {
      setState(() {
        _firStatus = "No FIR found for this user.";
      });
    }
  }

  // Function to determine progress based on status
  double _calculateProgress(String status) {
    switch (status.toLowerCase()) {
      case "filed":
        return 0.2;
      case "under review":
        return 0.5;
      case "processed":
        return 0.8;
      case "completed":
        return 1.0;
      default:
        return 0.1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track FIR"),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Track your FIR",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Progress:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            LinearProgressIndicator(
              value: _progressValue,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 5,
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("0%", style: TextStyle(fontSize: 14)),
                Text("100%", style: TextStyle(fontSize: 14)),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Status:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              _firStatus,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
