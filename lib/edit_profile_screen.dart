import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  final VoidCallback onProfileUpdated; // Callback function

  EditProfileScreen({required this.onProfileUpdated});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _religionController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

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
          _nameController.text = userDoc["name"] ?? "";
          _addressController.text = userDoc["address"] ?? "";
          _genderController.text = userDoc["gender"] ?? "";
          _occupationController.text = userDoc["occupation"] ?? "";
          _nationalityController.text = userDoc["nationality"] ?? "";
          _religionController.text = userDoc["religion"] ?? "";
          _dobController.text = userDoc["dob"] ?? "";
        });
      }
    }
  }

  void _updateUserData() async {
    if (_user != null) {
      await _firestore.collection("users").doc(_user!.uid).update({
        "name": _nameController.text,
        "address": _addressController.text,
        "gender": _genderController.text,
        "occupation": _occupationController.text,
        "nationality": _nationalityController.text,
        "religion": _religionController.text,
        "dob": _dobController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile Updated Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      widget.onProfileUpdated(); // Refresh Profile
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title:
            Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold)),
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
            _buildTextField("Full Name", _nameController, Icons.person),
            _buildTextField("Address", _addressController, Icons.home),
            _buildTextField("Gender", _genderController, Icons.wc),
            _buildTextField("Occupation", _occupationController, Icons.work),
            _buildTextField("Nationality", _nationalityController, Icons.flag),
            _buildTextField("Religion", _religionController, Icons.book),
            _buildTextField(
                "Date of Birth", _dobController, Icons.calendar_today),
            SizedBox(height: 30),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: _updateUserData,
      icon: Icon(Icons.save, color: Colors.white),
      label: Text("Save Changes",
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
