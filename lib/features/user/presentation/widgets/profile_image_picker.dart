import 'package:flutter/material.dart';

class ProfileImagePicker extends StatefulWidget {
  final String? imageUrl;
  final Function(String?)? onImageChanged;

  const ProfileImagePicker({
    super.key,
    this.imageUrl,
    this.onImageChanged,
  });

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 56,
                    backgroundImage: _currentImageUrl != null
                        ? NetworkImage(_currentImageUrl!)
                        : null,
                    child: _currentImageUrl == null
                        ? const Icon(Icons.person, size: 48)
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _pickImage,
            child: Text(
              _currentImageUrl == null ? '新增個人照片' : '更換照片',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_currentImageUrl != null)
            TextButton(
              onPressed: _removeImage,
              child: Text(
                '移除照片',
                style: TextStyle(
                  color: Colors.red[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _pickImage() {
    // TODO: Implement actual image picking logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('選擇照片來源'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('相機'),
              onTap: () {
                Navigator.of(context).pop();
                _simulateImageSelection();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('相片庫'),
              onTap: () {
                Navigator.of(context).pop();
                _simulateImageSelection();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeImage() {
    setState(() {
      _currentImageUrl = null;
    });
    widget.onImageChanged?.call(null);
  }

  void _simulateImageSelection() {
    // TODO: Replace with actual image selection
    setState(() {
      _currentImageUrl = 'https://via.placeholder.com/150';
    });
    widget.onImageChanged?.call(_currentImageUrl);
  }
} 