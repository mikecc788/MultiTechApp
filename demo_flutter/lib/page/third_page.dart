import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  static const platform = MethodChannel('com.yourcompany.flutter/native');

  @override
  void initState() {
    super.initState();
    _setNativeTitle();
  }

  Future<void> _setNativeTitle() async {
    try {
      await platform.invokeMethod('setTitle', {'title': 'Third Page'});
    } on PlatformException catch (e) {
      print("Failed to set title: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.orange,
                child: Icon(
                  Icons.star,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'You\'ve reached the Third Page!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Return Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
