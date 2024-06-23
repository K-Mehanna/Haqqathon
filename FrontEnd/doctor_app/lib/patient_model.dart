import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final int age;
  final Map<String, dynamic> dentalNotes;
  final String doctor;
  final String gender;
  final DateTime lastVisit;
  final String medicalNotes;
  final String name;
  final String priority;

  Patient({
    required this.age,
    required this.dentalNotes,
    required this.doctor,
    required this.gender,
    required this.lastVisit,
    required this.medicalNotes,
    required this.name,
    required this.priority,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      name: json['patientName'],
      age: json['age'],
      dentalNotes: json['dentalData'],
      doctor: json['doctorName'],
      lastVisit: json['timestamp'],
      medicalNotes: json['medicalData'],
      gender: json['gender'],
      priority: json['priority'],
    );
  }

  factory Patient.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Patient(
      age: data['age'],
      dentalNotes: {
        'complaints': data['dental']['complaints'],
        'generalNotes': data['dental']['generalNotes'],
        // 'toothNotes': [
        //   data['dental']['toothNotes1'],
        //   data['dental']['toothNotes2'],
        //   data['dental']['toothNotes3'],
        //   data['dental']['toothNotes4']
        // ]
      },
      doctor: data['doctor'],
      gender: data['gender'],
      lastVisit: (data['last_checked'] as Timestamp).toDate(),
      medicalNotes: data['medical'],
      name: data['name'],
      priority: data['priority'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "age": age,
      "dental": {
        "complaints": dentalNotes['complaints'],
        "generalNotes": dentalNotes['generalNotes'],
        // "toothNotes1": dentalNotes['toothNotes1'],
        // "toothNotes2": dentalNotes['toothNotes2'],
        // "toothNotes3": dentalNotes['toothNotes3'],
        // "toothNotes4": dentalNotes['toothNotes4'],
      },
      "doctor": doctor,
      "gender": gender,
      "last_checked": Timestamp.fromDate(lastVisit),
      "medical": medicalNotes,
      "name": name,
      "priority": priority,
    };
  }
}
