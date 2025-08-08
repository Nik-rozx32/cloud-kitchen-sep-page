import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:typed_data';

class ImagePickerWidget extends StatelessWidget {
  final File? selectedImage;
  final Uint8List? webImage;
  final VoidCallback onPickImage;
  final VoidCallback onDeleteImage;

  const ImagePickerWidget({
    super.key,
    this.selectedImage,
    this.webImage,
    required this.onPickImage,
    required this.onDeleteImage,
  });

  bool get _hasImage {
    return (kIsWeb && webImage != null) || (!kIsWeb && selectedImage != null);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onPickImage,
              child: Container(
                height: _hasImage ? 120 : 50,
                width: _hasImage ? 180 : 50,
                decoration: BoxDecoration(
                  border: _hasImage
                      ? null 
                      : Border.all(color: Colors.grey[300]!, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: _hasImage
                      ? null
                      : Colors.grey[50], 
                ),
                child: _hasImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8), 
                        child: _buildImage(),
                      )
                    : Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.grey[600],
                      ),
              ),
            ),
            if (_hasImage) ...[
              SizedBox(width: 8),
              GestureDetector(
                onTap: onDeleteImage,
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (kIsWeb) {
      return Image.memory(
        webImage!,
        width: 120,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        selectedImage!,
        width: 120,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }
}