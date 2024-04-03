import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String _filePath = '';
  Duration _duration = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder?.closeRecorder();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final formattedDate =
          DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '');
      _filePath = '${directory.path}/records/$formattedDate.aac';

      final dir = Directory('${directory.path}/records/');
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      await _recorder!.startRecorder(
        toFile: _filePath,
        codec: Codec.aacMP4,
      );
      setState(() {
        _isRecording = true;
        _duration = Duration.zero;
      });
      _startTimer();
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _recorder!.stopRecorder();
      _timer?.cancel();
      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        _duration += Duration(milliseconds: 500);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Icon(_isRecording ? Icons.stop : Icons.mic),
            ),
            SizedBox(height: 20),
            if (_isRecording)
              Text(
                'Recording duration: ${_duration.inSeconds} seconds',
                style: TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RecordScreen(),
  ));
}
