import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/admin_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/translatable_text.dart';
import '../widgets/admin_edit_button.dart';

class TestEditableScreen extends StatelessWidget {
  const TestEditableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final adminProvider = Provider.of<AdminProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final isAdmin = adminProvider.isAdmin;

    return Directionality(
      textDirection: localeProvider.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('صفحة تجريبية - تعديل النصوص'),
          backgroundColor: const Color(0xFF1A5632),
          actions: [
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: themeProvider.toggleTheme,
            ),
          ],
        ),
        body: Stack(
          children: [
            // المحتوى الرئيسي
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== القسم 1: العنوان الرئيسي =====
                  _buildEditableSection(
                    context: context,
                    title: 'القسم 1 - العنوان الرئيسي',
                    contentKey: 'home_hero_title',
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A5632), Color(0xFF2D6A4F)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TranslatableText(
                        'home_hero_title',
                        style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===== القسم 2: الوصف =====
                  _buildEditableSection(
                    context: context,
                    title: 'القسم 2 - الوصف',
                    contentKey: 'home_hero_description',
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                      ),
                      child: TranslatableText(
                        'home_hero_description',
                        style: GoogleFonts.tajawal(
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===== القسم 3: معلومات الاتصال =====
                  _buildEditableSection(
                    context: context,
                    title: 'القسم 3 - معلومات الاتصال',
                    contentKey: 'contact_address',
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              context,
                              icon: Icons.location_on,
                              labelKey: 'contact_address',
                              color: Colors.red,
                            ),
                            const Divider(),
                            _buildInfoRow(
                              context,
                              icon: Icons.phone,
                              labelKey: 'contact_phone',
                              color: Colors.blue,
                            ),
                            const Divider(),
                            _buildInfoRow(
                              context,
                              icon: Icons.email,
                              labelKey: 'contact_email',
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===== القسم 4: بطاقة الخدمة =====
                  _buildEditableSection(
                    context: context,
                    title: 'القسم 4 - بطاقة الخدمة',
                    contentKey: 'negative_certificate_title',
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A5632).withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A5632),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.description,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TranslatableText(
                                        'negative_certificate_title',
                                        style: GoogleFonts.tajawal(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'انقر على زر التعديل لتغيير هذا النص',
                                        style: GoogleFonts.tajawal(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildFieldRow(context, 'اللقب', 'negative_certificate_lastname'),
                                _buildFieldRow(context, 'الاسم', 'negative_certificate_firstname'),
                                _buildFieldRow(context, 'اسم الأب', 'negative_certificate_fathername'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===== القسم 5: زر الإرسال =====
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A5632),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: TranslatableText(
                        'negative_certificate_submit',
                        style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== إشعار وضع الإدارة =====
                  if (isAdmin)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.admin_panel_settings, color: Colors.green),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'أنت في وضع الإدارة. انقر على أزرار التعديل الخضراء لتغيير النصوص.',
                              style: GoogleFonts.tajawal(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // ===== أزرار التعديل =====
            if (isAdmin) ...[
              // زر تعديل العنوان
              const Positioned(
                top: 100,
                right: 30,
                child: AdminEditButton(
                  contentKey: 'home_hero_title',
                ),
              ),

              // زر تعديل الوصف
              const Positioned(
                top: 270,
                right: 30,
                child: AdminEditButton(
                  contentKey: 'home_hero_description',
                ),
              ),

              // زر تعديل العنوان
              const Positioned(
                top: 450,
                right: 30,
                child: AdminEditButton(
                  contentKey: 'negative_certificate_title',
                ),
              ),

              // زر تعديل اللقب
              const Positioned(
                top: 640,
                right: 30,
                child: AdminEditButton(
                  contentKey: 'negative_certificate_lastname',
                ),
              ),

              // زر تعديل الاسم
              const Positioned(
                top: 690,
                right: 30,
                child: AdminEditButton(
                  contentKey: 'negative_certificate_firstname',
                ),
              ),

              // زر تعديل اسم الأب
              const Positioned(
                top: 740,
                right: 30,
                child: AdminEditButton(
                  contentKey: 'negative_certificate_fathername',
                ),
              ),

              // زر تعديل نص زر الإرسال
              const Positioned(
                bottom: 200,
                right: 30,
                child: AdminEditButton(
                  contentKey: 'negative_certificate_submit',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لبناء قسم مع زر تعديل
  Widget _buildEditableSection({
    required BuildContext context,
    required String title,
    required String contentKey,
    required Widget child,
  }) {
    final isAdmin = Provider.of<AdminProvider>(context).isAdmin;
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: GoogleFonts.tajawal(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 8),
            if (isAdmin)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A5632).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'مفتاح: $contentKey',
                  style: GoogleFonts.tajawal(
                    fontSize: 10,
                    color: const Color(0xFF1A5632),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            child,
            if (isAdmin)
              Positioned(
                top: 8,
                right: Provider.of<LocaleProvider>(context).textDirection == TextDirection.rtl ? null : 8,
                left: Provider.of<LocaleProvider>(context).textDirection == TextDirection.rtl ? 8 : null,
                child: AdminEditButton(
                  contentKey: contentKey,
                  onEditComplete: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم التعديل بنجاح!'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, {
    required IconData icon,
    required String labelKey,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TranslatableText(
              labelKey,
              style: GoogleFonts.tajawal(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldRow(BuildContext context, String label, String key) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.tajawal(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TranslatableText(
                key,
                style: GoogleFonts.tajawal(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}