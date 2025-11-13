// lib/src/features/habits/presentation/add_habit_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/main.dart';
import 'package:habitflow/src/features/auth/data/auth_repository.dart';
import 'package:habitflow/src/features/habits/data/habit_repository.dart';
import 'package:habitflow/src/features/habits/domain/habit_model.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class AddHabitScreen extends ConsumerStatefulWidget {
  final Habit? habitToEdit;
  const AddHabitScreen({super.key, this.habitToEdit});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String? _description;
  String _category = "General";
  final List<int> _selectedDays = [1, 2, 3, 4, 5, 6, 7];

  // Default icon setup
  // We use 'IconPack.material' as a safe default.
  IconPickerIcon _selectedIcon = const IconPickerIcon(
    name: 'star',
    data: Icons.star,
    pack: IconPack.material,
  );

  Color _selectedColor = HabitFlowTheme.primaryColor;

  bool get _isEditing => widget.habitToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final habit = widget.habitToEdit!;
      _title = habit.title;
      _description = habit.description;
      _category = habit.category;
      _selectedDays.clear();
      _selectedDays.addAll(habit.weekdays);
      _selectedColor = Color(habit.color);

      // Handle Icon Deserialization
      final Map<String, dynamic> iconMap = {
        'pack': habit.iconFamily,
        'key': habit.iconFamily,
        'data': habit.iconCode,
      };

      final deserialized = deserializeIcon(iconMap);
      if (deserialized != null) {
        _selectedIcon = deserialized;
      }
    }
  }

  Future<void> _pickIcon() async {
    IconPickerIcon? icon = await showIconPicker(
      context,
      // Using minimal arguments for maximum compatibility with version 3.6.6
    );

    if (icon != null && mounted) {
      setState(() {
        _selectedIcon = icon;
      });
    }
  }

  Future<void> _submit() async {
    debugPrint("--- 1. Submit Started ---");

    if (!_formKey.currentState!.validate()) {
      debugPrint("--- Validation Failed ---");
      return;
    }
    _formKey.currentState!.save();
    debugPrint("--- 2. Form Saved ---");

    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) {
      debugPrint("--- ERROR: User ID is NULL ---");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Could not identify user (Not logged in?)')),
        );
      }
      return;
    }
    debugPrint("--- 3. User ID Found: $userId ---");

    // Attempt Icon Serialization
    final iconMap = serializeIcon(_selectedIcon);
    debugPrint("--- 4. Icon Serialization Result: $iconMap ---");
    
    if (iconMap == null) {
      debugPrint("--- ERROR: Icon Serialization returned NULL ---");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Could not save icon.')),
        );
      }
      return;
    }

    try {
      final habit = Habit(
        id: _isEditing ? widget.habitToEdit!.id : uuid.v4(),
        title: _title,
        description: _description,
        category: _category,
        startDate: _isEditing ? widget.habitToEdit!.startDate : DateTime.now(),
        weekdays: List.from(_selectedDays),
        userId: userId,
        createdAt: _isEditing ? widget.habitToEdit!.createdAt : DateTime.now(),
        updatedAt: _isEditing ? DateTime.now() : null,
        color: _selectedColor.toARGB32(),
        // FIX: Changed ?. to . because codePoint is non-nullable in this version
        iconCode: (iconMap['data'] as int?) ?? _selectedIcon.data.codePoint,
        iconFamily: iconMap['pack'] ?? 'material',
      );

      debugPrint("--- 5. Habit Object Created. Title: ${habit.title} ---");
      debugPrint("--- 6. Calling Repository... ---");

      if (_isEditing) {
        await ref.read(habitRepositoryProvider).updateHabit(habit);
      } else {
        await ref.read(habitRepositoryProvider).addHabit(habit);
      }

      debugPrint("--- 7. Repository Success! ---");

      ref.invalidate(allHabitsProvider);
      ref.invalidate(habitsForDayProvider);
      ref.invalidate(habitStreakProvider);
      ref.invalidate(habitLogsMapProvider);

      if (mounted) {
        debugPrint("--- 8. Closing Screen ---");
        Navigator.of(context).pop();
      }
    } catch (e, stackTrace) {
      debugPrint("!!! CRITICAL ERROR !!!");
      debugPrint("Error: $e");
      debugPrint("Stack Trace: $stackTrace");
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving habit: $e')),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Habit' : 'Add New Habit')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Center(
              child: InkWell(
                onTap: _pickIcon,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: _selectedColor.withAlpha(51),
                  // Use .data to get the IconData
                  child: Icon(_selectedIcon.data,
                      color: _selectedColor, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: _pickIcon,
                child: const Text("Change Icon"),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: _isEditing ? _title : null,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Habit Name', icon: Icon(Icons.label)),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onSaved: (value) => _title = value!,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: _isEditing ? _description : null,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  icon: Icon(Icons.description)),
              onSaved: (value) => _description = value,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: _isEditing ? _category : "General",
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Category', icon: Icon(Icons.category)),
              onSaved: (value) => _category = value ?? 'General',
            ),
            const SizedBox(height: 30),
            const Text("Repeat on:",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 10),
            _buildWeekDaySelector(),
            const SizedBox(height: 30),
            const Text("Color:",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 10),
            _buildColorSelector(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text(_isEditing ? 'Save Changes' : 'Create Habit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekDaySelector() {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final dayIndex = index + 1;
        final isSelected = _selectedDays.contains(dayIndex);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                if (_selectedDays.length > 1) {
                  _selectedDays.remove(dayIndex);
                }
              } else {
                _selectedDays.add(dayIndex);
              }
            });
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor:
                isSelected ? _selectedColor : HabitFlowTheme.darkSurface,
            child: Text(
              days[index],
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildColorSelector() {
    final colors = [
      HabitFlowTheme.primaryColor,
      Colors.pink,
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.teal
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: colors.map((color) {
        final isSelected = _selectedColor.toARGB32() == color.toARGB32();
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = color),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child:
                isSelected ? const Icon(Icons.check, color: Colors.white) : null,
          ),
        );
      }).toList(),
    );
  }
}