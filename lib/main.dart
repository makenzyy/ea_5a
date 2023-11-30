import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String barcode = 'Tap to scan QR Code';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Change this color to your desired color
              ),
              child: const Text('Scan QR Code'),
              onPressed: () async {
                String scannedValue = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AiBarcodeScanner(
                      validator: (value) {
                        return value.startsWith('https://');
                      },
                      canPop: false,
                      onScan: (String value) {
                        debugPrint(value);
                        Navigator.pop(context, value); // Pass the scanned value back
                      },
                      onDetect: (p0) {},
                      onDispose: () {
                        debugPrint("Barcode scanner disposed!");
                      },
                      controller: MobileScannerController(
                        detectionSpeed: DetectionSpeed.noDuplicates,
                      ),
                    ),
                  ),
                );

                // Handle the scanned value
                if (scannedValue != null) {
                  setState(() {
                    barcode = scannedValue;
                  });
                }
              },
            ),
            GestureDetector(
              onTap: () {
                // Launch the URL when the user taps on the barcode
                launchURL(barcode);
              },
              child: Text(
                barcode,
                style: TextStyle(
                  color: Colors.blue, // You can customize the text color
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to launch the URL
  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}