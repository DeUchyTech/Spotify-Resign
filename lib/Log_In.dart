import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home_Page.dart';
import 'Register.dart';

class LogIn extends StatefulWidget {
  final Future<void> Function(bool isDark)? onThemeChanged;

  const LogIn({
    super.key,
    this.onThemeChanged,
  });

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSelected = false;
  bool _isPasswordVisible = false;

  Color get _textColor =>
      Theme.of(context).colorScheme.onSurface;

  Color get _mutedColor =>
      _textColor.withOpacity(.58);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login function
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final valid =
        _emailController.text.trim() ==
            prefs.getString('email') &&
            _passwordController.text ==
                prefs.getString('password');

    if (!mounted) return;

    // Show error if the login details are incorrect.
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Incorrect email or password',
          ),
        ),
      );

      return;
    }

    // Save login state.
    await prefs.setBool(
      'isLoggedIn',
      true,
    );

    if (!mounted) return;

    // Navigate to the home page.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageColor =
    Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Theme.of(context).scaffoldBackgroundColor;

    return ColoredBox(
      color: pageColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 16,
        ),
        child: Scaffold(
          backgroundColor: pageColor,
          body: Column(
            children: [
              // Top section containing the back button and logo.
              Stack(
                alignment: Alignment.center,
                children: [
                  // Back button.
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          _isSelected = true;
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
                        duration: const Duration(
                          milliseconds: 150,
                        ),
                        width: 33,
                        height: 33,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isSelected
                              ? Theme.of(context)
                              .colorScheme
                              .primary
                              : Colors.transparent,
                          border: Border.all(
                            color: _mutedColor,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: _isSelected
                              ? Theme.of(context)
                              .colorScheme
                              .onPrimary
                              : _mutedColor,
                        ),
                      ),
                    ),
                  ),

                  // Spotify logo.
                  Image.asset(
                    'lib/assets/spotify_logo.png',
                    width: 160,
                    height: 60,
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // Scrollable login content.
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Login title.
                      Text(
                        'Log In',
                        style: TextStyle(
                          color: _mutedColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Support message.
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text(
                            'If You Need Any Support, ',
                            style: TextStyle(
                              color: _mutedColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Click Here',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 35),

                      // Login form.
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              // Email field.
                              TextFormField(
                                controller: _emailController,
                                keyboardType:
                                TextInputType.emailAddress,
                                style: TextStyle(
                                  color: _textColor,
                                ),
                                decoration: _inputDecoration(
                                  'Email',
                                  Icons.email_outlined,
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'Please enter your email';
                                  }

                                  return value.contains('@')
                                      ? null
                                      : 'Please enter a valid email';
                                },
                              ),

                              const SizedBox(height: 20),

                              // Password field.
                              TextFormField(
                                controller:
                                _passwordController,
                                obscureText:
                                !_isPasswordVisible,
                                style: TextStyle(
                                  color: _textColor,
                                ),
                                decoration: _inputDecoration(
                                  'Password',
                                  Icons.lock_outline,
                                  suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                        !_isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: _mutedColor,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }

                                  return null;
                                },
                              ),

                              // Forgot password button.
                              Align(
                                alignment:
                                Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: _mutedColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // Login button.
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Colors.green,
                                    foregroundColor:
                                    Colors.white,
                                    minimumSize:
                                    const Size(
                                      double.infinity,
                                      50,
                                    ),
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                        30,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 35),

                              // Divider.
                              _divider(),

                              const SizedBox(height: 35),

                              // Social login buttons.
                              _socialButtons(),

                              const SizedBox(height: 20),

                              // Register link.
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      color: _mutedColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              Register(
                                                onThemeChanged:
                                                widget
                                                    .onThemeChanged,
                                              ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 14,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Text field decoration.
  InputDecoration _inputDecoration(
      String label,
      IconData icon, {
        Widget? suffix,
      }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: _mutedColor,
      ),
      prefixIcon: Icon(
        icon,
        color: _mutedColor,
      ),
      suffixIcon: suffix,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: _mutedColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.green,
          width: 2,
        ),
      ),
    );
  }

  // Divider containing "Or".
  Widget _divider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: _mutedColor,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            'Or',
            style: TextStyle(
              color: _mutedColor,
              fontSize: 12,
            ),
          ),
        ),

        Expanded(
          child: Container(
            height: 1,
            color: _mutedColor,
          ),
        ),
      ],
    );
  }

  // Social login buttons.
  Widget _socialButtons() {
    final socialButtons = [
      {
        'image': 'lib/assets/facebook.png',
        'label': 'Facebook',
      },
      {
        'image': 'lib/assets/google.png',
        'label': 'Google',
      },
      {
        'image': 'lib/assets/apple.jpg',
        'label': 'Apple',
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: socialButtons.map((social) {
        return SizedBox(
          width: 70,
          height: 40,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              side: BorderSide(
                color: _mutedColor,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Image.asset(
              social['image']!,
              width: 25,
              height: 25,
              fit: BoxFit.contain,
            ),
          ),
        );
      }).toList(),
    );
  }
}