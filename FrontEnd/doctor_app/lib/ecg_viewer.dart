import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class EcgData {
  final double voltage;
  final double timestamp;

  EcgData(this.voltage, this.timestamp);
}

class EcgViewer extends StatefulWidget {
  const EcgViewer({super.key, required this.channel});

  final WebSocketChannel channel;

  @override
  State<EcgViewer> createState() => _EcgViewerState();
}

class _EcgViewerState extends State<EcgViewer> {
  double counter = 0.0;
  double offset = 0.0;
  bool isScrolling = false;
  double scrollSnapshot = 0.0;
  late int startTime;
  bool firstTime = true;
  double xWindow = 5.0;

  @override
  void initState() {
    super.initState();

    // 1 second is 5 (large) squares
    widget.channel.stream.listen((message) {
      print("We are getting message: $message");
      final rawData = jsonDecode(message);
      final relevantData = rawData['ecgdata'] as Map<String, dynamic>;
      print("Relevant data is ${relevantData['time']}");
      // final voltages = relevantData['data'] as List<double>;

      final voltages =
          relevantData['data'].map((element) => element.toDouble()).toList();
      final timestamps = relevantData['time']
          .map((element) => int.parse(element.toString()))
          .toList();

      if (firstTime) {
        startTime = timestamps[0];
        firstTime = false;
      }

      int minLength = voltages.length < timestamps.length
          ? voltages.length
          : timestamps.length;

      List<EcgData> ecgData = [
        for (int i = 0; i < minLength; i++)
          EcgData(voltages[i] / 1024.0 + 1.0,
              (timestamps[i] - startTime).toDouble() / 1000000.0)
      ];

      for (int i = 0; i < minLength; i++) {
        print(
            "Voltage: ${ecgData[i].voltage}, Timestamp: ${ecgData[i].timestamp}");
      }

      counter = ecgData.last.timestamp;

      setState(() {
        data.addAll(ecgData);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<EcgData> data = [];

  List<FlSpot> _getSpots(List<EcgData> data) {
    return data.map((e) => FlSpot(e.timestamp, e.voltage)).toList();
  }

  @override
  Widget build(BuildContext context) {
    print("ECG Viewer Data size: ${data.length}");
    return Container(
      width: double.infinity,
      height: 300,
      padding: EdgeInsets.only(left: 40.0, top: 20.0, bottom: 20.0),
      child: GestureDetector(
        onHorizontalDragUpdate: (dragUpdDet) {
          setState(() {
            double primDelta = dragUpdDet.primaryDelta ?? 0.0;
            if (primDelta != 0) {
              if (primDelta.isNegative) {
                offset -= 0.1;
                if (!isScrolling) {
                  scrollSnapshot = counter.toDouble();
                }
                isScrolling = true;
              } else {
                offset += 0.1;
                if (!isScrolling) {
                  scrollSnapshot = counter.toDouble();
                }
                isScrolling = true;
              }
              if (offset < 0) {
                offset = 0;
                isScrolling = false;
              }

              if (offset > counter - 20.0) {
                offset = counter - 20.0;
              }
            }
          });
        },
        child: LineChart(LineChartData(
            clipData: FlClipData.all(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            minY: 1.0,
            maxY: 5.0,
            maxX: isScrolling ? scrollSnapshot - offset : counter.toDouble(),
            minX: isScrolling
                ? scrollSnapshot - offset - xWindow
                : counter.toDouble() - xWindow,
            lineBarsData: [
              LineChartBarData(
                spots: _getSpots(data),
                //isCurved: true,
                color: Colors.red,
                //curveSmoothness: 0.8,
                dotData: const FlDotData(
                  show: false,
                ),
                //barWidth: 2.0,
                //isStrokeCapRound: true,
              ),
            ],
            lineTouchData: LineTouchData(enabled: false))),
      ),
    );
  }
}
