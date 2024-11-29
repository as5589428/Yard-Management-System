// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/pages/yard/yard_forms/vehicle_photo/tyre_entry_photo.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import '../../../../api_Service/api_service.dart';
// import 'package:shared_preferences/shared_preferences.dart'; 
// class PhotoEntryPage extends StatefulWidget {
//   const PhotoEntryPage({Key? key}) : super(key: key);

//   @override
//   _PhotoEntryPageState createState() => _PhotoEntryPageState();
  
// }

// class _PhotoEntryPageState extends State<PhotoEntryPage> {
//   final ImagePicker _picker = ImagePicker();
//   final Map<String, XFile?> images = {
//     'frontView': null,
//     'rightView': null,
//     'backView': null,
//     'leftView': null,
//     'engineView': null,
//     'meterReading': null,
//   };
//   final Map<String, String> _imageTimestamps = {};

//   // Initialize the ApiService
//   final ApiService _apiService = ApiService();

//   Future<void> _captureImage(String view) async {
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Note"),
//         content: const Text("Take clear and proper photos. Don't upload blurry photos."),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );

//     final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       setState(() {
//         images[view] = image;
//         _imageTimestamps[view] = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
//       });
//     }
//   }

//   // Function to submit the captured images to the API
//  Future<void> _submit() async {
//   if (images.values.every((image) => image != null)) {
//     try {
      
//       // Retrieve uniqueId from SharedPreferences
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? uniqueId = prefs.getString('uniqueId');  // Replace with your actual key if different
//       print("i");
//       print(uniqueId);
//       if (uniqueId == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Unique ID not found. Please log in again.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       // Replace 'id' with 'uniqueId' if needed
//       String id = uniqueId; // Using the uniqueId from SharedPreferences

//       // Call the uploadVehiclePhotos method from the ApiService
//       final response = await _apiService.uploadVehiclePhotos(id, images);

//       // Handle the API response
//       if (response.statusCode == 200) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TyreEntryPhotoPage(vehicleImages: images),
//           ),
//         );
        
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to upload photos Aman: ${response.body}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error uploading photos Photo Entry: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Please capture all required photos.'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }

// void _openTyreEntryPage() {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => TyreEntryPhotoPage(vehicleImages: images)),
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Vehicle Photos"),
//         backgroundColor: Colors.blue[700],
//         elevation: 0,
//       ),
//       body: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Capture Vehicle Photos",
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                       color: Colors.blue[700],
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Please take clear photos of all required views",
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   const Divider(height: 32),
//                 ],
//               ),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.75,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//               ),
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   final entry = images.entries.elementAt(index);
//                   return _buildPhotoField(entry.key, entry.value);
//                 },
//                 childCount: images.length,
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: ElevatedButton(
//                 onPressed: _submit,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue[700],
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   minimumSize: const Size.fromHeight(48),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   "Save and Next",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPhotoField(String label, XFile? image) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () => _captureImage(label),
//                 child: Stack(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(8),
//                         image: image != null
//                             ? DecorationImage(
//                                 image: FileImage(File(image.path)),
//                                 fit: BoxFit.cover,
//                               )
//                             : null,
//                       ),
//                       child: image == null
//                           ? const Center(
//                               child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
//                             )
//                           : null,
//                     ),
//                     if (image != null)
//                       Positioned(
//                         bottom: 8,
//                         right: 8,
//                         child: Container(
//                           padding: const EdgeInsets.all(4.0),
//                           decoration: BoxDecoration(
//                             color: Colors.black54,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Text(
//                             _imageTimestamps[label] ?? '',
//                             style: const TextStyle(color: Colors.white, fontSize: 12),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () => _captureImage(label),
//                 icon: const Icon(Icons.camera_alt, size: 18),
//                 label: Text(image == null ? "Capture" : "Retake"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: image == null ? Colors.blue[700] : Colors.grey[700],
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/yard/yard_forms/vehicle_photo/tyre_entry_photo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PhotoEntryPage extends StatefulWidget {
  const PhotoEntryPage({Key? key}) : super(key: key);

  @override
  _PhotoEntryPageState createState() => _PhotoEntryPageState();
}

class _PhotoEntryPageState extends State<PhotoEntryPage> {
  final ImagePicker _picker = ImagePicker();
  final Map<String, XFile?> _images = {
    'Front View': null,
    'Right View': null,
    'Back View': null,
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
          builder: (context) => TyreEntryPhotoPage(vehicleImages: _images),
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

void _openTyreEntryPage() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TyreEntryPhotoPage(vehicleImages: _images)),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Photos"),
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
                    "Capture Vehicle Photos",
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
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Save and Next",
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