import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import 'real_estate_card_request_screen.dart';
import 'contract_extract_request_screen.dart';
import 'home_screen.dart';

class CardTypeSelectionScreen extends StatefulWidget {
  const CardTypeSelectionScreen({super.key});

  @override
  State<CardTypeSelectionScreen> createState() => _CardTypeSelectionScreenState();
}

class _CardTypeSelectionScreenState extends State<CardTypeSelectionScreen>
    with SingleTickerProviderStateMixin {
  static const Color primaryGreen = Color(0xFF1A5632);
  static const Color primaryDark = Color(0xFF0D3D20);
  static const Color secondaryGold = Color(0xFFC49B63);
  static const Color accentBrown = Color(0xFF8B6F47);
  static const Color bgLight = Color(0xFFF8F6F1);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color darkBg = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color infoColor = Color(0xFF17A2B8);

  late AnimationController _animationController;
  final List<Animation<double>> _fadeAnimations = [];
  int? _expandedIndex;

  static const Map<String, Map<String, String>> translations = {
    'title': {
      'ar': 'الوثائق العقارية',
      'en': 'Real Estate Documents',
      'fr': 'Documents Fonciers',
    },
    'subtitle': {
      'ar': 'اختر نوع الوثيقة',
      'en': 'Select Document Type',
      'fr': 'Sélectionnez le Type de Document',
    },
    'personal': {
      'ar': 'البطاقة الشخصية',
      'en': 'Personal Card',
      'fr': 'Carte Personnelle',
    },
    'urban': {
      'ar': 'البطاقة الحضرية',
      'en': 'Urban Card',
      'fr': 'Carte Urbaine',
    },
    'rural': {
      'ar': 'البطاقة الريفية',
      'en': 'Rural Card',
      'fr': 'Carte Rurale',
    },
    'alphabetical': {
      'ar': 'البطاقة الأبجدية',
      'en': 'Alphabetical Card',
      'fr': 'Carte Alphabétique',
    },
    'realEstateCards': {
      'ar': 'البطاقات العقارية',
      'en': 'Real Estate Cards',
      'fr': 'Cartes Foncières',
    },
    'contractExtracts': {
      'ar': 'مستخرجات العقود',
      'en': 'Contract Extracts',
      'fr': 'Extraits de Contrats',
    },
  };

  String t(String key) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;
    return translations[key]?[locale] ?? translations[key]?['ar'] ?? key;
  }

  void _toggle(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? null : index;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    for (int i = 0; i < 15; i++) {
      _fadeAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(i * 0.1, 0.8, curve: Curves.easeOutQuad),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Directionality(
      textDirection: locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: isDark ? darkBg : bgLight,
        body: Column(
          children: [
            _buildModernHeader(isDark, locale),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    _buildStatsCards(isDark),
                    const SizedBox(height: 24),
                    FadeTransition(
                      opacity: _fadeAnimations[0],
                      child: _buildModernAccordion(
                        isDark: isDark,
                        index: 0,
                        icon: Icons.grid_view_rounded,
                        title: t('realEstateCards'),
                        color: primaryGreen,
                        badge: '4',
                        child: _buildModernCardsGrid(isDark, locale),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeTransition(
                      opacity: _fadeAnimations[1],
                      child: _buildModernAccordion(
                        isDark: isDark,
                        index: 1,
                        icon: Icons.description_rounded,
                        title: t('contractExtracts'),
                        color: infoColor,
                        badge: null,
                        child: _buildModernExtractGrid(isDark, locale),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader(bool isDark, String locale) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryGreen, primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -5,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _goBack,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.2), width: 1.5),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: secondaryGold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: secondaryGold.withOpacity(0.3), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.description_rounded,
                            color: secondaryGold, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          t('title'),
                          style: GoogleFonts.tajawal(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.15), width: 1),
                ),
                child: Text(
                  t('subtitle'),
                  style: GoogleFonts.tajawal(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            isDark: isDark,
            icon: Icons.credit_card_rounded,
            value: '4',
            color: primaryGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            isDark: isDark,
            icon: Icons.description_rounded,
            value: '7',
            color: infoColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            isDark: isDark,
            icon: Icons.timer_rounded,
            value: '24/7',
            color: secondaryGold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required bool isDark,
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDark ? darkCard : Colors.white,
            isDark ? darkCard.withOpacity(0.8) : Colors.white.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.tajawal(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAccordion({
    required bool isDark,
    required int index,
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
    String? badge,
  }) {
    final isOpen = _expandedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDark ? darkCard : Colors.white,
            isDark ? darkCard.withOpacity(0.95) : Colors.white.withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isOpen ? color.withOpacity(0.4) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isOpen ? 0.2 : 0.1),
            blurRadius: isOpen ? 24 : 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _toggle(index),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            color.withOpacity(0.3),
                            color.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: isDark ? darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(icon, color: color, size: 24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.tajawal(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : textDark,
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                badge,
                                style: GoogleFonts.tajawal(
                                  fontSize: 10,
                                  color: color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      transform: Matrix4.rotationZ(isOpen ? 0.5 : 0),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: color,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 400),
            crossFadeState:
                isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Column(
              children: [
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.1),
                        color.withOpacity(0.3),
                        color.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCardsGrid(bool isDark, String locale) {
    final cards = [
      {'title': t('personal'), 'icon': Icons.person_rounded, 'color': primaryGreen},
      {'title': t('urban'), 'icon': Icons.location_city_rounded, 'color': secondaryGold},
      {'title': t('rural'), 'icon': Icons.landscape_rounded, 'color': accentBrown},
      {'title': t('alphabetical'), 'icon': Icons.abc_rounded, 'color': infoColor},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        final color = card['color'] as Color;
        final icon = card['icon'] as IconData;
        final title = card['title'] as String;

        return FadeTransition(
          opacity: _fadeAnimations[index + 2],
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RealEstateCardRequestScreen(cardType: title),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.15), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -10,
                    right: -10,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color.withOpacity(0.2),
                                color.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(icon, color: color, size: 26),
                        ),
                        const Spacer(),
                        Text(
                          title,
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernExtractGrid(bool isDark, String locale) {
    final contractTypes = [
      {'value': 'حجز', 'label_ar': 'حجز', 'label_en': 'Seizure', 'label_fr': 'Saisie',
       'icon': Icons.lock_rounded, 'color': const Color(0xFF6C63FF)},
      {'value': 'بيع', 'label_ar': 'بيع', 'label_en': 'Sale', 'label_fr': 'Vente',
       'icon': Icons.sell_rounded, 'color': primaryGreen},
      {'value': 'هبة', 'label_ar': 'هبة', 'label_en': 'Gift', 'label_fr': 'Donation',
       'icon': Icons.card_giftcard_rounded, 'color': secondaryGold},
      {'value': 'رهن_او_امتياز', 'label_ar': 'رهن', 'label_en': 'Mortgage', 'label_fr': 'Hypothèque',
       'icon': Icons.account_balance_rounded, 'color': accentBrown},
      {'value': 'تشطيب', 'label_ar': 'تشطيب', 'label_en': 'Termination', 'label_fr': 'Annulation',
       'icon': Icons.delete_rounded, 'color': infoColor},
      {'value': 'عريضة', 'label_ar': 'عريضة', 'label_en': 'Petition', 'label_fr': 'Pétition',
       'icon': Icons.edit_note_rounded, 'color': const Color(0xFF8B6F47)},
      {'value': 'وثيقة_ناقلة_للملكية', 'label_ar': 'نقل ملكية', 'label_en': 'Title Deed', 'label_fr': 'Titre',
       'icon': Icons.swap_horiz_rounded, 'color': primaryDark},
    ];

    String getLabel(Map<String, dynamic> type) {
      switch (locale) {
        case 'en': return type['label_en'] as String;
        case 'fr': return type['label_fr'] as String;
        default: return type['label_ar'] as String;
      }
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: contractTypes.length,
      itemBuilder: (context, index) {
        final type = contractTypes[index];
        final color = type['color'] as Color;
        final icon = type['icon'] as IconData;
        final label = getLabel(type);

        return FadeTransition(
          opacity: _fadeAnimations[index + 2],
          child: Tooltip(
            message: label,
            preferBelow: false,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ContractExtractRequestScreen(
                      selectedType: type['value'] as String,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.12), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 22),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        label,
                        style: GoogleFonts.tajawal(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : textDark,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}