import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_fixed/provider/user_provider.dart';
import 'package:instagram_clone_fixed/route%20handling/auth_page.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> UserProvider(),)
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram clone',
          // theme: ThemeData.dark()
          //     .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
          home: AuthPage(),
              ),
    );
  }
}
