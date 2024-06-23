import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final int age;
  final String dentalNotes;
  final String doctor;
  final String gender;
  final DateTime lastVisit;
  final String medicalNotes;
  final String name;

  Patient({
    required this.age,
    required this.dentalNotes,
    required this.doctor,
    required this.gender,
    required this.lastVisit,
    required this.medicalNotes,
    required this.name,
  });

  factory Patient.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Patient(
      age: data['age'],
      dentalNotes: data['dental'],
      doctor: data['doctor'],
      gender: data['gender'],
      lastVisit: (data['last_checked'] as Timestamp).toDate(),
      medicalNotes: data['medical'],
      name: data['name'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "age": age,
      "dental": dentalNotes,
      "doctor": doctor,
      "gender": gender,
      "last_checked": Timestamp.fromDate(lastVisit),
      "medical": medicalNotes,
      "name": name,
    };
  }
}
