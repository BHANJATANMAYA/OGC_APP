import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/inward_entry.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class InwardTab extends StatefulWidget {
  const InwardTab({super.key});

  @override
  State<InwardTab> createState() => _InwardTabState();
}

class _InwardTabState extends State<InwardTab> {
  final StorageService _storage = StorageService();
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _partyController = TextEditingController();
  final _fabricController = TextEditingController();
  final _quantityController = TextEditingController();
  final _designController = TextEditingController();
  String _selectedUnit = 'Meters';
  DateTime _selectedDate = DateTime.now();
  String? _editingId;

  List<InwardEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
    _loadEntries();
  }

  void _loadEntries() {
    setState(() {
      _entries = _storage.getAllInward().reversed.toList();
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _partyController.clear();
    _fabricController.clear();
    _quantityController.clear();
    _designController.clear();
    _selectedUnit = 'Meters';
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

    final entry = InwardEntry(
      id: _editingId ?? const Uuid().v4(),
      date: _selectedDate,
      partyName: _partyController.text.trim(),
      fabricType: _fabricController.text.trim(),
      quantityReceived: double.parse(_quantityController.text.trim()),
      unit: _selectedUnit,
      designNumber: _designController.text.trim(),
    );

    if (_editingId != null) {
      await _storage.updateInward(entry);
    } else {
      await _storage.addInward(entry);
    }

    _resetForm();
    _loadEntries();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_editingId != null ? 'Entry updated!' : 'Entry added!'),
          backgroundColor: AppColors.inwardGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _editEntry(InwardEntry entry) {
    setState(() {
      _editingId = entry.id;
      _selectedDate = entry.date;
      _dateController.text = DateFormat('dd/MM/yyyy').format(entry.date);
      _partyController.text = entry.partyName;
      _fabricController.text = entry.fabricType;
      _quantityController.text = entry.quantityReceived.toString();
      _selectedUnit = entry.unit;
      _designController.text = entry.designNumber;
    });
  }

  Future<void> _deleteEntry(InwardEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Entry'),
        content: const Text(
          'Are you sure you want to delete this inward entry?',
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
      await _storage.deleteInward(entry.id);
      _loadEntries();
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _partyController.dispose();
    _fabricController.dispose();
    _quantityController.dispose();
    _designController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inward — Raw Material'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.inwardGreen, Color(0xFF43A047)],
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
            Text(
              _editingId != null ? 'Editing Entry' : 'Saved Entries',
              style: const TextStyle(
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
            color: AppColors.inwardGreen.withValues(alpha: 0.08),
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
                  color: AppColors.inwardGreen,
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _partyController,
              decoration: const InputDecoration(
                labelText: 'Party Name',
                prefixIcon: Icon(
                  Icons.person_rounded,
                  color: AppColors.inwardGreen,
                ),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter party name' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _fabricController,
              decoration: const InputDecoration(
                labelText: 'Fabric Type', //sahil requested to change from "Fabric Name" to "chalan no"
                prefixIcon: Icon(
                  Icons.texture_rounded,
                  color: AppColors.inwardGreen,
                ),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter fabric type' : null,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      prefixIcon: Icon(
                        Icons.numbers_rounded,
                        color: AppColors.inwardGreen,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter qty';
                      if (double.tryParse(v.trim()) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inwardGreenLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ToggleButtons(
                    isSelected: [
                      _selectedUnit == 'Meters',
                      _selectedUnit == 'Pieces',
                    ],
                    onPressed: (i) {
                      setState(() {
                        _selectedUnit = i == 0 ? 'Meters' : 'Pieces';
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: Colors.white,
                    fillColor: AppColors.inwardGreen,
                    color: AppColors.inwardGreen,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 60,
                      minHeight: 40,
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('Meters'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('Pieces'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _designController,
              decoration: const InputDecoration(
                labelText: 'Design Number',
                prefixIcon: Icon(
                  Icons.design_services_rounded,
                  color: AppColors.inwardGreen,
                ),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter design number' : null,
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
                  _editingId != null ? 'Update Entry' : 'Add Entry',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.inwardGreen,
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
            'No entries yet',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(InwardEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.inwardGreen.withValues(alpha: 0.15),
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
              color: AppColors.inwardGreen,
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
                      entry.partyName,
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
                        color: AppColors.inwardGreenLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'D# ${entry.designNumber}',
                        style: const TextStyle(
                          color: AppColors.inwardGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${entry.fabricType}  •  ${entry.quantityReceived % 1 == 0 ? entry.quantityReceived.toInt() : entry.quantityReceived} ${entry.unit}',
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
                  color: AppColors.inwardGreen,
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
