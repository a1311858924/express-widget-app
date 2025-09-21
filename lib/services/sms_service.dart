import 'dart:async';
import '../models/express_info.dart';
import 'storage_service.dart';

// 短信服务类
class SmsService {
  static final SmsService _instance = SmsService._internal();
  factory SmsService() => _instance;
  SmsService._internal();

  final StorageService _storage = StorageService();

  // 初始化短信监听
  Future<bool> initialize() async {
    // 由于短信读取在iOS上不可用，我们主要依赖手动输入
    // 在Android上也简化处理，避免复杂的权限问题
    return true;
  }

  // 手动添加快递信息（用于iOS）
  Future<bool> addExpressManually({
    required String pickupCode,
    required String stationName,
    String? stationAddress,
    String? courierCompany,
  }) async {
    final expressInfo = ExpressInfo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pickupCode: pickupCode,
      stationName: stationName,
      stationAddress: stationAddress ?? '',
      courierCompany: courierCompany ?? '手动添加',
      receivedTime: DateTime.now(),
      originalMessage: '手动添加的快递信息',
    );

    return await _storage.saveExpressInfo(expressInfo);
  }

  // 停止监听
  void dispose() {
    // 简化版本，无需处理
  }

  // 获取所有快递信息
  Future<List<ExpressInfo>> getAllExpressInfo() async {
    return await _storage.getAllExpressInfo();
  }

  // 标记为已取件
  Future<bool> markAsPickedUp(String id) async {
    return await _storage.markAsPickedUp(id);
  }

  // 删除快递信息
  Future<bool> deleteExpressInfo(String id) async {
    return await _storage.deleteExpressInfo(id);
  }
}