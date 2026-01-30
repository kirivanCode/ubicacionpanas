import 'package:flutter/material.dart';
import '../services/group_service.dart';

class GroupCreateScreen extends StatelessWidget {
  final _service = GroupService();

  GroupCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear grupo')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Crear grupo'),
          onPressed: () async {
            final code = await _service.createGroup();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Código del grupo: $code')),
            );
          },
        ),
      ),
    );
  }
}
