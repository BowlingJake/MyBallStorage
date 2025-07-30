import 'package:supabase_flutter/supabase_flutter.dart';

class RLSDiagnostic {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// 診斷RLS設定問題
  static Future<void> diagnoseRLS() async {
    print('🔐 === RLS DIAGNOSTIC ===');
    
    try {
      // 1. 檢查當前用戶狀態
      final user = _supabase.auth.currentUser;
      print('👤 Current user: ${user?.id ?? "Anonymous"}');
      print('📧 User email: ${user?.email ?? "None"}');
      print('🏷️ User role: ${user?.role ?? "anon"}');
      
      // 2. 測試基本查詢
      print('\n📊 Testing basic select...');
      try {
        final response = await _supabase
            .from('ball_data')
            .select('id, ball_name')
            .limit(3);
        print('✅ Basic select returned: ${response.length} records');
        if (response.isNotEmpty) {
          print('Sample: ${response.first}');
        }
      } catch (e) {
        print('❌ Basic select failed: $e');
      }
      
      // 3. 測試計數查詢 (如果RLS設定了policy可能會有不同結果)
      print('\n🔢 Testing count query...');
      try {
        final countResponse = await _supabase
            .rpc('count_ball_data'); // 這需要在Supabase中創建這個函數
        print('Count result: $countResponse');
      } catch (e) {
        print('Count query failed (expected if RPC doesn\'t exist): $e');
      }
      
      // 4. 嘗試繞過RLS的查詢 (使用service key才能做，這裡只是測試)
      print('\n🛡️ RLS Status Info:');
      print('If queries return empty but table has data, RLS is likely blocking access.');
      print('Solutions:');
      print('1. Disable RLS: ALTER TABLE ball_data DISABLE ROW LEVEL SECURITY;');
      print('2. Create policy: CREATE POLICY "Allow anonymous read" ON ball_data FOR SELECT USING (true);');
      
    } catch (e) {
      print('❌ RLS diagnostic failed: $e');
    }
  }

  /// 提供修復RLS問題的SQL指令
  static void printRLSFixSQL() {
    print('\n🔧 === RLS FIX SQL COMMANDS ===');
    print('Execute these commands in Supabase SQL Editor:');
    print('');
    print('-- Option 1: Disable RLS entirely (simpler but less secure)');
    print('ALTER TABLE ball_data DISABLE ROW LEVEL SECURITY;');
    print('');
    print('-- Option 2: Enable RLS with public read policy (more secure)');
    print('ALTER TABLE ball_data ENABLE ROW LEVEL SECURITY;');
    print('CREATE POLICY "Allow public read access" ON ball_data');
    print('    FOR SELECT USING (true);');
    print('');
    print('-- Option 3: Grant direct permissions to anon role');
    print('GRANT SELECT ON ball_data TO anon;');
  }
}