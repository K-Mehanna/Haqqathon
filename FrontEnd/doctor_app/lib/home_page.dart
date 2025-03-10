import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_app/database_helper.dart';
import 'package:doctor_app/dental_notes_page.dart';
import 'package:doctor_app/ecg_viewer.dart';
import 'package:doctor_app/notes_page.dart';
import 'package:doctor_app/patient_data.dart';
import 'package:doctor_app/patient_info_page.dart';
import 'package:doctor_app/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PatientData _patientData = PatientData();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  final _random = Random();
  double next(double min, double max) =>
      min + _random.nextDouble() * (max - min);
  Timer? _timer;

  double oxygenLevel = 98.7;
  int heartRate = 70;

  @override
  void initState() {
    super.initState();
    fakeData();
  }

  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.4.1:8090/ws'),
  );

  void fakeData() {
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      setState(() {
        oxygenLevel += next(-1, 1);
        if (oxygenLevel > 100) oxygenLevel = 100.0;
        heartRate += _random.nextInt(5) - 2;
      });
    });
  }

  Patient createPatient(Map<String, dynamic> data) {
    print('fdsdafdas: ${data.toString()}');
    return Patient(
      age: data['age'],
      dentalNotes: data['dentalData'] as Map<String, dynamic>,
      doctor: data['doctorName'],
      gender: data['gender'],
      lastVisit: (data['timestamp'] as Timestamp).toDate(),
      medicalNotes: data['medicalData'],
      name: data['name'],
      priority: data['priority'],
    );
  }

  Patient createPatient1(PatientData data) {
    print('fdsdafdas: ${data.toString()}');
    return Patient(
      age: data.age!,
      dentalNotes: data.dental!,
      doctor: data.doctor!,
      gender: data.gender.toString().split('.').last,
      lastVisit: data.last_checked!,
      medicalNotes: data.medical!,
      name: data.name!,
      priority: data.priority.toString().split('.').last,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haqqathon demo'),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onPressed: () {
            Map<String, dynamic> data = _patientData.toJson();
            // uncomment out the following line to send the data to the server
            _channel.sink.add(jsonEncode(_patientData.toJson()));
            print('data: ${data.toString()}');
            //print(createPatient(data));
            // print('fdsafad: ${createPatient1(_patientData)}');

            // _databaseHelper.addResidentToVillageByName(
            //     createPatient1(_patientData), _patientData.villageName!);
          },
          icon: Icon(Icons.send),
          label: Text('Send data to the hospital'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          // const Placeholder(
          //   fallbackHeight: 300,
          // ),
          EcgViewer(channel: _channel),
          //EcgViewer(),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            'Oxygen level: ${oxygenLevel.toStringAsFixed(1)} %',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Heart rate: $heartRate bpm',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.amber.shade500,
                maximumSize: Size(150, 50),
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                var table = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DentalNotesPage()),
                );
                print('table: $table');
                _patientData.dental = table;
              },
              child: Text('Add dental notes')),

          TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.indigoAccent.shade400,
                maximumSize: const Size(150, 50),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                _patientData.medical = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotesPage()),
                );
              },
              child: Text('Add medical notes')),

          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 172, 80, 14),
              maximumSize: const Size(150, 50),
              foregroundColor: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () async {
              PatientInfo? info = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientInfoPage()),
              );
              if (info != null) _patientData.addInfo(info);
            },
            child: Text('Enter patient info'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _channel.sink.close();
    super.dispose();
  }
}
