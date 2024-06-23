// lib/patient_model.dart

class Patient {
  final int id;
  final int villageId;
  final String name;
  final int age;
  final String dateLastVisited;
  final String doctor;
  final String dentalNotes;
  final String medicalNotes;

  Patient({
    required this.id,
    required this.villageId,
    required this.name,
    required this.age,
    required this.dateLastVisited,
    required this.doctor,
    required this.dentalNotes,
    required this.medicalNotes,
  });
}
