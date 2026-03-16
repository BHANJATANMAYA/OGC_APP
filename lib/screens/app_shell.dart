import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dashboard_tab.dart';
import 'inward_tab.dart';
import 'production_tab.dart';
import 'outward_tab.dart';
import 'search_tab.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    DashboardTab(),
    InwardTab(),
    ProductionTab(),
    OutwardTab(),
    SearchTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard_rounded,
                color: _currentIndex == 0
                    ? AppColors.dashboardPurple
                    : AppColors.textSecondary,
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.input_rounded,
                color: _currentIndex == 1
                    ? AppColors.inwardGreen
                    : AppColors.textSecondary,
              ),
              label: 'Inward',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.precision_manufacturing_rounded,
                color: _currentIndex == 2
                    ? AppColors.productionBlue
                    : AppColors.textSecondary,
              ),
              label: 'Production',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.local_shipping_rounded,
                color: _currentIndex == 3
                    ? AppColors.outwardOrange
                    : AppColors.textSecondary,
              ),
              label: 'Outward',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search_rounded,
                color: _currentIndex == 4
                    ? AppColors.searchGrey
                    : AppColors.textSecondary,
              ),
              label: 'Search',
            ),
          ],
        ),
      ),
    );
  }
}
