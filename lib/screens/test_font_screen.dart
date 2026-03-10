import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestFontScreen extends StatelessWidget {
  const TestFontScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختبار الخطوط'),
        backgroundColor: const Color(0xFF1A5632),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // استخدام Noto Sans Arabic
            Text(
              'نص تجريبي - Noto Sans Arabic',
              style: TextStyle(
                fontFamily: 'NotoSansArabic',
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            
            // نص عريض
            Text(
              'نص عريض - Bold',
              style: TextStyle(
                fontFamily: 'NotoSansArabic',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            
            // استخدام Google Fonts (بديل)
            Text(
              'نص باستخدام Google Fonts',
              style: GoogleFonts.notoSansArabic(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // اختبار الإيموجي
            Text(
              'اختبار الإيموجي: 📞 📱 ✉️ 🎉',
              style: GoogleFonts.notoSansArabic(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}