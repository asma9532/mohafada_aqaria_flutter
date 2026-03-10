import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class NewUsersScreen extends StatefulWidget {
  const NewUsersScreen({super.key});

  @override
  State<NewUsersScreen> createState() => _NewUsersScreenState();
}

class _NewUsersScreenState extends State<NewUsersScreen> {
  String _selectedFilter = 'month'; // أو 'all

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    await userProvider.fetchStats();
    await userProvider.fetchNewUsers(_selectedFilter);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final locale = Provider.of<LocaleProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDark = theme.isDarkMode;

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المستخدمين الجدد'),
          backgroundColor: const Color(0xFF1A5632),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadData,
            ),
          ],
        ),
        body: userProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // فلاتر
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _buildFilterChip('اليوم', 'today', isDark, userProvider),
                        const SizedBox(width: 8),
                        _buildFilterChip('هذا الأسبوع', 'week', isDark, userProvider),
                        const SizedBox(width: 8),
                        _buildFilterChip('هذا الشهر', 'month', isDark, userProvider),
                      ],
                    ),
                  ),

                  // إحصائيات
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildStatCard('اليوم', userProvider.stats['today'] ?? 0, Colors.orange, isDark),
                        const SizedBox(width: 8),
                        _buildStatCard('الأسبوع', userProvider.stats['week'] ?? 0, Colors.green, isDark),
                        const SizedBox(width: 8),
                        _buildStatCard('الشهر', userProvider.stats['month'] ?? 0, Colors.purple, isDark),
                        const SizedBox(width: 8),
                        _buildStatCard('الإجمالي', userProvider.stats['total'] ?? 0, Colors.blue, isDark),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // قائمة المستخدمين
                  Expanded(
                    child: userProvider.users.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 80,
                                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'لا يوجد مستخدمين جدد',
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: userProvider.users.length,
                            itemBuilder: (context, index) {
                              final user = userProvider.users[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: const Color(0xFF1A5632),
                                    child: Text(
                                      user.fullName[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    user.fullName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        user.email,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        ),
                                      ),
                                      if (user.phone != null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          user.phone!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 12,
                                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            user.formattedDate,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isDark ? Colors.grey[500] : Colors.grey[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, bool isDark, UserProvider userProvider) {
    return Expanded(
      child: FilterChip(
        label: Text(label),
        selected: _selectedFilter == value,
        onSelected: (selected) async {
          setState(() {
            _selectedFilter = value;
          });
          await userProvider.fetchNewUsers(value);
        },
        backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
        selectedColor: const Color(0xFF1A5632),
        labelStyle: TextStyle(
          color: _selectedFilter == value 
              ? Colors.white 
              : (isDark ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}