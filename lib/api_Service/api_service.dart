import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:image_picker/image_picker.dart';

class ApiService {
  // Method to get the unique ID from the inward API
  Future<String> getInwardUniqueId(
      String clientName, String agreementNumber) async {
    // Prepare the body with required parameters
    var body = jsonEncode({
      'clientName': clientName,
      'agreementNumber': agreementNumber,
    });

    final url = Uri.parse(
        'http://192.168.0.194:5000/api/inward'); // Replace with actual API URL
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    // Debug the response
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      String uniqueId = responseData['data']?['uniqueId'] ?? 'Unknown';
      print('Generated Unique ID: $uniqueId');
      return uniqueId;
    } else {
      throw Exception('Failed to get uniqueId from inward API');
    }
  }

  // Upload vehicle photos

  // Future<http.Response> uploadVehiclePhotos(
  //     String uniqueId, Map<String, XFile?> images) async {
  //   // Prepare the request URL with the unique ID
  //   final url = Uri.parse(
  //       'http://192.168.0.194:5000/api/inward/$uniqueId/photos'); // Use the uniqueId in the URL
  //   var request = http.MultipartRequest('POST', url);

  //   try {
  //     // Add images to the request
  //     for (String view in images.keys) {
  //       XFile? image = images[view];
  //       if (image != null) {
  //         request.files.add(
  //           await http.MultipartFile.fromPath(
  //             view, // Use the key from _images as the field name
  //             image.path,
  //             filename: '$view.jpg',
  //           ),
  //         );
  //       }
  //     }

  //     // Send the request
  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);

  //     // Return the response
  //     return response;
  //   } catch (e) {
  //     print('Error uploading images Api_Service: $e');
  //     throw Exception('Failed to upload images');
  //   }
  // }
// Future<http.Response> uploadVehiclePhotos(
//     String uniqueId, Map<String, XFile?> images, Map<String, XFile?> combinedImages) async {
//   // Prepare the request URL with the unique ID
//   final url = Uri.parse(
//       'http://192.168.0.194:5000/api/inward/$uniqueId/photos'); // Use the uniqueId in the URL
  
//   var request = http.MultipartRequest('POST', url);

//   try {
//     // Add vehicle images to the request
//     for (String view in images.keys) {
//       XFile? image = images[view];
//       if (image != null) {
//         request.files.add(
//           await http.MultipartFile.fromPath(
//             view, // Use the key from _images as the field name
//             image.path,
//             filename: '$view.jpg',
//           ),
//         );
//       }
//     }

//     // Add tyre images to the request
//     for (String view in combinedImages.keys) {
//       XFile? image = combinedImages[view];
//       if (image != null) {
//         request.files.add(
//           await http.MultipartFile.fromPath(
//             'tyre$view', // Use tyre field names like 'tyre1', 'tyre2', etc.
//             image.path,
//             filename: 'tyre$view.jpg',
//           ),
//         );
//       }
//     }

//     // Send the request
//     var streamedResponse = await request.send();
//     var response = await http.Response.fromStream(streamedResponse);

//     // Return the response
//     return response;
//   } catch (e) {
//     print('Error uploading images Api_Service: $e');
//     throw Exception('Failed to upload images');
//   }
// }
Future<http.Response> uploadVehiclePhotos(
    String uniqueId, Map<String, XFile?> combinedImages) async {
  // Prepare the request URL with the unique ID
  final url = Uri.parse(
      'http://192.168.0.194:5000/api/inward/$uniqueId/photos'); // Use the uniqueId in the URL
  
  var request = http.MultipartRequest('POST', url);

  try {
    // Iterate over the combinedImages map
    for (String view in combinedImages.keys) {
      // Check if the key starts with 'tyre_' to ensure it's a tyre image
      if (view.startsWith('tyre_')) {
        XFile? image = combinedImages[view];
        
        if (image != null) {
          // Remove underscores for the field name
          String fieldName = view.replaceAll('_', '');
          
          // Add only tyre images to the request
          request.files.add(
            await http.MultipartFile.fromPath(
              view, // Use the key format directly
              image.path,
              filename: '$fieldName.jpg',
            ),
          );
        }
      }
    }

    // Send the request
    var streamedResponse = await request.send();

    // Handle the response
    var response = await http.Response.fromStream(streamedResponse);
    
    // Check if the response status code is 200 (OK)
    if (response.statusCode == 200) {
      // If successful, return the response
      return response;
    } else {
      // Handle API error responses
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to upload images. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading images Api_Service: $e');
    throw Exception('Failed to upload images api');
  }
}

}
