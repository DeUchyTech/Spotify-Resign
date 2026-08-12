import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Log_In.dart';

class Register extends StatefulWidget {
  final Future<void> Function(bool isDark)? onThemeChanged;

  const Register({
    super.key,
    this.onThemeChanged,
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isSelected = false;
  bool _isPasswordVisible = false;

  Color get _textColor =>
      Theme.of(context).colorScheme.onSurface;

  Color get _mutedColor =>
      _textColor.withOpacity(.58);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // Register a new user
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'fullname',
      _nameController.text.trim(),
    );

    await prefs.setString(
      'email',
      _emailController.text.trim(),
    );

    await prefs.setString(
      'password',
      _passwordController.text,
    );

    await prefs.setBool(
      'setupCompleted',
      true,
    );

    await prefs.setBool(
      'isLoggedIn',
      false,
    );

    if (!mounted) return;

    // Navigate to the login page after registration.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LogIn(
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
              // Top section with back button and Spotify logo.
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

              // Scrollable registration content.
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Register title.
                      Text(
                        'Register',
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

                      // Registration form.
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              // Full name field.
                              TextFormField(
                                controller: _nameController,
                                style: TextStyle(
                                  color: _textColor,
                                ),
                                decoration: _inputDecoration(
                                  'Full Name',
                                  Icons.person_outline,
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'Please enter your full name';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

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
                                  suffix:
                                  _visibilityButton(),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Confirm password field.
                              TextFormField(
                                controller:
                                _confirmController,
                                obscureText:
                                !_isPasswordVisible,
                                style: TextStyle(
                                  color: _textColor,
                                ),
                                decoration: _inputDecoration(
                                  'Confirm Password',
                                  Icons.lock_outline,
                                  suffix:
                                  _visibilityButton(),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'Please confirm password';
                                  }

                                  if (value !=
                                      _passwordController.text) {
                                    return 'Passwords do not match';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 25),

                              // Register button.
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _register,
                                  style:
                                  ElevatedButton.styleFrom(
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
                                    'Register',
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

                              // Login link.
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already Have an Account? ',
                                    style: TextStyle(
                                      color: _mutedColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => LogIn(
                                            onThemeChanged:
                                            widget
                                                .onThemeChanged,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Log In',
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

  // Password visibility button.
  Widget _visibilityButton() {
    return IconButton(
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