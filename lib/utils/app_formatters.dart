// Helper function to extract core category (Symmetric/Asymmetric)
String getCoreCategory(String coreName) {
  if (coreName.trim().isEmpty) {
    return '未知'; // Handle empty core names
  }
  final parts = coreName.trim().split(' ');
  return parts.last; // Return last part (works even if no space)
}

// Helper function to clean brand name (remove "bowling" word)
String cleanBrandName(String brandName) {
  return brandName
      .replaceAll(RegExp(r'\bbowling\b', caseSensitive: false), '')
      .trim()
      .replaceAll(RegExp(r'\s+'), ' '); // Remove extra spaces
} 