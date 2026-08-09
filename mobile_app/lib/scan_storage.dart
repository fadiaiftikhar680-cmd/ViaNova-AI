import 'package:shared_preferences/shared_preferences.dart';
import 'scan_model.dart';

class ScanStorage {
  static const _key = 'scan_history';

  static Future<void> saveScan(ScanResult scan) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_key);
    List<ScanResult> scans = existing != null ? ScanResult.decodeList(existing) : [];
    scans.insert(0, scan);
    await prefs.setString(_key, ScanResult.encodeList(scans));
  }

  static Future<List<ScanResult>> getScans() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];
    return ScanResult.decodeList(data);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<void> deleteScan(int index) async {
    final scans = await getScans();
    scans.removeAt(index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, ScanResult.encodeList(scans));
  }
}