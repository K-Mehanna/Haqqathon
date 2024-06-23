import 'package:doctor_app/dental_notes_page.dart';
import 'package:doctor_app/ecg_viewer.dart';
import 'package:doctor_app/notes_page.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _dentalNotes;
  Map<String, dynamic>? _medicalNotes;

  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.4.1:8080/ws'),
  );

  void _navigateToSubmitPage(BuildContext context, bool isDental) async {
    print('Dental notes: $_dentalNotes');
    print('------------------------');
    print('Medical notes: $_medicalNotes');
    Map<String, dynamic>? result;

    if (isDental) {
      result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DentalNotesPage()),
      );
    } else {
      result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotesPage()),
      );
    }

    if (result != null) {
      setState(() {
        if (isDental) {
          _dentalNotes = result;
        } else {
          _medicalNotes = result;
        }
      });
    }

    print('Dental notes: $_dentalNotes');
    print('------------------------');
    print('Medical notes: $_medicalNotes');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haqqathon demo'),
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onPressed: null,
          icon: Icon(Icons.send),
          label: Text('Send data to the hospital'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          // const Placeholder(),
          // SizedBox(
          //   height: 200,
          //   width: double.infinity,
          //   child: StreamBuilder(
          //     stream: _channel.stream,
          //     builder: (context, snapshot) {
          //       return Text(snapshot.hasData ? '${snapshot.data}' : 'No data yet');
          //     },
          //   ),
          // ),
          EcgViewer(channel: _channel),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            'Oxygen level: 98%',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Heart rate: 80 bpm',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.amber.shade500),
              maximumSize: WidgetStateProperty.all(const Size(150, 50)),
              foregroundColor: WidgetStateProperty.all(Colors.black),
            ),
            onPressed: () => _navigateToSubmitPage(context, true),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add dental notes'),
              ],
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all(Colors.indigoAccent.shade400),
              maximumSize: WidgetStateProperty.all(const Size(150, 50)),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            onPressed: () => _navigateToSubmitPage(context, false),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add medical notes'),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
