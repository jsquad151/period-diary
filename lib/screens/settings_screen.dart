import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            key: const Key('openContext'),
            leading: const Icon(Icons.medical_information_outlined),
            title: const Text('Health context'),
            subtitle: const Text('Contraception, medication, illness and other events'),
            onTap: () => context.push('/context'),
          ),
        ],
      ),
    );
  }
}
