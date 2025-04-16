import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _profileImageUrl;
  String _name = "";
  String _address = "";
  String _gender = "";
  String _occupation = "";
  String _nationality = "";
  String _religion = "";
  String _dob = "";

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _loadUserData();
  }

  void _loadUserData() async {
    if (_user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection("users").doc(_user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          _name = userDoc["name"] ?? "";
          _address = userDoc["address"] ?? "";
          _gender = userDoc["gender"] ?? "";
          _occupation = userDoc["occupation"] ?? "";
          _nationality = userDoc["nationality"] ?? "";
          _religion = userDoc["religion"] ?? "";
          _dob = userDoc["dob"] ?? "";
          _profileImageUrl = userDoc["profileImage"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 20),
            _buildProfileInfo("Full Name", _name),
            _buildProfileInfo("Address", _address),
            _buildProfileInfo("Gender", _gender),
            _buildProfileInfo("Occupation", _occupation),
            _buildProfileInfo("Nationality", _nationality),
            _buildProfileInfo("Religion", _religion),
            _buildProfileInfo("Date of Birth", _dob),
            SizedBox(height: 30),
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 65,
            backgroundColor: Colors.grey[300],
            backgroundImage: _profileImageUrl != null
                ? NetworkImage(_profileImageUrl!)
                : AssetImage("assets/default_profile.png"),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileScreen(
                  onProfileUpdated: () {
                    _loadUserData();
                  },
                ),
              ),
            ).then((updated) {
              if (updated == true) {
                _loadUserData();
              }
            });
          },
          child: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.edit, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          label,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value.isNotEmpty ? value : "Not set",
          style: TextStyle(fontSize: 16),
        ),
        leading: Icon(Icons.info, color: Colors.deepPurple),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(
              onProfileUpdated: () {
                _loadUserData();
              },
            ),
          ),
        ).then((updated) {
          if (updated == true) {
            _loadUserData();
          }
        });
      },
      icon: Icon(Icons.update, color: Colors.white),
      label: Text("Update Profile",
          style: TextStyle(fontSize: 16, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
      ),
    );
  }
}
