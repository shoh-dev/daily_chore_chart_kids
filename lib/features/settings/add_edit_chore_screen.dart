// lib/features/settings/add_edit_chore_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

import '../../core/models/chore.dart';
import '../../utils/hive_keys.dart';
import '../premium/premium_dialog.dart';
import 'settings_screen.dart'; // For settingsChoreListProvider
import '../home/home_screen.dart'; // For choreListProvider

class AddEditChoreScreen extends ConsumerStatefulWidget {
  final Chore? chore;
  const AddEditChoreScreen({super.key, this.chore});

  @override
  ConsumerState<AddEditChoreScreen> createState() => _AddEditChoreScreenState();
}

class _AddEditChoreScreenState extends ConsumerState<AddEditChoreScreen> {
  final _controller = TextEditingController();
  final _uuid = const Uuid();
  static const int freeChoreLimit = 3;

  @override
  void initState() {
    super.initState();
    if (widget.chore != null) {
      _controller.text = widget.chore!.title;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveChore() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    final choresBox = Hive.box<Chore>(HiveBoxKeys.chores);
    final isPremium =
        Hive.box(HiveBoxKeys.appState).get(HiveBoxKeys.hasPremium) == true;
    final currentCount = choresBox.values.length;

    // Enforce free limit
    if (!isPremium && widget.chore == null && currentCount >= freeChoreLimit) {
      showDialog(context: context, builder: (_) => const PremiumDialog());
      return;
    }

    final newChore = Chore(
      id: widget.chore?.id ?? _uuid.v4(),
      title: title,
      iconPath: widget.chore?.iconPath ?? 'default_icon',
    );

    await choresBox.put(newChore.id, newChore);

    // Update providers so screens reflect the change immediately
    final updatedList = choresBox.values.toList();
    ref.read(settingsChoreListProvider.notifier).state = updatedList;
    ref.read(choreListProvider.notifier).state = updatedList;

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.chore != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Chore' : 'Add Chore')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Chore Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveChore,
              icon: const Icon(Icons.save),
              label: const Text('Save Chore'),
            ),
          ],
        ),
      ),
    );
  }
}
