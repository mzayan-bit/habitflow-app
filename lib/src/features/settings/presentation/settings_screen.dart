// lib/src/features/settings/presentation/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/main.dart';
import 'package:habitflow/src/features/auth/data/auth_repository.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLinking = false;

  Future<void> _linkAccount() async {
    setState(() => _isLinking = true);
    try {
      await ref.read(authRepositoryProvider).linkWithGoogle();
      // FIX: Check for mounted context before using ScaffoldMessenger
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Account linked successfully!"),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Failed to link account: ${e.toString()}"),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLinking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateChangesProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile & Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: HabitFlowTheme.primaryColor,
            child: Text(
              user?.email?[0].toUpperCase() ??
                  (user?.isAnonymous ?? false ? "G" : "?"),
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              user?.email ?? "Guest User",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          if (user?.isAnonymous ?? false)
            Center(
              child: _isLinking
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    )
                  : TextButton(
                      onPressed: _linkAccount,
                      child: const Text("Link with Google to save progress!"),
                    ),
            ),
          const Divider(
              color: Colors.white24, height: 40, indent: 20, endIndent: 20),

          // --- App Settings ---
          const Text("Settings",
              style:
                  TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            color: HabitFlowTheme.darkSurface,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Enable Notifications",
                      style: TextStyle(color: Colors.white)),
                  value: true, // Placeholder
                  onChanged: (val) {
                    // FIX: Replaced TODO
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Notification settings coming soon!")));
                  },
                  activeColor: HabitFlowTheme.primaryColor,
                ),
                ListTile(
                  title: const Text("Theme",
                      style: TextStyle(color: Colors.white)),
                  trailing: const Text("Dark Mode",
                      style: TextStyle(color: HabitFlowTheme.kWhite70)),
                  leading: const Icon(Icons.dark_mode,
                      color: HabitFlowTheme.kWhite70),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Theme switching coming soon!")));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // --- Account ---
          const Text("Account",
              style:
                  TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            color: HabitFlowTheme.darkSurface,
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("Logout",
                  style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                ref.read(authRepositoryProvider).signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}