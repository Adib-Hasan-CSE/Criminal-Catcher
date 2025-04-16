import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'crime_reporting_screen.dart';
import 'profile_screen.dart';
import 'announcement_screen.dart';
import 'edit_profile_screen.dart';
import 'track_fir_screen.dart';
import 'update_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String email;

  HomeScreen({required this.username, required this.email});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _username = "Loading...";
  String _email = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection("users").doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _username = userDoc["name"] ?? "No Name";
          _email = user.email ?? "No Email";
        });
      }
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Crime Detection And Reporting",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900]),
            ),
            SizedBox(height: 10),
            Text(
              "Our mission is to empower individuals and communities to take action against crime by providing them with the tools they need to detect, report, and prevent crime.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "Contact Us:",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900]),
            ),
            SizedBox(height: 5),
            Text("Email:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("hasan15-5002@diu.edu.bd",
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(height: 5),
            Text("Phone:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("01568076436",
                style: TextStyle(fontSize: 16, color: Colors.black87)),
          ],
        ),
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              _username,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(_email, style: TextStyle(fontSize: 16)),
          ),
          _buildDrawerItem(Icons.report, "Report FIR", Colors.deepPurple,
              () => _navigateTo(CrimeReportingScreen())),
          _buildDrawerItem(Icons.person, "Profile", Colors.blue,
              () => _navigateTo(ProfileScreen())),
          _buildDrawerItem(Icons.announcement, "Announcements", Colors.orange,
              () => _navigateTo(AnnouncementScreen())),
          _buildDrawerItem(Icons.track_changes, "Track FIR", Colors.green,
              () => _navigateTo(TrackFirScreen())),
          _buildDrawerItem(Icons.update, "Update Information", Colors.teal,
              () => _navigateTo(UpdateScreen())),
          Divider(),
          _buildDrawerItem(Icons.logout, "Logout", Colors.redAccent, _logout),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color, size: 26),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
