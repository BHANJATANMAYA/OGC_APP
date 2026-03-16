import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/production_entry.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class ProductionTab extends StatefulWidget {
  const ProductionTab({super.key});

  @override
  State<ProductionTab> createState() => _ProductionTabState();
}

class _ProductionTabState extends State<ProductionTab> {
  final StorageService _storage = StorageService();
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _machineController = TextEditingController();
  final _designController = TextEditingController();
  final _workerController = TextEditingController();
  final _piecesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _editingId;

  List<ProductionEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
    _loadEntries();
  }

  void _loadEntries() {
    setState(() {
      _entries = _storage.getAllProduction().reversed.toList();
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _machineController.clear();
    _designController.clear();
    _workerController.clear();
    _piecesController.clear();
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
    _editingId = null;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) return;

    final entry = ProductionEntry(
      id: _editingId ?? const Uuid().v4(),
      date: _selectedDate,
      machineNumber: _machineController.text.trim(),
      designNumber: _designController.text.trim(),
      workerName: _workerController.text.trim(),
      piecesCompleted: int.parse(_piecesController.text.trim()),
    );

    if (_editingId != null) {
      await _storage.updateProduction(entry);
    } else {
      await _storage.addProduction(entry);
    }

    _resetForm();
    _loadEntries();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_editingId != null ? 'Log updated!' : 'Log added!'),
          backgroundColor: AppColors.productionBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _editEntry(ProductionEntry entry) {
    setState(() {
      _editingId = entry.id;
      _selectedDate = entry.date;
      _dateController.text = DateFormat('dd/MM/yyyy').format(entry.date);
      _machineController.text = entry.machineNumber;
      _designController.text = entry.designNumber;
      _workerController.text = entry.workerName;
      _piecesController.text = entry.piecesCompleted.toString();
    });
  }

  Future<void> _deleteEntry(ProductionEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Log'),
        content: const Text(
          'Are you sure you want to delete this production log?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _storage.deleteProduction(entry.id);
      _loadEntries();
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _machineController.dispose();
    _designController.dispose();
    _workerController.dispose();
    _piecesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Tracker'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.productionBlue, Color(0xFF1E88E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildForm(),
            const SizedBox(height: 24),
            const Text(
              'Recent Production Logs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            if (_entries.isEmpty)
              _buildEmptyState()
            else
              ..._entries.map(_buildEntryCard),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.productionBlue.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: _pickDate,
              decoration: const InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.productionBlue,
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _machineController,
              decoration: const InputDecoration(
                labelText: 'Machine Number',
                prefixIcon: Icon(
                  Icons.precision_manufacturing_rounded,
                  color: AppColors.productionBlue,
                ),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter machine number' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _designController,
              decoration: const InputDecoration(
                labelText: 'Design Number',
                prefixIcon: Icon(
                  Icons.design_services_rounded,
                  color: AppColors.productionBlue,
                ),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter design number' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _workerController,
              decoration: const InputDecoration(
                labelText: 'Worker Name',
                prefixIcon: Icon(
                  Icons.badge_rounded,
                  color: AppColors.productionBlue,
                ),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter worker name' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _piecesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Pieces Completed',
                prefixIcon: Icon(
                  Icons.format_list_numbered_rounded,
                  color: AppColors.productionBlue,
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter pieces count';
                if (int.tryParse(v.trim()) == null) {
                  return 'Enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _saveEntry,
                icon: Icon(
                  _editingId != null ? Icons.save_rounded : Icons.add_rounded,
                  color: Colors.white,
                ),
                label: Text(
                  _editingId != null ? 'Update Log' : 'Add Log',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.productionBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            if (_editingId != null) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _resetForm();
                  setState(() {});
                },
                child: const Text('Cancel Edit'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.inbox_rounded, size: 48, color: AppColors.textSecondary),
          SizedBox(height: 12),
          Text(
            'No logs yet',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(ProductionEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.productionBlue.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.productionBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Design: ${entry.designNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.productionBlueLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${entry.piecesCompleted} pcs',
                        style: const TextStyle(
                          color: AppColors.productionBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Machine: ${entry.machineNumber}  •  ${entry.workerName}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd MMM yyyy').format(entry.date),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit_rounded,
                  color: AppColors.productionBlue,
                  size: 20,
                ),
                onPressed: () => _editEntry(entry),
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                  size: 20,
                ),
                onPressed: () => _deleteEntry(entry),
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
