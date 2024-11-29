import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/pages/yard/yard_forms/vehicle_photo/exit_summary.dart';

class PhotoExitPage extends StatefulWidget {
  const PhotoExitPage({Key? key}) : super(key: key);

  @override
  _PhotoExitPageState createState() => _PhotoExitPageState();
}

class _PhotoExitPageState extends State<PhotoExitPage> {
  final ImagePicker _picker = ImagePicker();
  final Map<String, XFile?> _images = {
    'Front View': null,
    'Right View': null,
    'Back Views': null,
    'Left View': null,
    'Engine View': null,
    'Meter Reading': null,
  };

  final Map<String, String> _imageTimestamps = {};

  Future<void> _captureImage(String view) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Note"),
        content: const Text("Take clear and proper photos. Don't upload blurry photos."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _images[view] = image;
        _imageTimestamps[view] = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
      });
    }
  }

  void _submit() {
    if (_images.values.every((image) => image != null)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExitSummaryPage(
            customerName: "John Doe", // Replace with actual data
            engineNumber: "ABC123456",
            chassisNumber: "XYZ654321",
            color: "Red",
            vehicleClass: "SUV",
            vehicleCondition: "New",
            keyLocation: "Inside",
            transmission: "Automatic",
            remarks: "All in good condition",
            images: _images,
            imageTimestamps: _imageTimestamps,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture all required photos.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Exit Photos"),
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Capture Vehicle Exit Photos",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please take clear photos of all required views",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Divider(height: 32),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final entry = _images.entries.elementAt(index);
                  return _buildPhotoField(entry.key, entry.value);
                },
                childCount: _images.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Submit All Photos",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoField(String label, XFile? image) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => _captureImage(label),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        image: image != null
                            ? DecorationImage(
                                image: FileImage(File(image.path)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: image == null
                          ? const Center(
                              child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                            )
                          : null,
                    ),
                    if (image != null)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _imageTimestamps[label] ?? '',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _captureImage(label),
                icon: const Icon(Icons.camera_alt, size: 18),
                label: Text(image == null ? "Capture" : "Retake"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: image == null ? Colors.blue[700] : Colors.grey[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
