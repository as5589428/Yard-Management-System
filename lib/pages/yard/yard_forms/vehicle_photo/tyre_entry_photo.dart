import 'package:flutter/material.dart';
// import 'package:flutter_application_1/pages/yard/panels/yard_panel_page.dart';
import 'package:flutter_application_1/pages/yard/yard_forms/vehicle_photo/entry_summary.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../api_Service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
class TyreEntryPhotoPage extends StatefulWidget {
  final Map<String, XFile?> vehicleImages;

  const TyreEntryPhotoPage({Key? key, required this.vehicleImages}) : super(key: key);
  

  @override
  _TyreEntryPhotoPageState createState() => _TyreEntryPhotoPageState();
  
}
  // Initialize the ApiService
  final ApiService _apiService = ApiService();

class _TyreEntryPhotoPageState extends State<TyreEntryPhotoPage> {
  final _picker = ImagePicker();
  String? selectedVehicle;
  int tyreCount = 0;
  List<XFile?>  tyrePhotos = [];
  bool isLoading = false;

  final Map<String, Map<String, dynamic>> vehicleTypes = {
    'Two Wheeler': {
      'tyres': 2,
      'icon': Icons.motorcycle,
      'subtypes': ['Scooter', 'Motorcycle', 'Electric Bike']
    },
    'Car': {
      'tyres': 4,
      'icon': Icons.directions_car,
      'subtypes': ['Sedan', 'SUV', 'Hatchback', 'Electric Car']
    },
    'Van': {
      'tyres': 4,
      'icon': Icons.airport_shuttle,
      'subtypes': ['Mini Van', 'Cargo Van', 'Passenger Van']
    },
    'Light Truck': {
      'tyres': 6,
      'icon': Icons.local_shipping,
      'subtypes': ['Pickup Truck', 'Delivery Truck']
    },
    'Heavy Truck': {
      'tyres': 10,
      'icon': Icons.fire_truck,
      'subtypes': ['Semi-Trailer', 'Dump Truck', 'Tanker']
    },
    'Bus': {
      'tyres': 6,
      'icon': Icons.directions_bus,
      'subtypes': ['City Bus', 'Coach', 'Mini Bus']
    },
  };

  String? selectedSubtype;

 void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Vehicle entered the yard successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryPage(
                      vehicleImages: widget.vehicleImages,
                      tyreImages: tyrePhotos,
                    ),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
Future<void> _submit() async {
  // Check if all required vehicle and tyre images are captured
  if (widget.vehicleImages.values.every((image) => image != null) && tyrePhotos.every((photo) => photo != null)) {
    try {
      // Retrieve uniqueId from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? uniqueId = prefs.getString('uniqueId');
      
      if (uniqueId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unique ID not found. Please log in again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Use the uniqueId from SharedPreferences
      String id = uniqueId;

      // Combine both vehicle and tyre images for API upload
      Map<String, XFile?> combinedImages = {
        ...widget.vehicleImages, // Existing vehicle images
        for (int i = 1; i < tyrePhotos.length; i++)
          'tyre${i + 1}': tyrePhotos[i], // Adding tyre images with a key format
      };

      // Call the uploadVehiclePhotos method from the ApiService
final response = await _apiService.uploadVehiclePhotos(id, combinedImages);

      // Handle the API response
      if (response.statusCode == 200) {
        // Proceed to the Summary Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SummaryPage(
              vehicleImages: widget.vehicleImages,
              tyreImages: tyrePhotos,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload photos: ${response.body}'),
            backgroundColor: const Color.fromARGB(255, 143, 22, 212),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading photos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please capture all required vehicle and tyre photos.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<void> captureTyrePhoto(int index) async {
  setState(() {
    isLoading = true;
  });

  try {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo != null) {
      setState(() {
        tyrePhotos[index] = photo;
      });
    } else {
      // Notify if no photo is taken
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No photo was taken.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  } catch (e) {
    // Error: Show exception message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error capturing photo: $e')),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  Widget _buildTyrePhotoCard(int index) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text('${index + 1}'),
            ),
            title: Text( 
              'tyre${index + 1}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(tyrePhotos[index] != null 
              ? 'Photo captured' 
              : 'No photo taken yet'),
          ),
          if (tyrePhotos[index] != null)
            Container(
              height: 200,
              width: double.infinity,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(File(tyrePhotos[index]!.path)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ElevatedButton.icon(
              onPressed: () => captureTyrePhoto(index),
              icon: Icon(Icons.camera_alt),
              label: Text(tyrePhotos[index] != null ? 'Retake Photo' : 'Capture Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
        title: Text('Tyre Inspection'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('How to capture tyre photos'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.looks_one),
                        title: Text('Select vehicle type'),
                      ),
                      ListTile(
                        leading: Icon(Icons.looks_two),
                        title: Text('Choose vehicle subtype'),
                      ),
                      ListTile(
                        leading: Icon(Icons.looks_3),
                        title: Text('Capture clear photos of each tyre'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedVehicle,
                          hint: Text('Select Vehicle Type'),
                          items: vehicleTypes.keys.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Row(
                                children: [
                                  Icon(vehicleTypes[type]!['icon']),
                                  SizedBox(width: 8),
                                  Text(type),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedVehicle = value;
                              selectedSubtype = null;
                              tyreCount = vehicleTypes[value]!['tyre'];
                              tyrePhotos = List<XFile?>.filled(tyreCount, null);
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    if (selectedVehicle != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedSubtype,
                            hint: Text('Select ${selectedVehicle} Type'),
                            items: vehicleTypes[selectedVehicle]!['subtypes']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedSubtype = value;
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (selectedVehicle != null && selectedSubtype != null)
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.tire_repair, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'tyre$tyreCount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: selectedVehicle != null && selectedSubtype != null
                    ? ListView.builder(
                        padding: EdgeInsets.only(bottom: 100),
                        itemCount: tyreCount,
                        itemBuilder: (context, index) => _buildTyrePhotoCard(index),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_car,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Select vehicle type to start',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: selectedVehicle != null && 
                          selectedSubtype != null && 
                          tyrePhotos.every((photo) => photo != null)
          ? FloatingActionButton.extended(
              onPressed: () {
                _submit();
              },
              icon: Icon(Icons.check),
              label: Text('Submit'),
            )
          : null,
    );
  }
}