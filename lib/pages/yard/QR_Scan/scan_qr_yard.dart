import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRYard extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const ScanQRYard({
    Key? key,
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.black,
  }) : super(key: key);

  @override
  State<ScanQRYard> createState() => _ScanQRYardState();
}

class _ScanQRYardState extends State<ScanQRYard> {
  late MobileScannerController cameraController;
  bool isScanning = true;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: widget.primaryColor,
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                return Icon(
                  state == TorchState.off ? Icons.flash_off : Icons.flash_on,
                  color: Colors.white,
                );
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                return Icon(
                  state == CameraFacing.front
                      ? Icons.camera_front
                      : Icons.camera_rear,
                  color: Colors.white,
                );
              },
            ),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  controller: cameraController,
                  onDetect: _onDetect,
                  errorBuilder: (context, error, child) {
                    return ScannerErrorWidget(error: error);
                  },
                ),
                CustomPaint(
                  painter: ScannerOverlay(widget.secondaryColor),
                  child: const SizedBox.expand(),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: widget.secondaryColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner, size: 24, color: widget.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Position QR code within the frame',
                  style: TextStyle(fontSize: 16, color: widget.primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    if (!isScanning) return;
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() => isScanning = false);
        _handleScannedCode(barcode.rawValue!);
        break;
      }
    }
  }

  void _handleScannedCode(String code) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code Scanned'),
          content: Text('Scanned content: $code'),
          actions: [
            TextButton(
              child: const Text('Continue Scanning'),
              onPressed: () {
                setState(() => isScanning = true);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, code); // Return scanned code to previous screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

class ScannerErrorWidget extends StatelessWidget {
  final MobileScannerException error;

  const ScannerErrorWidget({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'Error: ${error.errorCode}',
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          Text(error.errorDetails?.message ?? 'Unknown error'),
        ],
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  final Color overlayColor;

  ScannerOverlay(this.overlayColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = overlayColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final scanArea = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.8,
      height: size.width * 0.8,
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(RRect.fromRectAndRadius(scanArea, const Radius.circular(16)))
          ..close(),
      ),
      paint,
    );

    final borderPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanArea, const Radius.circular(16)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}