// lib/src/features/habits/presentation/add_habit_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/src/features/habits/data/habit_repository.dart';
import 'package:habitflow/src/features/habits/domain/habit_model.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class AddHabitScreen extends ConsumerStatefulWidget {
  const AddHabitScreen({super.key});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _category = 'Health'; // Default category

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final newHabit = Habit(
        id: uuid.v4(),
        title: _title,
        category: _category,
        startDate: DateTime.now(),
        weekdays: [1,2,3,4,5,6,7], // Every day for now
        createdAt: DateTime.now(),
      );

      await ref.read(habitRepositoryProvider).addHabit(newHabit);

      // Invalidate the provider to force a refresh on the home screen
      ref.invalidate(allHabitsProvider);
      
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a New Habit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              // TODO: Add more fields for description, category, schedule etc.
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Save Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}