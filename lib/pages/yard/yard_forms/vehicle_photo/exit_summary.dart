import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ExitSummaryPage extends StatelessWidget {
  final String customerName;
  final String engineNumber;
  final String chassisNumber;
  final String color;
  final String vehicleClass;
  final String vehicleCondition;
  final String keyLocation;
  final String transmission;
  final String remarks;
  final Map<String, String> imageTimestamps;
  final Map<String, XFile?> images;

  const ExitSummaryPage({
    Key? key,
    required this.customerName,
    required this.engineNumber,
    required this.chassisNumber,
    required this.color,
    required this.vehicleClass,
    required this.vehicleCondition,
    required this.keyLocation,
    required this.transmission,
    required this.remarks,
    required this.imageTimestamps,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exit Summary"),
        backgroundColor: Colors.red[700], // Use a distinct color for the exit summary page
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Exit Vehicle Details",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text("Customer Name: $customerName"),
              Text("Engine Number: $engineNumber"),
              Text("Chassis Number: $chassisNumber"),
              Text("Color: $color"),
              Text("Vehicle Class: $vehicleClass"),
              Text("Vehicle Condition: $vehicleCondition"),
              Text("Key Location: $keyLocation"),
              Text("Transmission: $transmission"),
              Text("Remarks: $remarks"),
              const Divider(height: 32),
              Text(
                "Captured Exit Photos",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              ...images.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.key),
                    if (entry.value != null)
                      Image.file(
                        File(entry.value!.path),
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    if (imageTimestamps[entry.key] != null)
                      Text("Captured at: ${imageTimestamps[entry.key]}"),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
