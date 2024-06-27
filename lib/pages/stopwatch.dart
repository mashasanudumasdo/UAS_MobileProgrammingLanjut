import 'package:flutter/material.dart';
import 'dart:async';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({Key? key}) : super(key: key);

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  bool _isRunning = false;
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;
  List<Duration> _lapTimes = [];
  bool _showResetButton = false;

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _elapsedTime += Duration(milliseconds: 10);
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
      _lapTimes.clear();
      _showResetButton = false;
    });
  }

  void _recordLapTime() {
    setState(() {
      _lapTimes.add(_elapsedTime);
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
                    value: _isRunning ? null : 1.0,
                    strokeWidth: 5,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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
              child: Column(
                children: [
                  for (int i = _lapTimes.length - 1; i >= 0; i--)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('#${_lapTimes.length - i}'),
                          SizedBox(width: 20),
                          Text(
                            '${_formatTime(_lapTimes[i])}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 20),
                          Text(
                            i > 0
                                ? '${_formatTime(_lapTimes[i] - _lapTimes[i - 1])}'
                                : '',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Spacer(),
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
                        onTap: _isRunning ? _stopTimer : _startTimer,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: Icon(
                            _isRunning ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isRunning,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: _recordLapTime,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(255, 29, 113, 32),
                            ),
                            child: Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
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
    );
  }
}
