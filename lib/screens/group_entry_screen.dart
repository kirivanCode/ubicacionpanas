import 'package:flutter/material.dart';
import '../services/group_service.dart';
import 'map_screen.dart';

class GroupEntryScreen extends StatelessWidget {
  final GroupService _groupService = GroupService();

  GroupEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compartir ubicación'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.group,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 30),

            // 🟢 CREAR GRUPO
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Crear grupo'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                final code = await _groupService.createGroup();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MapScreen(groupCode: code),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 🔵 UNIRSE A GRUPO
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Unirse a un grupo'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                _showJoinDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Unirse a grupo'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Código del grupo',
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Unirse'),
            onPressed: () async {
              final code = controller.text.trim().toUpperCase();

              await _groupService.joinGroup(code);

              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MapScreen(groupCode: code),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
