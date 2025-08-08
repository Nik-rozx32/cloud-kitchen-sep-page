import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static void showImagePickerBottomSheet({
    required BuildContext context,
    required Future<void> Function(ImageSource) onImageSourceSelected,
    required VoidCallback? onRemoveImage,
    required bool hasExistingImage,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await onImageSourceSelected(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take a Picture'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await onImageSourceSelected(ImageSource.camera);
                },
              ),
              if (hasExistingImage && onRemoveImage != null)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Remove Photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    onRemoveImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  static Future<Map<String, dynamic>?> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          return {
            'webImage': bytes,
            'selectedImage': null,
          };
        } else {
          return {
            'webImage': null,
            'selectedImage': File(image.path),
          };
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error picking image: $e');
    }
  }
}