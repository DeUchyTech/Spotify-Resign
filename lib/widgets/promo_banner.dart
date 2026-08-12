import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoBanner extends StatelessWidget {
  final VoidCallback onTap;

  const PromoBanner({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 120,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Yellow background
            Positioned(
              left: 0,
              right: 0,
              top: 10,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE5C900),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            // Left arrow
            Positioned(
              left: 10,
              top: 52,
              child: Icon(
                Icons.chevron_left,
                color: Colors.white.withOpacity(0.65),
                size: 26,
              ),
            ),

            // Text
            Positioned(
              left: 45,
              top: 26,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Popular',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Sisa Rasa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2),

                  const Text(
                    'Mahalini',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Sisa Rasa image
            Positioned(
              right: 20,
              top: -25,
              bottom: -2,
              child: Image.asset(
                'lib/assets/sisa_rasa.png',
                width: 144,
                height: 152,
                fit: BoxFit.contain,
              ),
            ),

            // Right arrow
            Positioned(
              right: 8,
              top: 52,
              child: Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.65),
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}