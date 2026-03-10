import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key});

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen>
    with SingleTickerProviderStateMixin {
  static const Color primary = Color(0xFF1A5632);
  static const Color primaryDark = Color(0xFF0D3D20);
  static const Color secondary = Color(0xFFC49B63);
  static const Color bgLight = Color(0xFFF8F6F1);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textLight = Color(0xFF6B6B6B);
  static const Color danger = Color(0xFFE74C3C);
  static const Color success = Color(0xFF27AE60);
  static const Color darkBg = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color darkText = Color(0xFFE8E8E8);

  late AnimationController _particleController;
  final List<_Particle> _particles = List.generate(20, (i) => _Particle(i));

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showSuccess = false;
  String? _errorMessage;

  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bookingDateController = TextEditingController();
  final _notesController = TextEditingController();

  String? _serviceType;

  final List<Map<String, String>> _serviceTypes = [
    {'value': 'شهادة سلبية', 'label': '📄 شهادة سلبية'},
    {'value': 'تصحيح معلومات', 'label': '✏️ تصحيح معلومات'},
    {'value': 'استفسار إداري', 'label': '❓ استفسار إداري'},
    {'value': 'طلب إثبات ملكية', 'label': '📋 طلب إثبات ملكية'},
    {'value': 'معاملة عاجلة', 'label': '⚡ معاملة عاجلة'},
  ];

  final Map<String, Map<String, String>> translations = {
    'bookingTitle': {'ar': 'حجز موعد', 'en': 'Book Appointment', 'fr': 'Prendre Rendez-vous'},
    'bookingSubtitle': {'ar': 'المحافظة العقارية – أولاد جلال', 'en': 'Real Estate Conservation – Ouled Djellal', 'fr': 'Conservation Foncière – Ouled Djellal'},
    'firstName': {'ar': 'الاسم', 'en': 'First Name', 'fr': 'Prénom'},
    'lastName': {'ar': 'اللقب', 'en': 'Last Name', 'fr': 'Nom'},
    'email': {'ar': 'البريد الإلكتروني', 'en': 'Email', 'fr': 'Email'},
    'phone': {'ar': 'رقم الهاتف', 'en': 'Phone Number', 'fr': 'Téléphone'},
    'appointmentDate': {'ar': 'تاريخ الموعد', 'en': 'Appointment Date', 'fr': 'Date du Rendez-vous'},
    'serviceType': {'ar': 'نوع الخدمة', 'en': 'Service Type', 'fr': 'Type de Service'},
    'notes': {'ar': 'ملاحظات إضافية', 'en': 'Additional Notes', 'fr': 'Notes Supplémentaires'},
    'confirmBooking': {'ar': 'تأكيد الحجز', 'en': 'Confirm Booking', 'fr': 'Confirmer le Rendez-vous'},
    'bookingSuccess': {'ar': 'تم الحجز بنجاح!', 'en': 'Booking Successful!', 'fr': 'Rendez-vous Confirmé!'},
    'bookingDetails': {'ar': 'تم تسجيل موعدك بنجاح.\nسيتم إرسال تفاصيل الموعد إلى بريدك الإلكتروني.', 'en': 'Your appointment has been registered successfully.\nDetails will be sent to your email.', 'fr': 'Votre rendez-vous a été enregistré avec succès.\nLes détails seront envoyés à votre email.'},
    'bookingWarning': {'ar': '⚠️ يرجى الالتزام بالموعد والحضور قبل 10 دقائق.', 'en': '⚠️ Please be on time and arrive 10 minutes early.', 'fr': '⚠️ Veuillez être à l\'heure et arriver 10 minutes en avance.'},
    'backHome': {'ar': 'العودة للرئيسية', 'en': 'Back to Home', 'fr': 'Retour à l\'Accueil'},
    'importantInfo': {'ar': 'معلومات هامة', 'en': 'Important Information', 'fr': 'Informations Importantes'},
    'receptionDays': {'ar': 'أيام الاستقبال', 'en': 'Reception Days', 'fr': 'Jours de Réception'},
    'receptionDaysDetail': {'ar': 'الاثنين والأربعاء فقط', 'en': 'Monday and Wednesday only', 'fr': 'Lundi et mercredi uniquement'},
    'receptionHours': {'ar': 'من 08:00 إلى 12:00 ظهراً', 'en': 'From 08:00 AM to 12:00 PM', 'fr': 'De 08h00 à 12h00'},
    'bookingRequired': {'ar': 'الحجز إلزامي', 'en': 'Booking is mandatory', 'fr': 'Le rendez-vous est obligatoire'},
    'bookingRequiredDetail': {'ar': 'لا يُستقبل أي مراجع دون موعد مسبق', 'en': 'No reception without prior appointment', 'fr': 'Pas de réception sans rendez-vous préalable'},
    'contactInfo': {'ar': 'للاستفسار', 'en': 'For inquiries', 'fr': 'Pour renseignements'},
    'address': {'ar': 'العنوان', 'en': 'Address', 'fr': 'Adresse'},
    'addressDetail': {'ar': 'المحافظة العقارية، أولاد جلال، الجزائر', 'en': 'Real Estate Conservation, Ouled Djellal, Algeria', 'fr': 'Conservation Foncière, Ouled Djellal, Algérie'},
    'thisFieldRequired': {'ar': 'هذا الحقل مطلوب', 'en': 'This field is required', 'fr': 'Ce champ est requis'},
    'invalidEmail': {'ar': 'بريد إلكتروني غير صالح', 'en': 'Invalid email address', 'fr': 'Adresse email invalide'},
    'invalidDay': {'ar': 'عذراً! الحجز متاح فقط يومي الاثنين والأربعاء.', 'en': 'Sorry! Booking is only available on Monday and Wednesday.', 'fr': 'Désolé! Les rendez-vous sont uniquement disponibles le lundi et le mercredi.'},
    'ok': {'ar': 'حسناً', 'en': 'OK', 'fr': 'D\'accord'},
    'connectionError': {'ar': 'حدث خطأ في الاتصال، يرجى التحقق من الإنترنت', 'en': 'Connection error, please check your internet', 'fr': 'Erreur de connexion, veuillez vérifier votre internet'},
    'selectService': {'ar': '-- اختر --', 'en': '-- Select --', 'fr': '-- Choisir --'},
    'enterFirstName': {'ar': 'أدخل اسمك', 'en': 'Enter your first name', 'fr': 'Entrez votre prénom'},
    'enterLastName': {'ar': 'أدخل لقبك', 'en': 'Enter your last name', 'fr': 'Entrez votre nom'},
    'enterEmail': {'ar': 'example@email.com', 'en': 'example@email.com', 'fr': 'example@email.com'},
    'enterPhone': {'ar': '05XXXXXXXX', 'en': '05XXXXXXXX', 'fr': '05XXXXXXXX'},
    'enterNotes': {'ar': 'أضف أي تفاصيل إضافية...', 'en': 'Add any additional details...', 'fr': 'Ajoutez des détails supplémentaires...'},
    'optional': {'ar': 'اختياري', 'en': 'Optional', 'fr': 'Optionnel'},
    'footerNote': {'ar': 'جميع الحقوق محفوظة © 2025 المحافظة العقارية – أولاد جلال', 'en': 'All rights reserved © 2025 Real Estate Conservation – Ouled Djellal', 'fr': 'Tous droits réservés © 2025 Conservation Foncière – Ouled Djellal'},
  };

  String t(String key) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;
    return translations[key]?[locale] ?? translations[key]?['ar'] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bookingDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  bool _isValidDay(DateTime date) {
    return date.weekday == DateTime.monday || date.weekday == DateTime.wednesday;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final last = now.add(const Duration(days: 60));
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: last,
      locale: Locale(Provider.of<LocaleProvider>(context, listen: false).locale.languageCode),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: primary, onPrimary: Colors.white)),
        child: child!,
      ),
    );

    if (picked != null) {
      if (!_isValidDay(picked)) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('⚠️', style: TextStyle(fontSize: 40), textAlign: TextAlign.center),
              content: Text(t('invalidDay'), style: GoogleFonts.tajawal(fontSize: 16), textAlign: TextAlign.center),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(t('ok'), style: GoogleFonts.tajawal(color: primary)),
                ),
              ],
            ),
          );
        }
        return;
      }
      setState(() {
        _bookingDateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🔒', textAlign: TextAlign.center, style: TextStyle(fontSize: 40)),
        content: Text(
          'يجب تسجيل الدخول أولاً لحجز موعد',
          style: GoogleFonts.tajawal(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('إلغاء', style: GoogleFonts.tajawal(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: primary),
            child: Text('تسجيل الدخول', style: GoogleFonts.tajawal(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    Map<String, dynamic> data = {
      'firstname': _firstnameController.text.trim(),
      'lastname': _lastnameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'booking_date': _bookingDateController.text,
      'service_type': _serviceType,
    };

    if (_notesController.text.isNotEmpty) {
      data['notes'] = _notesController.text.trim();
    }

    try {
      final result = await ApiService.submitAppointment(data);

      setState(() => _isLoading = false);

      if (result['code'] == 401 ||
          result['status'] == 401 ||
          result['message']?.toString().contains('Unauthenticated') == true ||
          result['message']?.toString().contains('unauthenticated') == true) {
        _showLoginRequiredDialog();
        return;
      }

      if (result['success'] == true) {
        setState(() => _showSuccess = true);

        _formKey.currentState!.reset();
        _firstnameController.clear();
        _lastnameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _bookingDateController.clear();
        _notesController.clear();
        setState(() => _serviceType = null);
      } else {
        setState(() {
          _errorMessage = result['message'] ?? t('connectionError');
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (e.toString().contains('401') ||
          e.toString().contains('Unauthenticated') ||
          e.toString().contains('unauthenticated')) {
        _showLoginRequiredDialog();
      } else {
        setState(() {
          _errorMessage = t('connectionError');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;

    return Directionality(
      textDirection: locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: isDark ? darkBg : primaryDark,
        body: Stack(
          children: [
            _buildParticles(),
            SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          _buildBackButton(isDark, locale),
                          const SizedBox(height: 20),
                          _buildHeader(),
                          const SizedBox(height: 30),
                          _buildTwoColumnLayout(isDark),
                          const SizedBox(height: 30),
                          _buildFooter(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(bool isDark, String locale) {
    return Align(
      alignment: locale == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: _goBack,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? darkCard : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Center(
            child: Icon(
              locale == 'ar' ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (_, __) => CustomPaint(
        size: Size.infinite,
        painter: _ParticlePainter(_particles, _particleController.value),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          '📅 ${t('bookingTitle')}',
          style: GoogleFonts.amiri(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.white.withOpacity(0.3), blurRadius: 20)],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          t('bookingSubtitle'),
          style: GoogleFonts.tajawal(
            color: Colors.white.withOpacity(0.95),
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTwoColumnLayout(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildInfoCard(isDark)),
              const SizedBox(width: 20),
              Expanded(child: _buildBookingCard(isDark)),
            ],
          );
        } else {
          return Column(
            children: [
              _buildInfoCard(isDark),
              const SizedBox(height: 20),
              _buildBookingCard(isDark),
            ],
          );
        }
      },
    );
  }

  Widget _buildInfoCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('📍', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 10),
                Text(
                  t('importantInfo'),
                  style: GoogleFonts.tajawal(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildInfoItemCompact(
              icon: '📅',
              title: t('receptionDays'),
              description: t('receptionDaysDetail'),
              subDescription: t('receptionHours'),
              color: primary,
              isDark: isDark,
            ),
            _buildInfoItemCompact(
              icon: '⚠️',
              title: t('bookingRequired'),
              description: t('bookingRequiredDetail'),
              color: primary,
              isDark: isDark,
            ),
            _buildInfoItemCompact(
              icon: '📞',
              title: t('contactInfo'),
              description: '${t('phone')}: 0795858484',
              subDescription: '${t('email')}: info@conservation.dz',
              color: primary,
              isDark: isDark,
            ),
            _buildInfoItemCompact(
              icon: '📍',
              title: t('address'),
              description: t('addressDetail'),
              color: primary,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItemCompact({
    required String icon,
    required String title,
    required String description,
    String? subDescription,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? darkBg : bgLight,
        borderRadius: BorderRadius.circular(12),
        border: Border(right: BorderSide(color: secondary, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.tajawal(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? darkText : textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: GoogleFonts.tajawal(
                    fontSize: 13,
                    color: isDark ? darkText.withOpacity(0.7) : textLight,
                  ),
                ),
                if (subDescription != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subDescription,
                    style: GoogleFonts.tajawal(
                      fontSize: 13,
                      color: isDark ? darkText.withOpacity(0.7) : textLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 70, offset: const Offset(0, 25))],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [primary, primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: Column(
              children: [
                Text('📝 ${t('bookingTitle')}', style: GoogleFonts.amiri(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(t('bookingSubtitle'), style: GoogleFonts.tajawal(color: Colors.white.withOpacity(0.9), fontSize: 16)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (_errorMessage != null) _buildErrorMessage(),
                if (_showSuccess)
                  _buildSuccessMessage()
                else
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildFormRow(children: [
                          _buildTextField(controller: _firstnameController, label: t('firstName'), icon: '👤', hint: t('enterFirstName'), isDark: isDark, required: true),
                          _buildTextField(controller: _lastnameController, label: t('lastName'), icon: '👥', hint: t('enterLastName'), isDark: isDark, required: true),
                        ]),
                        const SizedBox(height: 10),
                        _buildFormRow(children: [
                          _buildTextField(controller: _emailController, label: t('email'), icon: '📧', hint: t('enterEmail'), isDark: isDark, required: true, keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v?.isEmpty ?? true) return t('thisFieldRequired');
                              if (!v!.contains('@')) return t('invalidEmail');
                              return null;
                            }),
                          _buildTextField(controller: _phoneController, label: t('phone'), icon: '📱', hint: t('enterPhone'), isDark: isDark, required: true, keyboardType: TextInputType.phone),
                        ]),
                        const SizedBox(height: 10),
                        _buildFormRow(children: [
                          _buildDateField(isDark),
                          _buildServiceTypeField(isDark),
                        ]),
                        const SizedBox(height: 10),
                        _buildNotesField(isDark),
                        const SizedBox(height: 30),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormRow({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children.map((child) => Expanded(child: child)).toList(),
          );
        } else {
          return Column(children: children);
        }
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String icon,
    required String hint,
    required bool isDark,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: GoogleFonts.tajawal(color: isDark ? darkText : textDark, fontSize: 16, fontWeight: FontWeight.bold)),
              if (required) Text(' *', style: GoogleFonts.tajawal(color: danger, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                validator: validator ?? (required ? (v) => (v?.isEmpty ?? true) ? t('thisFieldRequired') : null : null),
                style: GoogleFonts.tajawal(color: isDark ? darkText : textDark, fontSize: 16),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.tajawal(color: Colors.grey.shade400, fontSize: 14),
                  filled: true,
                  fillColor: isDark ? darkBg : Colors.white,
                  contentPadding: const EdgeInsets.only(right: 48, left: 16, top: 16, bottom: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: primary, width: 2)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: danger, width: 2)),
                ),
              ),
              Positioned(left: 16, child: Text(icon, style: const TextStyle(fontSize: 22))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(t('appointmentDate'), style: GoogleFonts.tajawal(color: isDark ? darkText : textDark, fontSize: 16, fontWeight: FontWeight.bold)),
              const Text(' *', style: TextStyle(color: danger, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickDate,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextFormField(
                  controller: _bookingDateController,
                  readOnly: true,
                  validator: (v) => (v?.isEmpty ?? true) ? t('thisFieldRequired') : null,
                  style: GoogleFonts.tajawal(color: isDark ? darkText : textDark, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'YYYY-MM-DD',
                    hintStyle: GoogleFonts.tajawal(color: Colors.grey.shade400, fontSize: 14),
                    filled: true,
                    fillColor: isDark ? darkBg : Colors.white,
                    contentPadding: const EdgeInsets.only(right: 48, left: 16, top: 16, bottom: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: primary, width: 2)),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: danger, width: 2)),
                  ),
                ),
                const Positioned(left: 16, child: Text('📅', style: TextStyle(fontSize: 22))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeField(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(t('serviceType'), style: GoogleFonts.tajawal(color: isDark ? darkText : textDark, fontSize: 16, fontWeight: FontWeight.bold)),
              const Text(' *', style: TextStyle(color: danger, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              DropdownButtonFormField<String>(
                value: _serviceType,
                validator: (v) => (v == null || v.isEmpty) ? t('thisFieldRequired') : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? darkBg : Colors.white,
                  contentPadding: const EdgeInsets.only(right: 48, left: 16, top: 8, bottom: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: primary, width: 2)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: danger, width: 2)),
                ),
                icon: const Icon(Icons.keyboard_arrow_down, color: primary),
                isExpanded: true,
                dropdownColor: isDark ? darkCard : Colors.white,
                items: [
                  DropdownMenuItem(value: null, child: Text(t('selectService'), style: GoogleFonts.tajawal(color: isDark ? darkText.withOpacity(0.5) : textLight, fontSize: 14))),
                  ..._serviceTypes.map((s) => DropdownMenuItem(value: s['value'], child: Text(s['label']!, style: GoogleFonts.tajawal(color: isDark ? darkText : textDark, fontSize: 14)))),
                ],
                onChanged: (v) => setState(() => _serviceType = v),
              ),
              const Positioned(left: 16, child: Text('🔖', style: TextStyle(fontSize: 22))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesField(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(t('notes'), style: GoogleFonts.tajawal(color: isDark ? darkText : textDark, fontSize: 16, fontWeight: FontWeight.bold)),
              Text(' (${t('optional')})', style: GoogleFonts.tajawal(color: textLight, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                style: GoogleFonts.tajawal(color: isDark ? darkText : textDark, fontSize: 16),
                decoration: InputDecoration(
                  hintText: t('enterNotes'),
                  hintStyle: GoogleFonts.tajawal(color: Colors.grey.shade400, fontSize: 14),
                  filled: true,
                  fillColor: isDark ? darkBg : Colors.white,
                  contentPadding: const EdgeInsets.only(right: 48, left: 16, top: 16, bottom: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: primary, width: 2)),
                ),
              ),
              const Positioned(left: 16, top: 16, child: Text('📝', style: TextStyle(fontSize: 22))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(20),
        border: Border(right: BorderSide(color: danger, width: 6)),
      ),
      child: Row(
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Expanded(child: Text(_errorMessage!, style: GoogleFonts.tajawal(color: danger, fontSize: 16, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8F5),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: success, width: 4),
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: success,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: success.withOpacity(0.5), blurRadius: 30, spreadRadius: 10)],
            ),
            child: const Center(child: Icon(Icons.check, color: Colors.white, size: 50)),
          ),
          const SizedBox(height: 20),
          Text(t('bookingSuccess'), style: GoogleFonts.tajawal(color: success, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(t('bookingDetails'), style: GoogleFonts.tajawal(color: textDark, fontSize: 16, height: 1.8), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(t('bookingWarning'), style: GoogleFonts.tajawal(color: danger, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => setState(() => _showSuccess = false),
            icon: const Icon(Icons.arrow_back),
            label: Text(t('backHome'), style: GoogleFonts.tajawal()),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: EdgeInsets.zero),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [secondary, Color(0xFFB88B4F)]),
            borderRadius: BorderRadius.circular(60),
            boxShadow: [BoxShadow(color: secondary.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: _isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('✓ ', style: TextStyle(color: Colors.white, fontSize: 24)),
                      Text(t('confirmBooking'), style: GoogleFonts.tajawal(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Text(
      t('footerNote'),
      style: GoogleFonts.tajawal(
        color: Colors.white.withOpacity(0.8),
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _Particle {
  final double x;
  final double delay;
  final double speed;
  final double size;

  _Particle(int i)
      : x = (i * 37 % 100) / 100,
        delay = (i * 71 % 180) / 100,
        speed = 0.5 + (i % 5) * 0.1,
        size = 5 + (i % 10).toDouble();
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;

  _ParticlePainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final progress = ((t * p.speed + p.delay) % 1.0);
      final y = size.height * (1 - progress);
      final opacity = progress < 0.1 ? progress / 0.1 : progress > 0.9 ? (1 - progress) / 0.1 : 1.0;
      final paint = Paint()
        ..color = Colors.white.withOpacity(opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(Offset(p.x * size.width, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}