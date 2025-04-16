import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CrimeReportingScreen extends StatefulWidget {
  @override
  _CrimeReportingScreenState createState() => _CrimeReportingScreenState();
}

class _CrimeReportingScreenState extends State<CrimeReportingScreen> {
  int _activeStepIndex = 0;

  String startDate = "";
  String endDate = "";
  String dob = "";

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

  void _saveFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? formDataList = prefs.getStringList('formDataList');
    if (formDataList == null) {
      formDataList = [];
    }

    Map<String, dynamic> formData = {
      'id': UniqueKey().toString(),
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
      'status': "Registered",
      'progressValue': 0.2,
    };

    formDataList.add(json.encode(formData));
    await prefs.setStringList('formDataList', formDataList);
    Fluttertoast.showToast(msg: "Crime Reported Successfully!");
    Navigator.pop(context);
  }

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: Text('Personal Information',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            children: [
              _buildCustomTextField(name, 'Full Name'),
              _buildCustomTextField(phone, 'Mobile No'),
              DateTimePicker(
                initialValue: '',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Date of Birth',
                onChanged: (val) => dob = val,
                validator: (val) {
                  dob = val!;
                  return null;
                },
                onSaved: (val) => dob = val!,
                decoration: _buildInputDecoration('Date of Birth'),
              ),
              const SizedBox(height: 10),
              _buildCustomTextField(address, 'Full Address'),
              _buildCustomTextField(nid, 'NID number'),
              _buildCustomTextField(occupation, 'Occupation'),
              _buildCustomTextField(nationality, 'Nationality'),
            ],
          ),
        ),
        Step(
          state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 1,
          title: Text('Details of Incident/Offence',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            children: [
              _buildCustomTextField(offenderName, 'Name of Offender'),
              DateTimePicker(
                initialValue: '',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Occurrence of offence from',
                onChanged: (val) => startDate = val,
                validator: (val) {
                  startDate = val!;
                  return null;
                },
                onSaved: (val) => startDate = val!,
                decoration: _buildInputDecoration('Occurrence of offence from'),
              ),
              DateTimePicker(
                initialValue: '',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Occurrence of offence until',
                onChanged: (val) => endDate = val,
                validator: (val) {
                  endDate = val!;
                  return null;
                },
                onSaved: (val) => endDate = val!,
                decoration:
                    _buildInputDecoration('Occurrence of offence until'),
              ),
              _buildCustomTextField(offenceType, 'Type of Offence'),
              _buildCustomTextField(offencePlace, 'Place of Offence'),
              _buildCustomTextField(details, 'Complete details of the event'),
            ],
          ),
        ),
        Step(
          state: _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 2,
          title: Text('Details of Suspect',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            children: [
              _buildCustomTextField(suspectGender, 'Sex'),
              _buildCustomTextField(suspectAge, 'Age of Suspect'),
              _buildCustomTextField(suspectBuild, 'Build of Suspect'),
              _buildCustomTextField(suspectHeight, 'Height of Suspect'),
              _buildCustomTextField(suspectComplexion, 'Complexion of Suspect'),
              _buildCustomTextField(
                  suspectDeformities, 'Deformities of Suspect'),
              _buildCustomTextField(suspectDialect, 'Dialect of Suspect'),
              _buildCustomTextField(
                  suspectMarks, 'Visible Body Marks of Suspect'),
            ],
          ),
        ),
        Step(
          state: StepState.complete,
          isActive: _activeStepIndex >= 3,
          title: Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConfirmText('Full Name', name.text),
              _buildConfirmText('Mobile No', phone.text),
              _buildConfirmText('Date of Birth', dob),
              _buildConfirmText('Full Address', address.text),
              _buildConfirmText('Aadhar', nid.text),
              _buildConfirmText('Occupation', occupation.text),
              _buildConfirmText('Nationality', nationality.text),
              const SizedBox(height: 10),
              _buildConfirmText('Offender Name', offenderName.text),
              _buildConfirmText('Occurrence of offence from', startDate),
              _buildConfirmText('Occurrence of offence until', endDate),
              _buildConfirmText('Type of offence', offenceType.text),
              _buildConfirmText('Location of offence', offencePlace.text),
              _buildConfirmText('Detail of offence', details.text),
              const SizedBox(height: 10),
              _buildConfirmText('Suspect Sex', suspectGender.text),
              _buildConfirmText('Suspect Age', suspectAge.text),
              _buildConfirmText('Suspect Build', suspectBuild.text),
              _buildConfirmText('Suspect Height', suspectHeight.text),
              _buildConfirmText('Suspect Complexion', suspectComplexion.text),
              _buildConfirmText('Suspect Deformities', suspectDeformities.text),
              _buildConfirmText('Suspect Dialect', suspectDialect.text),
              _buildConfirmText('Suspect Marks', suspectMarks.text),
            ],
          ),
        ),
      ];

  Widget _buildCustomTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.indigo),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo, width: 2),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.indigo),
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.indigo, width: 2),
      ),
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
        backgroundColor: Colors.deepPurple,
        title: const Text("FIR Reporting"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stepper(
          steps: stepList(),
          currentStep: _activeStepIndex,
          onStepTapped: (index) {
            setState(() {
              _activeStepIndex = index;
            });
          },
          onStepContinue: () {
            if (_activeStepIndex < stepList().length - 1) {
              setState(() {
                _activeStepIndex++;
              });
            } else {
              _saveFormData();
            }
          },
          onStepCancel: () {
            if (_activeStepIndex > 0) {
              setState(() {
                _activeStepIndex--;
              });
            }
          },
        ),
      ),
    );
  }
}