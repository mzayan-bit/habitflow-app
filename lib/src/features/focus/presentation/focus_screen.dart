// lib/src/features/focus/presentation/focus_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:habitflow/main.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  static const int _focusDuration = 25 * 60; // 25 minutes
  static const int _breakDuration = 5 * 60; // 5 minutes

  Timer? _timer;
  int _currentSeconds = _focusDuration;
  bool _isTimerRunning = false;
  bool _isFocusMode = true;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        setState(() {
          _currentSeconds--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isTimerRunning = false;
          _isFocusMode = !_isFocusMode;
          _currentSeconds =
              _isFocusMode ? _focusDuration : _breakDuration;
        });
        // FIX: Replaced TODO with a Snackback
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: HabitFlowTheme.darkSurface,
              content: Text(
                _isFocusMode ? "Time for a break!" : "Time to focus!",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _isFocusMode = true;
      _currentSeconds = _focusDuration;
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor().toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final int totalDuration = _isFocusMode ? _focusDuration : _breakDuration;
    final double percent = _currentSeconds / totalDuration;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Focus Timer"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isFocusMode ? "Focus" : "Break",
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 40),
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 15.0,
              percent: percent,
              center: Text(
                _formatTime(_currentSeconds),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 48.0,
                    color: Colors.white),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: HabitFlowTheme.darkSurface,
              progressColor: HabitFlowTheme.primaryColor,
              reverse: true,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- Start/Pause Button ---
                ElevatedButton(
                  onPressed: _isTimerRunning ? _pauseTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24),
                  ),
                  child: Icon(_isTimerRunning ? Icons.pause : Icons.play_arrow),
                ),
                const SizedBox(width: 20),
                // --- Reset Button ---
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  iconSize: 30,
                  onPressed: _resetTimer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}