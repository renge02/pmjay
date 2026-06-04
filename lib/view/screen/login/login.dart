import 'package:flutter/material.dart';
import 'package:pmjay/repository/loginRepo/login.repo.dart';
import 'package:pmjay/utils/extensions.dart';
import 'package:pmjay/utils/logger.dart';
import 'package:pmjay/view/screen/dashboard/dashboard.dart';
import 'package:provider/provider.dart';

import 'otp_verify.dart';

class PMJayLoginScreen extends StatefulWidget {
  const PMJayLoginScreen({super.key});

  @override
  State<PMJayLoginScreen> createState() => _PMJayLoginScreenState();
}

class _PMJayLoginScreenState extends State<PMJayLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController(text: "admin");

  final TextEditingController passwordController = TextEditingController(text:"PmJay@Admin1234!");

  bool obscurePassword = true;

  void signIn() {
    // API Call
    if (_formKey.currentState?.validate() ?? false) {
      //simulating api delay
      context.read<LoginProvider>().login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      body: Consumer<LoginProvider>(
        builder: (ctx, provider, _) {
          provider.isLoading ? context.showLoader() : context.hideLoader();

          if (provider.error != null) {
            logger("login error  ${provider.error}");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(provider.error!),
                  backgroundColor: Colors.red,
                ),
              );
            });
          }

          if (provider.data != null) {
            logger("login.....   ${provider.data['data']?["requiresOtp"]}");
            if(provider.data['data']?["requiresOtp"]==false){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.pushWidget(const DashboardScreen());
              });

            }else{
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.pushWidget(const OTPVerificationScreen());
              });
            }

          }
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// STEP INDICATOR
                    Row(
                      children: [
                        Container(
                          width: 26,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 12,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "STEP 1 OF 2 — CREDENTIALS",
                          style: TextStyle(
                            color: Colors.blueGrey.shade300,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    /// TITLE
                    const Text(
                      "Sign in to portal",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff17233C),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Use your authorised credentials issued by your district administrator.",
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.blueGrey.shade500,
                      ),
                    ),

                    const SizedBox(height: 28),

                    const SizedBox(height: 28),

                    /// USERNAME
                    const Text(
                      "Username",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xff344054),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: usernameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Username is required.";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter your username",
                        prefixIcon: const Icon(Icons.person_outline),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.red.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// PASSWORD TITLE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Password",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xff344054),
                          ),
                        ),
                        Text(
                          "Case-sensitive",
                          style: TextStyle(
                            color: Colors.blueGrey.shade300,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required.";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        prefixIcon: const Icon(Icons.key_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.red.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        onPressed: signIn,
                        icon: const Icon(Icons.login),
                        label: const Text(
                          "Continue to Sign In",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff138A3D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// INFO CARD
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xffF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xffD0D5DD)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Two-factor OTP verification is required after sign-in. All access attempts are logged and monitored by the NHA security team.",
                              style: TextStyle(
                                height: 1.6,
                                color: Colors.blueGrey.shade600,
                                fontSize: 15,
                              ),
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
    );
  }
}
