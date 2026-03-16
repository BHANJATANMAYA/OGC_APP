import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/inward_entry.dart';
import '../models/production_entry.dart';
import '../models/outward_entry.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});
  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final StorageService _storage = StorageService();
  final _searchCtl = TextEditingController();
  Map<String, List<dynamic>> _results = {};
  bool _hasSearched = false;

  void _search() {
    final q = _searchCtl.text.trim();
    setState(() {
      _hasSearched = q.isNotEmpty;
      _results = _storage.searchByDesignNumber(q);
    });
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.searchGrey, Color(0xFF78909C)],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtl,
              onChanged: (_) => _search(),
              decoration: InputDecoration(
                hintText: 'Search by Design Number',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.searchGrey,
                ),
                suffixIcon: _searchCtl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchCtl.clear();
                          _search();
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(child: _hasSearched ? _buildResults() : _buildEmpty()),
        ],
      ),
    );
  }

  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.search_rounded, size: 64, color: Colors.grey[300]),
        const SizedBox(height: 16),
        const Text(
          'Enter a design number to search',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ),
      ],
    ),
  );

  Widget _buildResults() {
    final inward = _results['INWARD'] ?? [];
    final production = _results['PRODUCTION'] ?? [];
    final outward = _results['OUTWARD'] ?? [];
    if (inward.isEmpty && production.isEmpty && outward.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              'No results found',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (inward.isNotEmpty) ...[
            _sectionHeader('INWARD', AppColors.inwardGreen, inward.length),
            ...inward.map((e) => _inwardCard(e as InwardEntry)),
            const SizedBox(height: 16),
          ],
          if (production.isNotEmpty) ...[
            _sectionHeader(
              'PRODUCTION',
              AppColors.productionBlue,
              production.length,
            ),
            ...production.map((e) => _productionCard(e as ProductionEntry)),
            const SizedBox(height: 16),
          ],
          if (outward.isNotEmpty) ...[
            _sectionHeader('OUTWARD', AppColors.outwardOrange, outward.length),
            ...outward.map((e) => _outwardCard(e as OutwardEntry)),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionHeader(String label, Color color, int count) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$count result${count > 1 ? 's' : ''}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    ),
  );

  Widget _inwardCard(InwardEntry e) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.inwardGreen.withValues(alpha: 0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          e.partyName,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          '${e.fabricType}  •  ${e.quantityReceived % 1 == 0 ? e.quantityReceived.toInt() : e.quantityReceived} ${e.unit}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        Text(
          DateFormat('dd MMM yyyy').format(e.date),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    ),
  );

  Widget _productionCard(ProductionEntry e) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: AppColors.productionBlue.withValues(alpha: 0.2),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Machine: ${e.machineNumber}  •  ${e.workerName}',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          '${e.piecesCompleted} pieces completed',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        Text(
          DateFormat('dd MMM yyyy').format(e.date),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    ),
  );

  Widget _outwardCard(OutwardEntry e) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.outwardOrange.withValues(alpha: 0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Invoice: ${e.challanNumber}',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          '${e.totalPiecesSent} pieces sent',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        Text(
          DateFormat('dd MMM yyyy').format(e.date),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    ),
  );
}
