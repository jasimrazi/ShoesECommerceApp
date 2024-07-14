import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shoesapp/admin/admin.dart';
import 'package:shoesapp/screens/auth/auth_state.dart';
import 'package:shoesapp/screens/auth/sign_in.dart';
import 'package:shoesapp/screens/favourite.dart';
import 'package:shoesapp/screens/home.dart';
import 'package:shoesapp/service/connectivity.dart';
import 'package:shoesapp/splashscreens/landingpage.dart';
import 'package:shoesapp/splashscreens/onboard1.dart';
import 'package:shoesapp/utils/theme.dart';
import 'firebase_options.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final connectivityService =
      ConnectivityService(onConnectionChange: (hasConnection) {
    if (!hasConnection) {
      showNoConnectionDialog();
    }
  });

  runApp(MyApp(connectivityService: connectivityService));

  // Set a global error handler
  ErrorWidget.builder = (FlutterErrorDetails details) {
    bool inDebug = false;
    assert(() {
      inDebug = true;
      return true;
    }());
    if (inDebug) {
      return ErrorWidget(details.exception);
    } else {
      return Center(child: Text('Error occurred!'));
    }
  };
}

class MyApp extends StatelessWidget {
  final ConnectivityService connectivityService;

  const MyApp({super.key, required this.connectivityService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      navigatorKey: navigatorKey, // Set the navigator key
      home: AuthState(),
    );
  }
}

void showNoConnectionDialog() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return AlertDialog(
          
          title: const Text('No Internet Connection'),
          content: const Text(
              'Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry', style: TextStyle(color: kPrimary),),
              onPressed: () async {
                final connectivityService = ConnectivityService();
                if (await connectivityService.checkConnection()) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
