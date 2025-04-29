import 'package:flutter/material.dart';
import 'dart:async'; // Add this import for Timer

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _minutes = 25;
  int _seconds = 0;
  bool _isWorking = true;
  bool _isRunning = false;
  late Timer _timer;

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          if (_minutes > 0) {
            _minutes--;
            _seconds = 59;
          } else {
            _timer.cancel();
            _isRunning = false;
            if (_isWorking) {
              _minutes = 5;
              _isWorking = false;
            } else {
              _minutes = 25;
              _isWorking = true;
            }
          }
        }
      });
    });
  }

  void _pauseTimer() {
    _timer.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
      _minutes = _isWorking ? 25 : 5;
      _seconds = 0;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRunning)
                  ElevatedButton(
                    onPressed: _startTimer,
                    child: const Text('Start'),
                  ),
                if (_isRunning)
                  ElevatedButton(
                    onPressed: _pauseTimer,
                    child: const Text('Pause'),
                  ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text('Reset'),
                ),
              ],
            ),
            Text(_isWorking ? 'Work Time' : 'Break Time'),
          ],
        ),
      ),
    );
  }
}