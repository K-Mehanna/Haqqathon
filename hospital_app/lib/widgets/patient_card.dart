import 'package:flutter/material.dart';
import 'package:hospital_app/patient_detail.dart';
import 'package:hospital_app/patient_model.dart';
import 'package:intl/intl.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;

  const PatientCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          patient.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
          ),
        ),
        subtitle: Text('Age: ${patient.age}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Date Last Visited: ${DateFormat.yMd().add_jm().format(patient.lastVisit)}',
                    style: TextStyle(fontSize: 16)),
                Text('Doctor: ${patient.doctor}',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PatientDetailScreen(patient: patient),
                      ),
                    );
                  },
                  child: Text('View Full Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}