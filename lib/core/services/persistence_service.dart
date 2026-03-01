import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class PersistenceService {
  static final PersistenceService _instance = PersistenceService._internal();
  factory PersistenceService() => _instance;
  PersistenceService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static const String _gameCountKey = 'game_played_count';
  static const String _deviceIdKey = 'device_unique_id';

  Future<int> getGameCount() async {
    final value = await _storage.read(key: _gameCountKey);
    return int.tryParse(value ?? '0') ?? 0;
  }

  Future<void> incrementGameCount() async {
    final current = await getGameCount();
    await _storage.write(key: _gameCountKey, value: (current + 1).toString());
  }

  Future<String?> getDeviceUniqueId() async {
    // Try to get from storage first
    String? id = await _storage.read(key: _deviceIdKey);
    if (id != null) return id;

    // If not in storage, get from device
    if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      id = iosInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      id = androidInfo.id; // androidId
    }

    if (id != null) {
      await _storage.write(key: _deviceIdKey, value: id);
    }
    return id;
  }

  // This is a "hard" check. In a real app with a backend,
  // you would send the device ID to the server to check the play count.
  // For now, we rely on the Keychain (iOS) which survives app deletion.
  Future<bool> canPlayFreeGame() async {
    final count = await getGameCount();
    return count < 1;
  }
}
