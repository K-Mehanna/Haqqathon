import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital_app/patient_model.dart';
import 'package:hospital_app/village_model.dart';

class DatabaseHelper {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Patient>> getPatients(String villageName) async {
    List<Patient> patients = [];
    QuerySnapshot villagesSnapshot = await _db
        .collection("villages")
        .where("name", isEqualTo: villageName)
        .get();
    for (QueryDocumentSnapshot villageDoc in villagesSnapshot.docs) {
      CollectionReference<Map<String, dynamic>> residentsCollection =
          villageDoc.reference.collection("residents");
      QuerySnapshot<Map<String, dynamic>> patientDocs =
          await residentsCollection.get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> patientDoc
          in patientDocs.docs) {
        Patient patient = Patient.fromFirestore(patientDoc, null);
        patients.add(patient);
      }
    }
    print('patient: $patients');
    return patients;
  }

  Future<List<Village>> getVillages() {
    final completer = Completer<List<Village>>();
    final patientsRef = _db.collection("villages");

    patientsRef.get().then(
      (querySnapshot) {
        print('villages querySnapshot: $querySnapshot');
        List<Village> villages = [];
        for (var docSnapshot in querySnapshot.docs) {
          Village village = Village.fromFirestore(docSnapshot, null);

          villages.add(village);
        }
        print('villages: $villages');
        completer.complete(villages);
      },
      onError: (e) => print("Error completing: $e"),
    );

    return completer.future;
  }

  Future<void> addResidentToVillageByName(
      Patient patient, String villageName) async {
    try {
      // Query the villages collection to find the village with the given name
      QuerySnapshot villageSnapshot = await _db
          .collection('villages')
          .where('name', isEqualTo: villageName)
          .get();

      if (villageSnapshot.docs.isEmpty) {
        print('No village found with the name: $villageName');
        return;
      }

      // Assuming village names are unique, take the first matching document
      DocumentSnapshot villageDoc = villageSnapshot.docs.first;
      String villageId = villageDoc.id;

      // Reference to the residents subcollection
      CollectionReference residentsRef =
          _db.collection('villages').doc(villageId).collection('residents');

      // Add a new resident document
      await residentsRef.add(patient.toFirestore());

      print('Resident added successfully');
    } catch (e) {
      print('Error adding resident: $e');
    }
  }
}
