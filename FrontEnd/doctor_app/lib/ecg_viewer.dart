import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class EcgData {
  final double voltage;
  final double timestamp;

  EcgData(this.voltage, this.timestamp);
}

class EcgViewer extends StatefulWidget {
  const EcgViewer({super.key, this.channel});

  final WebSocketChannel? channel;

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
  Timer? _timer;

  bool fakeData = false;

  @override
  void initState() {
    super.initState();

    // 1 second is 5 (large) squares
    if (!fakeData) {
      widget.channel!.stream.listen((message) {
        final rawData = jsonDecode(message);
        final relevantData = rawData['ecgdata'] as Map<String, dynamic>;
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

        counter = ecgData.last.timestamp;

        setState(() {
          data.addAll(ecgData);
        });
      });
    } else {
      _startFakingData();
    }
  }

  void _startFakingData() {
    const duration = Duration(milliseconds: 100); // Update every second
    _timer = Timer.periodic(duration, (Timer timer) {
      int step = 1;
      setState(() {
        data.addAll(_generateFakeData(step, 1.0, 5.0)); // Generate 10 random double values between 0.0 and 100.0
      });
    });
  }

  List<EcgData> _generateFakeData(int count, double min, double max) {
    return List.generate(count, (_) {
      counter += 0.2;
      return EcgData(3.0 + 1.7 * sin(7 * counter) * sin(0.5 * counter) * cos(3.25 * counter), counter);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<EcgData> data = [];

  List<FlSpot> _getSpots(List<EcgData> data) {
    return data.map((e) => FlSpot(e.timestamp, e.voltage)).toList();
  }

  @override
  Widget build(BuildContext context) {
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
