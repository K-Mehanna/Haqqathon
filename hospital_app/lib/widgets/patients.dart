import 'package:flutter/material.dart';
import 'package:hospital_app/patient_model.dart';
import 'package:hospital_app/widgets/patient_card.dart';


Widget buildPatientColumn(Future<List<Patient>> _futureData) {
  return FutureBuilder<List<Patient>>(
    future: _futureData,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data!.length, //patients.length,
          itemBuilder: (context, index) {
            return PatientCard(patient: snapshot.data![index]);
          },
        );
      }
      return CircularProgressIndicator();
    },
  );
}
