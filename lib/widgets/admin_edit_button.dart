import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../providers/locale_provider.dart';
import 'package:google_fonts/google_fonts.dart'; // ✅ أ
import '../providers/theme_provider.dart'; // ✅ أضف هذا السطرضف هذا السطر
class AdminEditButton extends StatelessWidget {
  final String contentKey;
  final VoidCallback? onEditComplete;

  const AdminEditButton({
    super.key,
    required this.contentKey,
    this.onEditComplete,
  });

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    
    if (!adminProvider.isAdmin) {
      return const SizedBox();
    }

    return Positioned(
      top: 0,
      right: localeProvider.textDirection == TextDirection.rtl ? null : 0,
      left: localeProvider.textDirection == TextDirection.rtl ? 0 : null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showEditDialog(context, adminProvider, localeProvider),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A5632),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'تعديل',
                  style: GoogleFonts.tajawal(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, AdminProvider adminProvider, LocaleProvider localeProvider) {
    final TextEditingController controller = TextEditingController(
      text: adminProvider.getContent(contentKey, localeProvider.locale.languageCode),
    );
    String selectedLang = localeProvider.locale.languageCode;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(
            'تعديل النص',
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اختيار اللغة
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedLang,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'ar', child: Text('العربية')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'fr', child: Text('Français')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedLang = value!;
                        controller.text = adminProvider.getContent(contentKey, selectedLang);
                      });
                    },
                  ),
                ),
                
                // حقل التعديل
                TextFormField(
                  controller: controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'أدخل النص الجديد',
                  ),
                  style: GoogleFonts.tajawal(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('إلغاء', style: GoogleFonts.tajawal()),
            ),
            ElevatedButton(
              onPressed: () {
                adminProvider.updateContent(contentKey, selectedLang, controller.text);
                Navigator.pop(ctx);
                if (onEditComplete != null) {
                  onEditComplete!();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A5632),
              ),
              child: Text('حفظ', style: GoogleFonts.tajawal(color: Colors.white)),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}