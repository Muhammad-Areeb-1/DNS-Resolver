import 'package:demo_application/UI/Screens/ip_resolve_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:demo_application/firebase_options.dart';

import 'UI/Screens/dns_resolve_screen.dart';
import 'UI/Screens/welcome_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DNS Database",
      initialRoute: '/welcome_screen', // Set the initial route
      routes: {
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/dns_resolve': (context) => const DNSResolveScreen(),
        '/ip_resolve': (context) => const IPResolveScreen(),
      },
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const WelcomeScreen(),
    );
  }
}