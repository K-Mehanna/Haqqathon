import 'package:flutter/material.dart';
import 'package:hospital_app/patient_model.dart';

class PatientDetailScreen extends StatelessWidget {
  final Patient patient;

  const PatientDetailScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${patient.name}'),
            Text('Age: ${patient.age}'),
            Text('Date Last Visited: ${patient.lastVisit}'),
            Text('Doctor: ${patient.doctor}'),
            SizedBox(height: 20),
            Text('Dental Notes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Text(patient.dentalNotes),
            Text('Medical Notes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(patient.medicalNotes),
          ],
        ),
      ),
    );
  }
}
