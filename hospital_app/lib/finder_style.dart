import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital_app/database_helper.dart';
import 'package:hospital_app/patient_dashboard.dart';
import 'package:hospital_app/patient_info.dart';
import 'package:hospital_app/patient_model.dart';
import 'package:hospital_app/village_model.dart';
import 'package:hospital_app/widgets/patients.dart';
import 'package:hospital_app/widgets/villages.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FinderHomePage extends StatefulWidget {
  const FinderHomePage({super.key});

  @override
  State<FinderHomePage> createState() => _FinderHomePageState();
}

class _FinderHomePageState extends State<FinderHomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late Future<List<Village>> _futureData;
  late Future<List<Patient>> _futureData2;
  late Patient _selectedPatient;
  bool doneFirstCol = false;
  bool doneSecondCol = false;
  final _channel = WebSocketChannel.connect(
    //Uri.parse('ws://192.168.4.1:80/ws'),
    Uri.parse('ws://172.20.10.2:80/ws'),
  );

  late final Village village;
  late final Patient patient;

  @override
  void initState() {
    super.initState();
    _futureData = _databaseHelper.getVillages();

    _channel.stream.listen((message) {
      if (message != "null") {
        print("We are getting message: $message");
        final rawData = jsonDecode(message) as Map<String, dynamic>;
        village = Village.fromJson(rawData);
        patient = Patient.fromJson(rawData);
        // _databaseHelper.addResidentToVillageByName(patient, village.name);
        print('Here');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient Records',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.grey.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Villages',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder<List<Village>>(
                    future: _futureData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Color(0xff5b98ba),
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 16.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data![index].name,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if (doneSecondCol) {
                                        doneSecondCol = false;
                                      }
                                      doneFirstCol = true;
                                      _futureData2 =
                                          _databaseHelper.getPatients(
                                              snapshot.data![index].name);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
            ),
            VerticalDivider(),
            Expanded(
              child: doneFirstCol
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Patients',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FutureBuilder<List<Patient>>(
                          future: _futureData2,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: Color.fromARGB(255, 160, 206, 230),
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                            vertical: 16.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data![index].name,
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 18.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            doneSecondCol = true;
                                            _selectedPatient =
                                                snapshot.data![index];
                                          });
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => PatientScreen(
                                          //       patient: snapshot.data![index],
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ],
                    )
                  : Card(
                      child: Center(
                        child: Text('Select a village to view patients'),
                      ),
                    ),
            ),
            VerticalDivider(),
            Expanded(
                child: doneSecondCol
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Patient Details',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 5.0,
                            color: Color.fromARGB(255, 231, 239, 244),
                            child: Container(
                              height: 500.0,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Name: ${_selectedPatient.name}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        'Age: ${_selectedPatient.age}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        'Date Last Visited: ${DateFormat.yMd().add_jm().format(_selectedPatient.lastVisit)}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        'Doctor: ${_selectedPatient.doctor}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Priority: ${_selectedPatient.priority}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Dental Notes',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Complaints',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        _selectedPatient
                                            .dentalNotes['complaints'],
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        'General Notes',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        _selectedPatient
                                            .dentalNotes['generalNotes'],
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text('Medical Notes',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        _selectedPatient.medicalNotes,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Card(
                        child: Center(
                          child: Text('Select a patient to view details'),
                        ),
                      )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
