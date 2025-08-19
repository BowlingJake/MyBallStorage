import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

/// 圖片上傳服務
class ImageUploadService {
  final SupabaseClient _supabase;
  
  ImageUploadService(this._supabase);
  
  /// 上傳用戶頭像
  Future<String> uploadUserAvatar({
    required String userId,
    required XFile imageFile,
  }) async {
    try {
      // 讀取圖片資料
      final bytes = await imageFile.readAsBytes();
      
      // 生成唯一檔名
      final fileExtension = path.extension(imageFile.path).isNotEmpty 
          ? path.extension(imageFile.path) 
          : '.jpg';
      final fileName = 'avatar_${userId}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      
      // 上傳到Supabase Storage
      await _supabase.storage
          .from('avatars')
          .uploadBinary(fileName, bytes);
      
      // 獲取公開URL
      final publicUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(fileName);
      
      // 驗證URL
      if (!publicUrl.startsWith('http')) {
        throw Exception('無效的URL: $publicUrl');
      }
      
      return publicUrl;
      
    } catch (e) {
      // 提供友好的錯誤信息
      if (e.toString().contains('permission') || e.toString().contains('unauthorized')) {
        throw Exception('權限不足：請檢查Supabase設定');
      } else if (e.toString().contains('bucket')) {
        throw Exception('Storage配置錯誤：請確認avatars bucket存在');
      } else {
        throw Exception('上傳失敗: $e');
      }
    }
  }
  
  /// 刪除舊頭像
  Future<void> deleteOldAvatar(String avatarUrl) async {
    try {
      // 從URL中提取檔名
      final uri = Uri.parse(avatarUrl);
      final fileName = path.basename(uri.path);
      
      await _supabase.storage
          .from('avatars')
          .remove([fileName]);
          
    } catch (e) {
      // 刪除失敗不影響主流程
    }
  }
}