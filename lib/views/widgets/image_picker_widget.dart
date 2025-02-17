import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../controllers/discovery_controller.dart';

class ImagePickerWidget extends StatelessWidget {
  final DiscoveryController discoveryController;

  const ImagePickerWidget({
    Key? key,
    required this.discoveryController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () => _showImageSourceDialog(context),
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Add Images'),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (discoveryController.selectedImages.isEmpty) {
            return const SizedBox.shrink();
          }
          return Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: discoveryController.selectedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.file(
                        File(discoveryController.selectedImages[index].path),
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        onPressed: () => discoveryController.removeImage(index),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }),
      ],
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                discoveryController.pickImages();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                discoveryController.takePhoto();
              },
            ),
          ],
        ),
      ),
    );
  }
}
