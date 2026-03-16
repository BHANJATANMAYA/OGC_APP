import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/outward_entry.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class OutwardTab extends StatefulWidget {
  const OutwardTab({super.key});
  @override
  State<OutwardTab> createState() => _OutwardTabState();
}

class _OutwardTabState extends State<OutwardTab> {
  final StorageService _storage = StorageService();
  final _formKey = GlobalKey<FormState>();
  final _dateCtl = TextEditingController();
  final _designCtl = TextEditingController();
  final _piecesCtl = TextEditingController();
  final _challanCtl = TextEditingController();
  DateTime _date = DateTime.now();
  String? _editId;
  List<OutwardEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _dateCtl.text = DateFormat('dd/MM/yyyy').format(_date);
    _load();
  }

  void _load() =>
      setState(() => _entries = _storage.getAllOutward().reversed.toList());

  void _reset() {
    _formKey.currentState?.reset();
    _designCtl.clear();
    _piecesCtl.clear();
    _challanCtl.clear();
    _date = DateTime.now();
    _dateCtl.text = DateFormat('dd/MM/yyyy').format(_date);
    _editId = null;
  }

  Future<void> _pickDate() async {
    final p = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (p != null) {
      setState(() {
        _date = p;
        _dateCtl.text = DateFormat('dd/MM/yyyy').format(p);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final e = OutwardEntry(
      id: _editId ?? const Uuid().v4(),
      date: _date,
      designNumber: _designCtl.text.trim(),
      totalPiecesSent: int.parse(_piecesCtl.text.trim()),
      challanNumber: _challanCtl.text.trim(),
    );
    _editId != null
        ? await _storage.updateOutward(e)
        : await _storage.addOutward(e);
    _reset();
    _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_editId != null ? 'Updated!' : 'Added!'),
          backgroundColor: AppColors.outwardOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _edit(OutwardEntry e) => setState(() {
    _editId = e.id;
    _date = e.date;
    _dateCtl.text = DateFormat('dd/MM/yyyy').format(e.date);
    _designCtl.text = e.designNumber;
    _piecesCtl.text = e.totalPiecesSent.toString();
    _challanCtl.text = e.challanNumber;
  });

  Future<void> _delete(OutwardEntry e) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Entry'),
        content: const Text('Delete this dispatch entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(c, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _storage.deleteOutward(e.id);
      _load();
    }
  }

  @override
  void dispose() {
    _dateCtl.dispose();
    _designCtl.dispose();
    _piecesCtl.dispose();
    _challanCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outward — Dispatch'),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.outwardOrange, Color(0xFFF57C00)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _form(),
            const SizedBox(height: 24),
            const Text(
              'Dispatch Records',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            if (_entries.isEmpty) _empty() else ..._entries.map(_card),
          ],
        ),
      ),
    );
  }

  Widget _form() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: AppColors.outwardOrange.withValues(alpha: 0.08),
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
            controller: _dateCtl,
            readOnly: true,
            onTap: _pickDate,
            decoration: const InputDecoration(
              labelText: 'Date',
              prefixIcon: Icon(
                Icons.calendar_today_rounded,
                color: AppColors.outwardOrange,
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _designCtl,
            decoration: const InputDecoration(
              labelText: 'Design Number',
              prefixIcon: Icon(
                Icons.design_services_rounded,
                color: AppColors.outwardOrange,
              ),
            ),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _piecesCtl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Total Pieces Sent',
              prefixIcon: Icon(
                Icons.outbox_rounded,
                color: AppColors.outwardOrange,
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (int.tryParse(v.trim()) == null) return 'Invalid';
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _challanCtl,
            decoration: const InputDecoration(
              labelText: 'Challan / Invoice Number',
              prefixIcon: Icon(
                Icons.receipt_long_rounded,
                color: AppColors.outwardOrange,
              ),
            ),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _save,
              icon: Icon(
                _editId != null ? Icons.save_rounded : Icons.add_rounded,
                color: Colors.white,
              ),
              label: Text(
                _editId != null ? 'Update Entry' : 'Add Entry',
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.outwardOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          if (_editId != null) ...[
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                _reset();
                setState(() {});
              },
              child: const Text('Cancel Edit'),
            ),
          ],
        ],
      ),
    ),
  );

  Widget _empty() => Container(
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
          'No dispatch records yet',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ),
      ],
    ),
  );

  Widget _card(OutwardEntry e) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: AppColors.outwardOrange.withValues(alpha: 0.15),
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
            color: AppColors.outwardOrange,
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
                    'Design: ${e.designNumber}',
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
                      color: AppColors.outwardOrangeLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${e.totalPiecesSent} pcs',
                      style: const TextStyle(
                        color: AppColors.outwardOrange,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Invoice: ${e.challanNumber}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('dd MMM yyyy').format(e.date),
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
                color: AppColors.outwardOrange,
                size: 20,
              ),
              onPressed: () => _edit(e),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_rounded,
                color: Colors.red,
                size: 20,
              ),
              onPressed: () => _delete(e),
            ),
          ],
        ),
      ],
    ),
  );
}
