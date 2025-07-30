// 獨立的Supabase測試腳本
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔍 Loading .env file...');
  await dotenv.load();
  
  print('📋 Environment check:');
  final url = dotenv.env['SUPABASE_URL'];
  final key = dotenv.env['SUPABASE_ANON_KEY'];
  
  print('URL: $url');
  print('Key: ${key?.substring(0, 20)}...');
  
  if (url == null || key == null) {
    print('❌ Environment variables not found!');
    return;
  }
  
  print('🚀 Initializing Supabase...');
  await Supabase.initialize(url: url, anonKey: key);
  
  final supabase = Supabase.instance.client;
  print('✅ Supabase initialized');
  
  try {
    print('📊 Testing ball_data query...');
    final response = await supabase
        .from('ball_data')
        .select('*')
        .limit(5);
    
    print('🎯 Query successful!');
    print('Records returned: ${response.length}');
    
    if (response.isNotEmpty) {
      print('📋 Sample data:');
      final first = response.first as Map<String, dynamic>;
      first.forEach((key, value) {
        print('  $key: $value');
      });
    } else {
      print('⚠️ No data returned - possible RLS issue?');
      
      // 測試權限
      print('🔐 Testing permissions...');
      final user = supabase.auth.currentUser;
      print('Current user: ${user?.id ?? 'Anonymous'}');
      print('User role: ${user?.role ?? 'anon'}');
    }
    
  } catch (e, stackTrace) {
    print('❌ Query failed: $e');
    print('Stack trace: $stackTrace');
  }
}