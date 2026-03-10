import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart'; // ✅ إضافة هذا الاستيراد

// ✅ ويدجت نص قابل للترجمة من لوحة التحكم
class TranslatableText extends StatelessWidget {
  final String textKey; // ✅ تغيير الاسم من key إلى textKey
  final String fallback; // نص احتياطي
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  const TranslatableText(
    this.textKey, {
    super.key, // ✅ هذا هو key الخاص بالـ Widget
    this.fallback = '',
    this.style,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<AdminProvider, LocaleProvider>(
      builder: (context, adminProvider, localeProvider, child) {
        final lang = localeProvider.locale.languageCode;
        String text = adminProvider.getContent(textKey, lang); // ✅ استخدام textKey
        
        // إذا كان النص فارغاً، استخدم النص الاحتياطي
        if (text.isEmpty || text == textKey) {
          text = fallback.isNotEmpty ? fallback : textKey;
        }
        
        return Text(
          text,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: maxLines != null ? TextOverflow.ellipsis : null,
        );
      },
    );
  }
}

// ✅ ويدجت مساعد للعناصر المتكررة (مثل بطاقات الخدمات)
class TranslatableCard extends StatelessWidget {
  final String titleKey;
  final String subtitleKey;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const TranslatableCard({
    super.key,
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(height: 16),
              TranslatableText(  // ✅ استخدام textKey
                titleKey,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              TranslatableText(  // ✅ استخدام textKey
                subtitleKey,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}