// lib/screens/user_requests_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/request_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class UserRequestsScreen extends StatefulWidget {
  final int userId;
  final String userName;

  const UserRequestsScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<UserRequestsScreen> createState() => _UserRequestsScreenState();
}

class _UserRequestsScreenState extends State<UserRequestsScreen> {
  @override
  void initState() {
    super.initState();
    print('🟢 فتح صفحة طلبات المستخدم: ${widget.userName} (ID: ${widget.userId})');
    
    // ✅ نستعمل addPostFrameCallback باش نضمن أن الـ Context جاهز
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRequests();
    });
  }

  Future<void> _loadRequests() async {
    print('🔄 بدء تحميل الطلبات...');
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    // ✅ نمرر الـ Context هنا
    await requestProvider.fetchUserRequests(widget.userId, context);
    print('🔄 انتهى تحميل الطلبات');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final requestProvider = Provider.of<RequestProvider>(context);
    final isDark = theme.isDarkMode;
    final currentLocale = localeProvider.locale.languageCode;

    print('🎨 بناء صفحة الطلبات');
    print('   📊 حالة التحميل: ${requestProvider.isLoading}');
    print('   📦 عدد الطلبات: ${requestProvider.requests.length}');
    print('   ❌ خطأ: ${requestProvider.error}');

    return Directionality(
      textDirection: localeProvider.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            currentLocale == 'ar' ? 'طلبات ${widget.userName}' :
            currentLocale == 'en' ? '${widget.userName}\'s Requests' :
            'Demandes de ${widget.userName}',
            style: GoogleFonts.tajawal(),
          ),
          backgroundColor: const Color(0xFF1A5632),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadRequests,
              tooltip: currentLocale == 'ar' ? 'تحديث' : 'Refresh',
            ),
          ],
        ),
        body: requestProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : requestProvider.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          currentLocale == 'ar' ? 'حدث خطأ' :
                          currentLocale == 'en' ? 'Error' : 'Erreur',
                          style: GoogleFonts.tajawal(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            requestProvider.error!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tajawal(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadRequests,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A5632),
                          ),
                          child: Text(
                            currentLocale == 'ar' ? 'إعادة المحاولة' :
                            currentLocale == 'en' ? 'Retry' : 'Réessayer',
                            style: GoogleFonts.tajawal(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                : requestProvider.requests.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_rounded,
                              size: 80,
                              color: isDark ? Colors.grey[600] : Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              currentLocale == 'ar' ? 'لا توجد طلبات لهذا المستخدم' :
                              currentLocale == 'en' ? 'No requests for this user' :
                              'Aucune demande pour cet utilisateur',
                              style: GoogleFonts.tajawal(
                                fontSize: 16,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadRequests,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A5632),
                              ),
                              child: Text(
                                currentLocale == 'ar' ? 'تحديث' :
                                currentLocale == 'en' ? 'Refresh' : 'Actualiser',
                                style: GoogleFonts.tajawal(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: requestProvider.requests.length,
                        itemBuilder: (context, index) {
                          final request = requestProvider.requests[index];
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: request.statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  request.typeIcon,
                                  color: request.statusColor,
                                ),
                              ),
                              title: Text(
                                request.getLocalizedType(currentLocale),
                                style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    currentLocale == 'ar' 
                                        ? 'تاريخ الطلب: ${request.createdAt.day}/${request.createdAt.month}/${request.createdAt.year}'
                                        : currentLocale == 'en'
                                            ? 'Request date: ${request.createdAt.year}-${request.createdAt.month.toString().padLeft(2, '0')}-${request.createdAt.day.toString().padLeft(2, '0')}'
                                            : 'Date de demande: ${request.createdAt.day}/${request.createdAt.month}/${request.createdAt.year}',
                                    style: GoogleFonts.tajawal(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: request.statusColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  request.getLocalizedStatus(currentLocale),
                                  style: GoogleFonts.tajawal(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}