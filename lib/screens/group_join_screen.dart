import 'package:flutter/material.dart';
import '../services/group_service.dart';

class GroupJoinScreen extends StatelessWidget {
  final _controller = TextEditingController();
  final _service = GroupService();

  GroupJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unirse a grupo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Código del grupo',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Unirse'),
              onPressed: () async {
                await _service.joinGroup(_controller.text.trim());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
