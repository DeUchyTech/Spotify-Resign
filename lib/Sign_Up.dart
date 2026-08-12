import 'package:flutter/material.dart';
import 'Log_In.dart';
import 'Register.dart';

class SignUp extends StatefulWidget {
  final Future<void> Function(bool isDark) onThemeChanged;

  const SignUp({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,

      body: Stack(
        fit: StackFit.expand,
        children: [

          // BACKGROUND IMAGE
          Image.asset(
            'lib/assets/background.png',
            fit: BoxFit.cover,
          ),

          // DARK OVERLAY
          Container(
            color: Colors.black.withOpacity(0.50),
          ),

          // CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 16,
              ),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [

                  // TOP
                  Stack(
                    alignment: Alignment.center,
                    children: [

                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              isSelected = true;
                            });

                            await Future.delayed(
                              const Duration(
                                milliseconds: 150,
                              ),
                            );

                            if (mounted &&
                                Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          child: AnimatedContainer(
                            duration:
                            const Duration(
                              milliseconds: 150,
                            ),
                            width: 33,
                            height: 33,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? Colors.green
                                  : Colors.transparent,
                              border: Border.all(
                                color: Colors.white54,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Image.asset(
                        'lib/assets/spotify_logo.png',
                        width: 160,
                        height: 40,
                      ),
                    ],
                  ),

                  // SIGN UP BUTTONS
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [

                        // Sign Up
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                    Register(
                                      onThemeChanged: widget.onThemeChanged,
                                    ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.green,
                              foregroundColor:
                              Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Sign Up for Free',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Phone
                        _socialButton(
                          icon: Icons.phone_android,
                          iconColor: Colors.white,
                          text:
                          'Continue with phone number',
                          onPressed: () {},
                        ),
                        const SizedBox(height: 10),

                        // Google
                        _socialButton(
                          icon: Icons.g_mobiledata,
                          iconColor: Colors.red,
                          text:
                          'Continue with Google',
                          onPressed: () {},
                        ),
                        const SizedBox(height: 10),

                        // Facebook
                        _socialButton(
                          icon: Icons.facebook,
                          iconColor: Colors.blue,
                          text:
                          'Continue with Facebook',
                          onPressed: () {},
                        ),

                        const SizedBox(height: 8),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                  LogIn(
                                    onThemeChanged: widget.onThemeChanged,
                                  ),
                              ),
                            );
                          },
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight:
                              FontWeight.bold,
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
        ],
      ),
    );
  }

  // SOCIAL BUTTON

  Widget _socialButton({
    required IconData icon,
    required Color iconColor,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(
            color: Colors.white54,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          children: [

            SizedBox(
              width: 35,
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),

            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 35),
          ],
        ),
      ),
    );
  }
}
