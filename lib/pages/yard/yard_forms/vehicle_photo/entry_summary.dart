import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SummaryPage extends StatelessWidget {
  final Map<String, XFile?> vehicleImages;
  final List<XFile?> tyreImages;

  const SummaryPage({
    Key? key,
    required this.vehicleImages,
    required this.tyreImages,
  }) : super(key: key);

  Widget _buildImageCard(String title, XFile? image) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (image != null)
            GestureDetector(
              onTap: () {
                // TODO: Implement full-screen image view
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(image.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vehicle Summary",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[50],
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Vehicle Photos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...vehicleImages.entries
                .map((entry) => _buildImageCard(
                      entry.key,
                      entry.value,
                    ))
                .toList(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Tyre Photos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...tyreImages.asMap().entries
                .map((entry) => _buildImageCard(
                      'Tyre ${entry.key + 1}',
                      entry.value,
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}