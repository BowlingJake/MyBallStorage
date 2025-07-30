import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDebugPage extends StatefulWidget {
  const SupabaseDebugPage({super.key});

  @override
  State<SupabaseDebugPage> createState() => _SupabaseDebugPageState();
}

class _SupabaseDebugPageState extends State<SupabaseDebugPage> {
  String _debugInfo = 'Press button to test connection';
  bool _isLoading = false;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _debugInfo = 'Testing connection...';
    });

    final buffer = StringBuffer();
    
    try {
      buffer.writeln('=== SUPABASE DEBUG INFO ===');
      
      // 1. 檢查環境變數
      buffer.writeln('\n📋 Environment Variables:');
      final url = dotenv.env['SUPABASE_URL'];
      final key = dotenv.env['SUPABASE_ANON_KEY'];
      buffer.writeln('URL: $url');
      buffer.writeln('Key: ${key?.substring(0, 20)}...');
      
      if (url == null || key == null) {
        buffer.writeln('❌ Environment variables not loaded!');
        setState(() {
          _debugInfo = buffer.toString();
          _isLoading = false;
        });
        return;
      }
      
      // 2. 測試Supabase連接
      buffer.writeln('\n🔗 Testing Supabase connection...');
      final supabase = Supabase.instance.client;
      
      // 3. 測試基本查詢
      buffer.writeln('\n📊 Testing ball_data query...');
      final response = await supabase
          .from('ball_data')
          .select('*')
          .limit(5);
      
      buffer.writeln('Query successful!');
      buffer.writeln('Records returned: ${response.length}');
      
      if (response.isNotEmpty) {
        buffer.writeln('\n🎯 Sample data:');
        final first = response.first as Map<String, dynamic>;
        first.forEach((key, value) {
          buffer.writeln('  $key: $value');
        });
      }
      
    } catch (e, stackTrace) {
      buffer.writeln('\n❌ ERROR: $e');
      buffer.writeln('\n📋 Stack trace:');
      buffer.writeln(stackTrace.toString());
    }
    
    setState(() {
      _debugInfo = buffer.toString();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Debug'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _testConnection,
              child: _isLoading 
                  ? const CircularProgressIndicator()
                  : const Text('Test Supabase Connection'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _debugInfo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}