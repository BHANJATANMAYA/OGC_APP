import 'package:hive_flutter/hive_flutter.dart';
import '../models/inward_entry.dart';
import '../models/production_entry.dart';
import '../models/outward_entry.dart';

class StorageService {
  static const String _inwardBox = 'inward_entries';
  static const String _productionBox = 'production_entries';
  static const String _outwardBox = 'outward_entries';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late Box<InwardEntry> _inwardEntries;
  late Box<ProductionEntry> _productionEntries;
  late Box<OutwardEntry> _outwardEntries;

  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(InwardEntryAdapter());
    Hive.registerAdapter(ProductionEntryAdapter());
    Hive.registerAdapter(OutwardEntryAdapter());

    _inwardEntries = await Hive.openBox<InwardEntry>(_inwardBox);
    _productionEntries = await Hive.openBox<ProductionEntry>(_productionBox);
    _outwardEntries = await Hive.openBox<OutwardEntry>(_outwardBox);
  }

  // ── Inward CRUD ──────────────────────────────────────────────

  List<InwardEntry> getAllInward() => _inwardEntries.values.toList();

  Future<void> addInward(InwardEntry entry) async {
    await _inwardEntries.put(entry.id, entry);
  }

  Future<void> updateInward(InwardEntry entry) async {
    await _inwardEntries.put(entry.id, entry);
  }

  Future<void> deleteInward(String id) async {
    await _inwardEntries.delete(id);
  }

  // ── Production CRUD ──────────────────────────────────────────

  List<ProductionEntry> getAllProduction() =>
      _productionEntries.values.toList();

  Future<void> addProduction(ProductionEntry entry) async {
    await _productionEntries.put(entry.id, entry);
  }

  Future<void> updateProduction(ProductionEntry entry) async {
    await _productionEntries.put(entry.id, entry);
  }

  Future<void> deleteProduction(String id) async {
    await _productionEntries.delete(id);
  }

  // ── Outward CRUD ─────────────────────────────────────────────

  List<OutwardEntry> getAllOutward() => _outwardEntries.values.toList();

  Future<void> addOutward(OutwardEntry entry) async {
    await _outwardEntries.put(entry.id, entry);
  }

  Future<void> updateOutward(OutwardEntry entry) async {
    await _outwardEntries.put(entry.id, entry);
  }

  Future<void> deleteOutward(String id) async {
    await _outwardEntries.delete(id);
  }

  // ── Aggregation helpers ──────────────────────────────────────

  double get totalRawMaterialInStock {
    double total = 0;
    for (final e in _inwardEntries.values) {
      total += e.quantityReceived;
    }
    return total;
  }

  int get totalFinishedPieces {
    int total = 0;
    for (final e in _productionEntries.values) {
      total += e.piecesCompleted;
    }
    return total;
  }

  int get totalDispatched {
    int total = 0;
    for (final e in _outwardEntries.values) {
      total += e.totalPiecesSent;
    }
    return total;
  }

  Set<String> get allDesignNumbers {
    final designs = <String>{};
    for (final e in _inwardEntries.values) {
      if (e.designNumber.isNotEmpty) designs.add(e.designNumber);
    }
    for (final e in _productionEntries.values) {
      if (e.designNumber.isNotEmpty) designs.add(e.designNumber);
    }
    for (final e in _outwardEntries.values) {
      if (e.designNumber.isNotEmpty) designs.add(e.designNumber);
    }
    return designs;
  }

  // ── Search ───────────────────────────────────────────────────

  Map<String, List<dynamic>> searchByDesignNumber(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return {};

    final inward = _inwardEntries.values
        .where((e) => e.designNumber.toLowerCase().contains(q))
        .toList();
    final production = _productionEntries.values
        .where((e) => e.designNumber.toLowerCase().contains(q))
        .toList();
    final outward = _outwardEntries.values
        .where((e) => e.designNumber.toLowerCase().contains(q))
        .toList();

    return {'INWARD': inward, 'PRODUCTION': production, 'OUTWARD': outward};
  }
}
