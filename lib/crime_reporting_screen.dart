import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class CrimeReportingScreen extends StatefulWidget {
  @override
  _CrimeReportingScreenState createState() => _CrimeReportingScreenState();
}

class _CrimeReportingScreenState extends State<CrimeReportingScreen> {
  int _activeStepIndex = 0;
  final _formKey = GlobalKey<FormState>();

  String startDate = "";
  String endDate = "";
  String dob = "";
  double? latitude;
  double? longitude;

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController occupation = TextEditingController();
  TextEditingController nid = TextEditingController();

  TextEditingController offenderName = TextEditingController();
  TextEditingController offenceType = TextEditingController();
  TextEditingController offencePlace = TextEditingController();
  TextEditingController details = TextEditingController();

  TextEditingController suspectAge = TextEditingController();
  TextEditingController suspectBuild = TextEditingController();
  TextEditingController suspectComplexion = TextEditingController();
  TextEditingController suspectDeformities = TextEditingController();
  TextEditingController suspectDialect = TextEditingController();
  TextEditingController suspectGender = TextEditingController();
  TextEditingController suspectHeight = TextEditingController();
  TextEditingController suspectMarks = TextEditingController();

  Future<void> _saveFormData() async {
    await Future.delayed(Duration(milliseconds: 100));

    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: 'Please fill all required fields.');
      return;
    }

    if (latitude == null || longitude == null) {
      Fluttertoast.showToast(msg: 'Please capture location before submitting.');
      return;
    }

    // Use Firestore to store FIR under 'client' collection
    CollectionReference collRef =
        FirebaseFirestore.instance.collection('client');

    Map<String, dynamic> formData = {
      'name': name.text,
      'phone': phone.text,
      'dob': dob,
      'address': address.text,
      'NID': nid.text,
      'occupation': occupation.text,
      'nationality': nationality.text,
      'offenderName': offenderName.text,
      'startDate': startDate,
      'endDate': endDate,
      'offenceType': offenceType.text,
      'offencePlace': offencePlace.text,
      'details': details.text,
      'suspectGender': suspectGender.text,
      'suspectAge': suspectAge.text,
      'suspectBuild': suspectBuild.text,
      'suspectHeight': suspectHeight.text,
      'suspectComplexion': suspectComplexion.text,
      'suspectDeformities': suspectDeformities.text,
      'suspectDialect': suspectDialect.text,
      'suspectMarks': suspectMarks.text,
      'latitude': latitude,
      'longitude': longitude,
      'status': "Registered",
      'progressValue': 0.2,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await collRef.add(formData);

      Fluttertoast.showToast(msg: "FIR Submitted Successfully!");
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to submit FIR.");
      print("Firestore Error: $e");
    }
  }

  Future<void> _getCurrentLocation() async {
    Fluttertoast.showToast(msg: 'Getting location...');

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: 'Location permissions are permanently denied.');
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      Fluttertoast.showToast(msg: 'Location Captured!');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to get location.');
    }
  }

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: Text('Personal Information'),
          content: Column(
            children: [
              _buildFormTextField(name, 'Full Name'),
              _buildFormTextField(phone, 'Mobile No'),
              DateTimePicker(
                initialValue: '',
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                dateLabelText: 'Date of Birth',
                onChanged: (val) => dob = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                decoration: _buildInputDecoration('Date of Birth'),
              ),
              _buildFormTextField(address, 'Full Address'),
              _buildFormTextField(nid, 'NID number'),
              _buildFormTextField(occupation, 'Occupation'),
              _buildFormTextField(nationality, 'Nationality'),
            ],
          ),
        ),
        Step(
          state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 1,
          title: Text('Details of Incident'),
          content: Column(
            children: [
              _buildFormTextField(offenderName, 'Name of Offender'),
              DateTimePicker(
                initialValue: '',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Occurrence from',
                onChanged: (val) => startDate = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                decoration: _buildInputDecoration('Occurrence from'),
              ),
              DateTimePicker(
                initialValue: '',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Occurrence until',
                onChanged: (val) => endDate = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                decoration: _buildInputDecoration('Occurrence until'),
              ),
              _buildFormTextField(offenceType, 'Type of Offence'),
              _buildFormTextField(offencePlace, 'Place of Offence'),
              _buildFormTextField(details, 'Complete details of the event'),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _getCurrentLocation,
                icon: Icon(Icons.location_on),
                label: Text("Get Current Location"),
              ),
              if (latitude != null && longitude != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("Location: $latitude, $longitude"),
                ),
            ],
          ),
        ),
        Step(
          state: _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 2,
          title: Text('Details of Suspect'),
          content: Column(
            children: [
              _buildFormTextField(suspectGender, 'Sex'),
              _buildFormTextField(suspectAge, 'Age'),
              _buildFormTextField(suspectBuild, 'Build'),
              _buildFormTextField(suspectHeight, 'Height'),
              _buildFormTextField(suspectComplexion, 'Complexion'),
              _buildFormTextField(suspectDeformities, 'Deformities'),
              _buildFormTextField(suspectDialect, 'Dialect'),
              _buildFormTextField(suspectMarks, 'Visible Body Marks'),
            ],
          ),
        ),
        Step(
          state: StepState.complete,
          isActive: _activeStepIndex >= 3,
          title: Text('Confirm'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConfirmText('Full Name', name.text),
              _buildConfirmText('Mobile No', phone.text),
              _buildConfirmText('DOB', dob),
              _buildConfirmText('Address', address.text),
              _buildConfirmText('NID', nid.text),
              _buildConfirmText('Occupation', occupation.text),
              _buildConfirmText('Nationality', nationality.text),
              _buildConfirmText('Offender', offenderName.text),
              _buildConfirmText('Offence From', startDate),
              _buildConfirmText('Offence Until', endDate),
              _buildConfirmText('Type', offenceType.text),
              _buildConfirmText('Place', offencePlace.text),
              _buildConfirmText('Details', details.text),
              if (latitude != null && longitude != null)
                _buildConfirmText(
                    'Location Coordinates', '$latitude, $longitude'),
              _buildConfirmText('Gender', suspectGender.text),
              _buildConfirmText('Age', suspectAge.text),
              _buildConfirmText('Build', suspectBuild.text),
              _buildConfirmText('Height', suspectHeight.text),
              _buildConfirmText('Complexion', suspectComplexion.text),
              _buildConfirmText('Deformities', suspectDeformities.text),
              _buildConfirmText('Dialect', suspectDialect.text),
              _buildConfirmText('Marks', suspectMarks.text),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _saveFormData,
                  icon: Icon(Icons.check, color: Colors.white),
                  label: Text(
                    "Submit FIR",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
              )
            ],
          ),
        ),
      ];

  Widget _buildFormTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
        decoration: _buildInputDecoration(label),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.indigo)),
    );
  }

  Widget _buildConfirmText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$label: $value',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("FIR Reporting"),
          backgroundColor: Colors.deepPurple),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          steps: stepList(),
          currentStep: _activeStepIndex,
          onStepTapped: (index) => setState(() => _activeStepIndex = index),
          onStepContinue: () {
            if (_activeStepIndex < stepList().length - 1) {
              setState(() => _activeStepIndex++);
            }
          },
          onStepCancel: () {
            if (_activeStepIndex > 0) {
              setState(() => _activeStepIndex--);
            }
          },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            if (_activeStepIndex == stepList().length - 1) {
              return const SizedBox.shrink(); // No buttons in Confirm step
            }
            return Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: const Text('Continue'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Back'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
