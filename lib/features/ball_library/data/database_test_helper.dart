import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseTestHelper {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// 測試.env配置和Supabase連接
  static Future<void> testConnection() async {
    try {
      print('🔍 === SUPABASE CONNECTION DIAGNOSTIC ===');
      
      // 1. 檢查環境變數
      print('📋 Environment Variables:');
      print('  SUPABASE_URL: ${dotenv.env['SUPABASE_URL']}');
      print('  SUPABASE_ANON_KEY: ${dotenv.env['SUPABASE_ANON_KEY']?.substring(0, 20)}...');
      
      // 2. 檢查.env文件是否正確載入
      print('🔧 Environment Check:');
      final envUrl = dotenv.env['SUPABASE_URL'];
      final envKey = dotenv.env['SUPABASE_ANON_KEY'];
      
      if (envUrl == null || envKey == null) {
        print('❌ .env file not loaded correctly!');
        print('  SUPABASE_URL is null: ${envUrl == null}');
        print('  SUPABASE_ANON_KEY is null: ${envKey == null}');
        return;
      }
      
      // 3. 測試基本連接
      print('🌐 Testing basic connection to ball_data...');
      try {
        final response = await _supabase.from('ball_data')
            .select('id')
            .limit(1);
        print('  Basic query result: $response');
        print('  Response type: ${response.runtimeType}');
        print('  Response length: ${response.length}');
      } catch (e) {
        print('  Basic query failed: $e');
      }
      
      // 5. 測試不同的查詢方式
      print('🔍 Testing different query approaches...');
      
      // 測試不同可能的資料表名稱
      final possibleTableNames = [
        'ball_data',  // 使用者確認的資料表名稱
        'bowling_balls',
        'balls',
        'ball_library'
      ];
      
      for (final tableName in possibleTableNames) {
        try {
          print('📊 Testing table: $tableName');
          final response = await _supabase
              .from(tableName)
              .select('*')
              .limit(1);
          
          print('✅ Table "$tableName" exists! Sample data:');
          print(response);
          
          // 如果成功，顯示資料表結構和更多詳細資訊
          if (response.isNotEmpty) {
            final firstRow = response.first as Map<String, dynamic>;
            print('📋 Table structure for $tableName:');
            firstRow.keys.forEach((key) {
              final value = firstRow[key];
              print('  - $key: ${value.runtimeType} = $value');
            });
            print('✅ Successfully found table: $tableName with ${response.length} sample records');
            
            // 測試完整查詢
            try {
              final fullResponse = await _supabase
                  .from(tableName)
                  .select('*')
                  .limit(5);
              print('🎯 Full query returned ${fullResponse.length} records');
            } catch (e) {
              print('⚠️ Full query failed: $e');
            }
            
            return; // 成功找到資料表，退出方法
          } else {
            print('⚠️ Table "$tableName" exists but returned no data');
          }
          
        } catch (e) {
          print('❌ Table "$tableName" error: $e');
        }
      }
      
      // 6. 測試權限問題
      print('🔐 Testing RLS and permissions...');
      try {
        final authUser = _supabase.auth.currentUser;
        print('  Current user: ${authUser?.id ?? 'Anonymous'}');
        print('  User role: ${authUser?.role ?? 'anon'}');
        
        // 測試簡單查詢看是否有權限問題
        try {
          final testQuery = await _supabase
              .from('ball_data')
              .select('*')
              .limit(1);
          print('  Permission test query returned: ${testQuery.length} records');
        } catch (e) {
          print('  Permission test query failed: $e');
        }
      } catch (e) {
        print('  Permission test failed: $e');
      }
      
    } catch (e) {
      print('🚨 === DIAGNOSTIC FAILED ===');
      print('Error: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  /// 測試特定資料表的資料
  static Future<void> testTableData(String tableName) async {
    try {
      print('🔍 Testing table: $tableName');
      
      final response = await _supabase
          .from(tableName)
          .select('*')
          .limit(5);
      
      print('✅ Found ${response.length} records in $tableName:');
      
      for (int i = 0; i < response.length; i++) {
        final row = response[i] as Map<String, dynamic>;
        print('Record ${i + 1}:');
        print('  ID: ${row['id']}');
        print('  Name: ${row['ball_name'] ?? row['name'] ?? 'N/A'}');
        print('  Brand: ${row['brand'] ?? 'N/A'}');
        print('  ---');
      }
      
    } catch (e) {
      print('❌ Error testing table $tableName: $e');
    }
  }
}