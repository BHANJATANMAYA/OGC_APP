import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  final StorageService _storage = StorageService();

  double _totalRawMaterial = 0;
  int _totalFinished = 0;
  int _totalDispatched = 0;
  Set<String> _designNumbers = {};

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _totalRawMaterial = _storage.totalRawMaterialInStock;
      _totalFinished = _storage.totalFinishedPieces;
      _totalDispatched = _storage.totalDispatched;
      _designNumbers = _storage.allDesignNumbers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.dashboardPurple, Color(0xFF7E57C2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildSummaryCards(),
              const SizedBox(height: 24),
              _buildDesignNumbersSection(),
              const SizedBox(height: 24),
              _buildRefreshButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      children: [
        _SummaryCard(
          title: 'Raw Material in Stock',
          value: _totalRawMaterial % 1 == 0
              ? _totalRawMaterial.toInt().toString()
              : _totalRawMaterial.toStringAsFixed(1),
          icon: Icons.inventory_2_rounded,
          color: AppColors.inwardGreen,
          bgColor: AppColors.inwardGreenLight,
        ),
        const SizedBox(height: 12),
        _SummaryCard(
          title: 'Finished Pieces Ready',
          value: _totalFinished.toString(),
          icon: Icons.check_circle_rounded,
          color: AppColors.productionBlue,
          bgColor: AppColors.productionBlueLight,
        ),
        const SizedBox(height: 12),
        _SummaryCard(
          title: 'Pieces Dispatched',
          value: _totalDispatched.toString(),
          icon: Icons.local_shipping_rounded,
          color: AppColors.outwardOrange,
          bgColor: AppColors.outwardOrangeLight,
        ),
      ],
    );
  }

  Widget _buildDesignNumbersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Live Design Numbers',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        if (_designNumbers.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: const Text(
              'No design numbers yet. Add entries to see them here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          )
        else
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _designNumbers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final design = _designNumbers.elementAt(index);
                return Chip(
                  label: Text(
                    design,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.dashboardPurple,
                    ),
                  ),
                  backgroundColor: AppColors.dashboardPurpleLight,
                  side: BorderSide(
                    color: AppColors.dashboardPurple.withValues(alpha: 0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildRefreshButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _refreshData,
        icon: const Icon(Icons.refresh_rounded, color: Colors.white),
        label: const Text(
          'Refresh Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.dashboardPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
