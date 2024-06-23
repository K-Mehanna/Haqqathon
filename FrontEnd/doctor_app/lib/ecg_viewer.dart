// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:web_socket_channel/web_socket_channel.dart';
// // import 'package:charts_flutter/flutter.dart' as charts;

// // class EcgViewer extends StatefulWidget {
// //   final WebSocketChannel channel;

// //   const EcgViewer({super.key, required this.channel});

// //   @override
// //   State<EcgViewer> createState() => _EcgViewerState();
// // }

// // class _EcgViewerState extends State<EcgViewer> {
// //   List<charts.Series<ECGData, int>> _seriesData = [];
// //   List<ECGData> ecgData = [];
// //   int xValue = 0;

// //   @override
// //   void initState() {
// //     super.initState();

// //     widget.channel.stream.listen((message) {
// //       final data = jsonDecode(message);
// //       List<double> newData = List<double>.from(data['data']);
// //       setState(() {
// //         for (var value in newData) {
// //           ecgData.add(ECGData(xValue++, value));
// //           if (ecgData.length > 1000) {
// //             ecgData.removeAt(0); // Keep the last 1000 data points
// //           }
// //         }
// //         _updateSeries();
// //       });
// //     });
// //   }

// //   void _updateSeries() {
// //     _seriesData = [
// //       charts.Series<ECGData, int>(
// //         id: 'ECG',
// //         colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
// //         domainFn: (ECGData data, _) => data.time,
// //         measureFn: (ECGData data, _) => data.value,
// //         data: ecgData,
// //       )
// //     ];
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('ECG Viewer'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: charts.LineChart(
// //           _seriesData,
// //           animate: false,
// //           primaryMeasureAxis: const charts.NumericAxisSpec(
// //             viewport: charts.NumericExtents(-1, 1), // Adjust based on your ECG data range
// //           ),
// //           domainAxis: const charts.NumericAxisSpec(
// //             viewport: charts.NumericExtents(0, 1000),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class ECGData {
// //   final int time;
// //   final double value;

// //   ECGData(this.time, this.value);
// // }

// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class EcgViewer extends StatefulWidget {
//   final WebSocketChannel channel;

//   const EcgViewer({super.key, required this.channel});

//   @override
//   State<EcgViewer> createState() => _EcgViewerState();
// }

// class _EcgViewerState extends State<EcgViewer> {
//   List<double> ecgData = [];
//   int xValue = 0;

//   late Timer _timer;

//   void _startGeneratingRandomDoubles() {
//     const duration = Duration(seconds: 1); // Update every second
//     _timer = Timer.periodic(duration, (Timer timer) {
//       setState(() {
//         ecgData.addAll(_generateRandomDoubles(10, 5.0, 10.0));
//         if (ecgData.length > 1000) {
//           ecgData = ecgData
//               .sublist(ecgData.length - 1000); // Keep the last 1000 data points
//         }
//       });
//     });
//   }

//   List<double> _generateRandomDoubles(int count, double min, double max) {
//     final random = Random();
//     return List<double>.generate(
//         count, (_) => min + (random.nextDouble() * (max - min)));
//   }

//   @override
//   void initState() {
//     super.initState();
//     //_startGeneratingRandomDoubles();

//     widget.channel.stream.listen((message) {
//       print("JSON Data is $message");
//       final data = jsonDecode(message);
//       List<double> newData = List<double>.from(data['ecgdata']['ecgdata']);
//       print(newData);
//       setState(() {
//         ecgData.addAll(newData);
//         if (ecgData.length > 1000) {
//           ecgData = ecgData
//               .sublist(ecgData.length - 1000); // Keep the last 1000 data points
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 400,
//       //color: Colors.red,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: CustomPaint(
//           size: Size(ecgData.length.toDouble(), 200),
//           painter: EcgPainter(ecgData),
//         ),
//       ),
//     );
//   }
// }

// class EcgPainter extends CustomPainter {
//   final List<double> ecgData;

//   EcgPainter(this.ecgData);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.blue
//       ..strokeWidth = 2.0
//       ..style = PaintingStyle.stroke;

//     final path = Path();
//     if (ecgData.isNotEmpty) {
//       path.moveTo(0, size.height / 2 - ecgData[0] * 100); // Initial point
//       for (int i = 1; i < ecgData.length; i++) {
//         path.lineTo(i.toDouble(), size.height / 2 - ecgData[i] * 100);
//       }
//     }
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  late int epochTime;// = DateTime.now().microsecondsSinceEpoch;

  @override
  void initState() {
    super.initState();

    // 1 second is 5 (large) squares
    widget.channel.stream.listen((message) {
      print("We are getting message: $message");
      final rawData = jsonDecode(message);
      final relevantData = rawData['ecgdata'] as Map<String, dynamic>;
      print("Relevant data is ${relevantData['data']}");
      // final voltages = relevantData['data'] as List<double>;
      final voltages =
          relevantData['data'].map((element) => element.toDouble()).toList();
      final timestamps =
          relevantData['time'].map((element) => element.toString()).toList();

      int minLength = voltages.length < timestamps.length
          ? voltages.length
          : timestamps.length;

      epochTime = timestamps[0];

      List<EcgData> ecgData = [
        for (int i = 0; i < minLength; i++)
          EcgData(voltages[i] * 4.0 + 1.0, (int.parse(timestamps[i]) - epochTime).toDouble() / 1000.0)
      ];

      
      for (int i = 0; i < minLength; i++) {
        print("Voltage: ${ecgData[i].voltage}, Timestamp: ${ecgData[i].timestamp}");
      }


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
      padding: EdgeInsets.only(left: 40.0),
      child: GestureDetector(
        onHorizontalDragUpdate: (dragUpdDet) {
          setState(() {
            double primDelta = dragUpdDet.primaryDelta ?? 0.0;
            if (primDelta != 0) {
              if (primDelta.isNegative) {
                offset -= 0.5;
                if (!isScrolling) {
                  scrollSnapshot = counter.toDouble();
                }
                isScrolling = true;
              } else {
                offset += 0.5;
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
            minY: 0.0,
            maxY: 6.0,
            // maxX: isScrolling ? scrollSnapshot - offset : counter.toDouble(),
            // minX: isScrolling
            //     ? scrollSnapshot - offset - 20.0
            //     : counter.toDouble() - 20.0,
            lineBarsData: [
              LineChartBarData(
                spots: _getSpots(data),
                isCurved: true,
              ),
            ],
            lineTouchData: LineTouchData(enabled: false))),
      ),
    );
  }
}
