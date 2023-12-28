import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mytodaysdiary/DB/userProvider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'loginViews/login.dart';
Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Add other providers if needed
      ],
      child: const MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Loginpage()
    );
  }
}

