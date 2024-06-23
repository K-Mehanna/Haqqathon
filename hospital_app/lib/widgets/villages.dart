import 'package:flutter/material.dart';
import 'package:hospital_app/patient_dashboard.dart';
import 'package:hospital_app/village_model.dart';

Widget buildVillageColumn(Future<List<Village>> _futureData) {
  return FutureBuilder<List<Village>>(
    future: _futureData,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return Card(
              color: Color(0xff5b98ba),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: Text(snapshot.data![index].name,
                      style: TextStyle(
                        fontSize: 20.0,
                      )),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(
                        villageName: snapshot.data![index].name,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}
