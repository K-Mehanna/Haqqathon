import 'package:doctor_app/widgets/my_textfield.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatelessWidget {
  NotesPage({super.key});

  final TextEditingController _controller = TextEditingController();

  void _submitText(BuildContext context) {
    Navigator.pop(context, _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Medical notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MyTextField(controller: _controller, hintText: 'Enter notes'),
            //const SizedBox(height: 20),
            const Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                )),
                backgroundColor: WidgetStateProperty.all(Colors.green),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              onPressed: () => _submitText(context),
              child: const Text(
                'Add notes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
