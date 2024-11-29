import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SharedPreferenceManager {
  static const String _keyToken = 'jwt_token';
  static const String _keyUserId = 'user_id';
  static const String _keyIsLoggedIn = 'is_logged_in'; // Key for login status
  static const String _keyUniqueId = 'uniqueId'; // Key for storing uniqueId
  List<dynamic> vehicleData = [];
  List<String> makeList = [];
  List<String> modelList = [];
  List<String> variantList = [];
  List<String> segmentList = [];

  // Save token and user ID to Shared Preferences
  Future<void> saveUserDetails(String token, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUserId, userId);
    await prefs.setBool(_keyIsLoggedIn, true); // Set logged-in status
  }

  // Save uniqueId to Shared Preferences (new function)
  Future<void> saveInwardFormDetails(String uniqueId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUniqueId, uniqueId);
  }

  // Retrieve token from Shared Preferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Save uniqueId to SharedPreferences
  Future<void> saveUniqueId(String uniqueId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUniqueId, uniqueId); // Save the uniqueId with the key
  }
  // Retrieve uniqueId from Shared Preferences
  Future<String?> getUniqueId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUniqueId);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false; // Default to false
  }

  // Clear all preferences (Logout)
  Future<void> clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Fetch vehicle data and update lists
  Future<void> fetchVehicleData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.194:5000/api/makeModelDataset'));
      if (response.statusCode == 200) {
        vehicleData = json.decode(response.body);

        // Extract and update make, model, variant, and segment lists
        makeList = vehicleData.map((item) => item['Make'] as String).toSet().toList();
        modelList = vehicleData.map((item) => item['Model'] as String).toSet().toList();
        variantList = vehicleData.map((item) => item['Variant'] as String).toSet().toList();
        segmentList = vehicleData.map((item) => item['Segment'] as String).toSet().toList();

        // You can add a print or debugging log here to verify
        print('Makes: $makeList');
        print('Models: $modelList');
        print('Variants: $variantList');
        print('Segments: $segmentList');
      } else {
        throw Exception('Failed to load vehicle data');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }
}
