import 'package:flutter/material.dart';
import 'package:hospital_app/patient_detail.dart';
import 'package:hospital_app/patient_model.dart';

class DashboardScreen extends StatefulWidget {
  final int villageId;

  const DashboardScreen({super.key, required this.villageId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
final List<Patient> patients = [
  Patient(
    id: 1,
    villageId: 101,
    name: 'John Doe',
    age: 30,
    dateLastVisited: '2023-06-21',
    doctor: 'Dr. Smith',
    dentalNotes: 'No dental issues.',
    medicalNotes: 'Patient is recovering well.',
  ),
  Patient(
    id: 2,
    villageId: 102,
    name: 'Jane Doe',
    age: 25,
    dateLastVisited: '2023-06-20',
    doctor: 'Dr. Adams',
    dentalNotes: 'Requires a follow-up for dental cleaning.',
    medicalNotes: 'Patient shows significant improvement.',
  ),
  Patient(
    id: 3,
    villageId: 103,
    name: 'Robert Johnson',
    age: 40,
    dateLastVisited: '2023-06-19',
    doctor: 'Dr. Brown',
    dentalNotes: 'Cavity found in the upper left molar.',
    medicalNotes: 'Patient needs to follow up in two weeks.',
  ),
];

  @override
  void initState() {
    super.initState();
    // fetchPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Dashboard'),
      ),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          return PatientCard(patient: patients[index]);
        },
      ),
    );
  }
}

// class PatientCard extends StatelessWidget {
//   final Patient patient;

//   const PatientCard({super.key, required this.patient});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ExpansionTile(
//         title: Text(patient.name),
//         subtitle: Text('Age: ${patient.age}'),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PatientDetailScreen(patient: patient),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class PatientCard extends StatelessWidget {
  final Patient patient;

  const PatientCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(patient.name),
        subtitle: Text('Age: ${patient.age}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date Last Visited: ${patient.dateLastVisited}', style: TextStyle(fontSize: 16)),
                Text('Doctor: ${patient.doctor}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetailScreen(patient: patient),
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