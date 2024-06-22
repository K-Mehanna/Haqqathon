import 'package:doctor_app/widgets/my_textfield.dart';
import 'package:flutter/material.dart';

class DentalNotesPage extends StatefulWidget {
  const DentalNotesPage({super.key});

  @override
  State<DentalNotesPage> createState() => _DentalNotesPageState();
}

class _DentalNotesPageState extends State<DentalNotesPage> {
  final TextEditingController _controller = TextEditingController();

  final List<List<TextEditingController>> _controllers = List.generate(
    4,
    (index) => List.generate(8, (index) => TextEditingController()),
  );

  List<List<String>> toothNotes = List.generate(
    4,
    (index) => List.generate(8, (index) => ""),
  );

  //List<List<String>> toothNotes = [[]];

  void _submitText(BuildContext context) {
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 8; j++) {
        setState(() {
          toothNotes[i][j] = _controllers[i][j].text == ""
              ? "No notes"
              : _controllers[i][j].text;
        });
      }
    }
    Map<String, dynamic> notes = {
      'generalNotes': _controller.text,
      'toothNotes': toothNotes,
    };
    // Navigator.pop(context, _controller.text);
    Navigator.pop(context, notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Dental Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Complaints',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter notes'),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Per-tooth notes',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => const AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text(
                            'Numbering Scheme',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Image(
                            image: AssetImage('lib/assets/iso_teeth.png'),
                            height: 400.0,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info))
              ],
            ),
            // const Text(
            //   'Per-tooth notes',
            //   style: TextStyle(
            //     fontSize: 24.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            Container(
              height: 475.0,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10.0),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4.0, top: 4.0),
                    child: MyTextField(
                      controller: _controllers[index ~/ 8][index % 8],
                      hintText: 'Tooth ${index ~/ 8 + 1}${index % 8 + 1} notes',
                    ),
                  );
                  // TextField(
                  //   controller: _controllers[index % 8][index ~/ 8],
                  //   decoration: InputDecoration(
                  //       labelText:
                  //           'Tooth ${index ~/ 8 + 1}${index % 8 + 1} notes'),
                  //   keyboardType: TextInputType.multiline,
                  //   maxLines: null,
                  // );
                },
                itemCount: 32,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 16.0,
                ),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 6.0,
              ),
              onPressed: () => _submitText(context),
              child: const Text('Add notes'),
            ),
          ],
        ),
      ),
    );
  }
}
