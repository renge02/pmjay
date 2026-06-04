import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:pmjay/repository/loginRepo/login.repo.dart';
import 'package:pmjay/repository/masterRepo/master.repo.dart';
import 'package:pmjay/repository/pinRepo/pin.service.dart';
import 'package:pmjay/repository/verifyOtpRepo/verify.otp.repo.dart';
import 'package:pmjay/view/screen/login/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
     ChangeNotifierProvider(create: (_) => LoginProvider()),
     ChangeNotifierProvider(create: (_) => VerifyOTPProvider()),
     ChangeNotifierProvider(create: (_) => MasterProvider()),
   ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PM-JAY',

      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, });


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPinFlow();
    });

  }
  Future<void> _checkPinFlow() async {
    final String? savedPIN = await PinService().getPin();

    if (savedPIN == null || savedPIN.isEmpty) {
      createPIN(context);
    } else {
      checkPINLock(context);
    }
  }
  void createPIN(BuildContext context) {
    screenLockCreate(
      context: context,
      title: const Text("Create PIN"),
      confirmTitle: const Text("Confirm PIN"),
      onConfirmed: (pin) async {
        await PinService().savePin(pin);

        Navigator.pop(context);

        checkPINLock(context);
      },
    );
  }

  Future<void> checkPINLock(BuildContext context) async {
    final String? savedPIN = await PinService().getPin();

    if (savedPIN == null || savedPIN.isEmpty) {
    createPIN(context);
    return;
    }
    screenLock(
      context: context,
      correctString: savedPIN,
      title: const Text("Enter PIN"),

      onUnlocked: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const PMJayLoginScreen(),
          ),
        );
      },
    );
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [

          ],
        ),
      ),
    );
  }
}
