import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../screens/admin_login_screen.dart';
import '../screens/admin_dashboard_screen.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double elevation;

  const AdminAppBar({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor,
    this.elevation = 4,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return AppBar(
      title: title,
      backgroundColor: backgroundColor ?? const Color(0xFF1A5632),
      elevation: elevation,
      actions: [
        if (actions != null) ...actions!,
        
        // زر لوحة الإدارة
        IconButton(
          icon: const Icon(Icons.admin_panel_settings),
          onPressed: () {
            if (adminProvider.isAdmin) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
              );
            }
          },
          tooltip: 'لوحة الإدارة',
        ),
      ],
    );
  }
}