import 'package:flutter/material.dart';

// Placeholder model class for cry analysis result
class CryAnalysisResult {
  final DateTime timestamp;
  final String result;

  CryAnalysisResult({required this.timestamp, required this.result});
}

class HistoryScreen extends StatelessWidget {
  final List<CryAnalysisResult> cryAnalysisResults;

  const HistoryScreen({Key? key, required this.cryAnalysisResults}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cry Analysis History'),
      ),
      body: ListView.builder(
        itemCount: cryAnalysisResults.length,
        itemBuilder: (context, index) {
          final result = cryAnalysisResults[index];
          return ListTile(
            title: Text('Timestamp: ${result.timestamp}'),
            subtitle: Text('Analysis Result: ${result.result}'),
          );
        },
      ),
    );
  }
}
