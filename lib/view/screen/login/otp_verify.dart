import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:pmjay/repository/verifyOtpRepo/verify.otp.repo.dart';
import 'package:pmjay/utils/secure.storage.dart';
import 'package:provider/provider.dart';

import '../../../utils/extensions.dart';
import '../dashboard/dashboard.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() =>
      _OTPVerificationScreenState();
}

class _OTPVerificationScreenState
    extends State<OTPVerificationScreen> {
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int remainingSeconds = 120; // 04:35
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (remainingSeconds > 0) {
          setState(() {
            remainingSeconds--;
          });
        } else {
          timer.cancel();
        }
      },
    );
  }

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }


  Future<void> verifyOTP() async {
    // API Call
    if (_formKey.currentState?.validate() ?? false) {
      //simulating api delay
      String?  preAuthToken=await SecureStorage().getToken();
      context.read<VerifyOTPProvider>().verifyOTP(
        preAuthToken.toString(),
        otpController.text.trim(),
      );
    }
  }
  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xff0F6A3A);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      body: Consumer<VerifyOTPProvider>(
        builder: (ctx, provider, _) {

          provider.isLoading
              ? context.showLoader()
              : context.hideLoader();

          if (provider.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pushReplacementWidget(
                const DashboardScreen(),
              );
            });
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    /// STEP INDICATOR
                    Row(
                      children: [
                        Container(
                          width: 26,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 26,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "STEP 2 OF 2 — OTP VERIFICATION",
                          style: TextStyle(
                            color:
                            Colors.blueGrey.shade300,
                            fontSize: 12,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// TITLE
                    const Text(
                      "Verify OTP",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff17233C),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Enter the OTP sent to your registered mobile number.",
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color:
                        Colors.blueGrey.shade500,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// TIMER CARD
                    Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(14),
                        border: Border.all(
                          color:
                          const Color(0xffD0D5DD),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "OTP expires in",
                            style: TextStyle(
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formattedTime,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// OTP LABEL
                    const Text(
                      "Enter OTP",
                      style: TextStyle(
                        fontWeight:
                        FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xff344054),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// OTP PIN INPUT
                    Center(
                      child: Pinput(
                        controller: otpController,
                        length: 6,
                        validator: (value) {
                          if (value == null ||
                              value.length != 6) {
                            return "Enter valid OTP";
                          }
                          return null;
                        },
                        defaultPinTheme: PinTheme(
                          width: 52,
                          height: 58,
                          textStyle:
                          const TextStyle(
                            fontSize: 20,
                            fontWeight:
                            FontWeight.bold,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(
                                12),
                            border: Border.all(
                              color: Colors.red
                                  .shade300,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    /// VERIFY BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        onPressed: verifyOTP,
                        icon: const Icon(
                          Icons.check_circle,
                        ),
                        label: const Text(
                          "Verify OTP",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(
                              0xff138A3D),
                          foregroundColor:
                          Colors.white,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// RESEND OTP
                    Center(
                      child: TextButton(
                        onPressed:
                        remainingSeconds == 0
                            ? () {
                          // resend otp api
                        }
                            : null,
                        child: Text(
                          remainingSeconds == 0
                              ? "Resend OTP"
                              : "Resend OTP in $formattedTime",
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BACK BUTTON
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.pop(
                              context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                        label: const Text(
                          "Back to Sign In",
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// INFO CARD
                    Container(
                      padding:
                      const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color:
                        const Color(0xffF8FAFC),
                        borderRadius:
                        BorderRadius.circular(
                            12),
                        border: Border.all(
                          color: const Color(
                              0xffD0D5DD),
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.security,
                            color: Colors.green,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "For your security, the OTP is valid for 2 minutes. Do not share it with anyone.",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );  }
}