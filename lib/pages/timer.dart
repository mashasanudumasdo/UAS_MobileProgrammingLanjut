import 'package:flutter/material.dart';
import 'dart:async';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool _isRunning = false;
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;
  bool _showResetButton = false;
  bool _volumeEnabled = false;

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        if (_elapsedTime.inMilliseconds <= 0) {
          _timer?.cancel();
          _isRunning = false;
          _showResetButton = true;
        } else {
          _elapsedTime -= Duration(milliseconds: 10);
        }
      });
    });
    setState(() {
      _isRunning = true;
      _showResetButton = true;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _elapsedTime = Duration.zero;
      _isRunning = false;
      _showResetButton = false;
    });
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds =
        twoDigits((duration.inMilliseconds.remainder(1000) / 10).floor());
    return "$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliseconds";
  }

  void _showTimerPickerDialog() async {
    Duration? selectedDuration = await showDialog<Duration>(
      context: context,
      builder: (BuildContext context) => TimerPickerDialog(),
    );

    if (selectedDuration != null) {
      setState(() {
        _elapsedTime = selectedDuration;
      });
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 400,
                  height: 400,
                  child: CircularProgressIndicator(
                    value: _isRunning
                        ? _elapsedTime.inMilliseconds / 60000
                        : 1.0, // Show full circle when not running
                  ),
                ),
                Text(
                  _formatTime(_elapsedTime),
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Spacer(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: _showResetButton,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: _resetTimer,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 29, 113, 32),
                            ),
                            child: Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                      width: 80,
                      height: 80,
                      child: GestureDetector(
                        onTap: _isRunning ? _stopTimer : _showTimerPickerDialog,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: Icon(
                            _isRunning ? Icons.pause : Icons.timer,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black, // Set background color to black
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  // Add logic for +1 sec
                });
              },
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '+1',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Text color
                    ),
                  ),
                  Text(
                    'sec',
                    style: TextStyle(
                        fontSize: 10, color: Colors.white), // Text color
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  // Add logic for +10 sec
                });
              },
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '+10',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Text color
                    ),
                  ),
                  Text(
                    'sec',
                    style: TextStyle(
                        fontSize: 10, color: Colors.white), // Text color
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: _volumeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _volumeEnabled = value;
                    });
                  },
                  activeColor: Colors.blue, // Color when switch is ON
                  materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // Adjust size
                ),
                Text(
                  'REPEAT',
                  style: TextStyle(
                      fontSize: 10, color: Colors.white), // Text color
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: _volumeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _volumeEnabled = value;
                    });
                  },
                  activeColor: Colors.blue, // Color when switch is ON
                  materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // Adjust size
                ),
                Text(
                  'VOLUME',
                  style: TextStyle(
                      fontSize: 10, color: Colors.white), // Text color
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimerPickerDialog extends StatefulWidget {
  const TimerPickerDialog({Key? key}) : super(key: key);

  @override
  _TimerPickerDialogState createState() => _TimerPickerDialogState();
}

class _TimerPickerDialogState extends State<TimerPickerDialog> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set Timer'),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButton<int>(
              value: _hours,
              items: List.generate(24, (index) {
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(index.toString() + 'h '),
                );
              }),
              onChanged: (value) {
                setState(() {
                  _hours = value!;
                });
              },
            ),
            DropdownButton<int>(
              value: _minutes,
              items: List.generate(60, (index) {
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(index.toString() + 'm '),
                );
              }),
              onChanged: (value) {
                setState(() {
                  _minutes = value!;
                });
              },
            ),
            DropdownButton<int>(
              value: _seconds,
              items: List.generate(60, (index) {
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(index.toString() + 's '),
                );
              }),
              onChanged: (value) {
                setState(() {
                  _seconds = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(Duration(
              hours: _hours,
              minutes: _minutes,
              seconds: _seconds,
            ));
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
