import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'page/first_page.dart';
import 'page/second_page.dart';
import 'page/third_page.dart';
import 'page/fourth_page.dart';

void main() => runApp(const MyApp());

/// 应用程序的根Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/first': (context) => const FirstPage(),
        '/second': (context) => const SecondPage(),
        '/third': (context) => const ThirdPage(),
        '/fourth': (context) => const FourthPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const platform = MethodChannel('com.yourcompany.flutter/native');

  Future<void> _returnToNative() async {
    try {
      await platform.invokeMethod('returnToNative');
    } on PlatformException catch (e) {
      print("Failed to return to native: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _returnToNative,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/first'),
              child: const Text('First Page'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/second'),
              child: const Text('Second Page'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/third'),
              child: const Text('Third Page'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/fourth'),
              child: const Text('Fourth Page'),
            ),
          ],
        ),
      ),
    );
  }
}
