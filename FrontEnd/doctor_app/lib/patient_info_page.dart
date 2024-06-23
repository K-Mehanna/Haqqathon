import 'package:doctor_app/patient_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientInfoPage extends StatefulWidget {
  const PatientInfoPage({super.key});
  
  @override
  State<PatientInfoPage> createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late String _patientName;
  late String _villageName;
  late String _doctorName;
  DateTime _timestamp = DateTime.now();
  late int _age;
  Gender _gender = Gender.male;
  Priority _priority = Priority.low;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final patientInfo = PatientInfo(
        patientName: _patientName,
        villageName: _villageName,
        doctorName: _doctorName,
        timestamp: _timestamp,
        age: _age,
        gender: _gender,
        priority: _priority,
      );
      Navigator.pop(context, patientInfo);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _timestamp,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _timestamp) {
      setState(() {
        _timestamp = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Patient Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter patient name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _patientName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Village Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter village name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _villageName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Doctor Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter doctor name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _doctorName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _age = int.parse(value!);
                },
              ),
              DropdownButtonFormField<Gender>(
                decoration: InputDecoration(labelText: 'Gender'),
                value: _gender,
                items: Gender.values.map((Gender gender) {
                  return DropdownMenuItem<Gender>(
                    value: gender,
                    child: Text(gender.name),
                  );
                }).toList(),
                onChanged: (Gender? newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
                onSaved: (value) {
                  _gender = value!;
                },
              ),
              DropdownButtonFormField<Priority>(
                decoration: InputDecoration(labelText: 'Priority'),
                value: _priority,
                items: Priority.values.map((Priority priority) {
                  return DropdownMenuItem<Priority>(
                    value: priority,
                    child: Text(priority.name),
                  );
                }).toList(),
                onChanged: (Priority? newValue) {
                  setState(() {
                    _priority = newValue!;
                  });
                },
                onSaved: (value) {
                  _priority = value!;
                },
              ),
              ListTile(
                title: Text("Date: ${DateFormat('yyyy-MM-dd').format(_timestamp)}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
