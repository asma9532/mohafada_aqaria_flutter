// lib/screens/admin_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/admin_provider.dart';
import '../providers/user_provider.dart';
import 'user_requests_screen.dart';
import '../providers/auth_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String _selectedLanguage = 'ar';
  bool _isSaving = false;
  bool _showDeleted = false;
  String _searchQuery = '';
  String _selectedUserFilter = 'all'; // ✅ الكل كفلتر افتراضي
  final TextEditingController _searchController = TextEditingController();

  late TabController _tabController;

  // ——— الثوابت ———————————————————————————————————————————————
  static const _primaryGreen = Color(0xFF1A5632);
  static const _goldAccent   = Color(0xFFC49B63);
  static const _bgLight      = Color(0xFFF4F6F8);
  static const _darkBg       = Color(0xFF111827);
  static const _darkCard     = Color(0xFF1F2937);

  // ✅ قسم واحد فقط: المستخدمين
  final List<Map<String, dynamic>> _sections = [
    {'index': 0, 'title': 'المستخدمين', 'icon': Icons.people_rounded, 'color': const Color(0xFF1A5632)},
  ];

  final Map<String, dynamic> _stats = {
    'total_fields': 54,
    'deleted_fields': 3,
    'modified_today': 12,
    'total_sections': 1,
    'last_save': '10:34 ص',
    'languages': 3,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _sections.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _loadUsersData();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() => _selectedIndex = _tabController.index);
    }
  }

  Future<void> _loadUsersData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchStats();
    await userProvider.fetchNewUsers(_selectedUserFilter);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.tajawal(color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider  = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final adminProvider  = Provider.of<AdminProvider>(context);
    final userProvider   = Provider.of<UserProvider>(context);
    final isDark         = themeProvider.isDarkMode;

    if (!adminProvider.isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushReplacementNamed(context, '/'));
      return const SizedBox();
    }

    final bg        = isDark ? _darkBg   : _bgLight;
    final cardColor = isDark ? _darkCard : Colors.white;

    return Directionality(
      textDirection: localeProvider.textDirection,
      child: Scaffold(
        backgroundColor: bg,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D3D22), _primaryGreen, Color(0xFF2E7D52)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [BoxShadow(color: Color(0x44000000), blurRadius: 12, offset: Offset(0, 4))],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('لوحة تحكم المسؤول', style: GoogleFonts.tajawal(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('إدارة المستخدمين', style: GoogleFonts.tajawal(color: Colors.white70, fontSize: 11)),
                    ]),
                  ),
                  _iconBtn(
                    icon: Icons.logout_rounded,
                    tooltip: 'خروج',
                    onTap: () { adminProvider.logoutAdmin(); Navigator.pop(context); },
                  ),
                ]),
              ),
            ),
          ),
        ),
        body: _buildUsersSection(isDark, cardColor, userProvider),
      ),
    );
  }

  Widget _iconBtn({required IconData icon, required String tooltip, VoidCallback? onTap, bool active = false, bool loading = false}) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: active ? Colors.white.withOpacity(0.25) : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: loading
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  // ✅ قسم المستخدمين فقط
  Widget _buildUsersSection(bool isDark, Color cardColor, UserProvider userProvider) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A5632), Color(0xFF2E7D52)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.people_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('إدارة المستخدمين', style: GoogleFonts.tajawal(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('عرض وإدارة المستخدمين الجدد', style: GoogleFonts.tajawal(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Stats Cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildAdminStatCard('اليوم', userProvider.stats['today'] ?? 0, Colors.orange, Icons.today_rounded, isDark),
                const SizedBox(width: 8),
                _buildAdminStatCard('الأسبوع', userProvider.stats['week'] ?? 0, Colors.green, Icons.date_range_rounded, isDark),
                const SizedBox(width: 8),
                _buildAdminStatCard('الشهر', userProvider.stats['month'] ?? 0, Colors.purple, Icons.calendar_month_rounded, isDark),
                const SizedBox(width: 8),
                _buildAdminStatCard('الإجمالي', userProvider.stats['total'] ?? 0, Colors.blue, Icons.people_rounded, isDark),
              ],
            ),
          ),
        ),

        // ✅ Filter Chips - 4 فلاتر مع "الكل" كأول فلتر وافتراضي
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildAdminFilterChip('الكل', 'all', isDark, userProvider),
                const SizedBox(width: 6),
                _buildAdminFilterChip('الشهر', 'month', isDark, userProvider),
                const SizedBox(width: 6),
                _buildAdminFilterChip('الأسبوع', 'week', isDark, userProvider),
                const SizedBox(width: 6),
                _buildAdminFilterChip('اليوم', 'today', isDark, userProvider),
              ],
            ),
          ),
        ),

        // Users List
        if (userProvider.isLoading)
          const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            ),
          )
        else if (userProvider.users.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('لا يوجد مستخدمين', style: TextStyle(fontSize: 16, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await userProvider.fetchNewUsers(_selectedUserFilter);
                      await userProvider.fetchStats();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة تحميل'),
                    style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen, foregroundColor: Colors.white),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildAdminUserCard(userProvider.users[index], isDark, cardColor),
                childCount: userProvider.users.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAdminStatCard(String label, int count, Color color, IconData icon, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(count.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[400] : Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  // ✅ الدالة المصلحة - 4 فلاتر والكل افتراضي
  Widget _buildAdminFilterChip(String label, String value, bool isDark, UserProvider userProvider) {
    final isSelected = _selectedUserFilter == value;
    return Expanded(
      child: FilterChip(
        label: Text(label, style: GoogleFonts.tajawal(fontSize: 12)),
        selected: isSelected,
        onSelected: (selected) async {
          setState(() => _selectedUserFilter = value);
          await userProvider.fetchNewUsers(value);
          await userProvider.fetchStats();
        },
        backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
        selectedColor: _primaryGreen,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildAdminUserCard(dynamic user, bool isDark, Color cardColor) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserRequestsScreen(
              userId: user.id,
              userName: user.fullName,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: CircleAvatar(
            backgroundColor: _primaryGreen,
            child: Text(
              user.fullName[0].toUpperCase(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  user.fullName,
                  style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                ),
              ),
              if (user.requestsCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                  child: Text('${user.requestsCount} طلبات', style: const TextStyle(color: Colors.white, fontSize: 10)),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(user.email, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              if (user.phone != null)
                Text(user.phone!, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(user.getLocalizedDate(locale), style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: user.isActive ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(user.getLocalizedStatus(locale), style: const TextStyle(color: Colors.white, fontSize: 10)),
          ),
        ),
      ),
    );
  }
}