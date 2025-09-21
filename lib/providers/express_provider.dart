import 'package:flutter/foundation.dart';
import '../models/express_info.dart';
import '../services/sms_service.dart';
import '../services/widget_service.dart';

// 快递信息状态管理
class ExpressProvider with ChangeNotifier {
  final SmsService _smsService = SmsService();
  List<ExpressInfo> _expressList = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _smsPermissionGranted = false;

  // Getters
  List<ExpressInfo> get expressList => _expressList;
  List<ExpressInfo> get unpickedExpress => 
      _expressList.where((item) => !item.isPickedUp).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get smsPermissionGranted => _smsPermissionGranted;

  // 初始化
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // 初始化短信服务
      _smsPermissionGranted = await _smsService.initialize();
      
      // 初始化小组件
      await WidgetService.initialize();
      
      // 加载快递信息
      await loadExpressInfo();
      
      _clearError();
    } catch (e) {
      _setError('初始化失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 加载快递信息
  Future<void> loadExpressInfo() async {
    try {
      _expressList = await _smsService.getAllExpressInfo();
      await _updateWidget();
      notifyListeners();
    } catch (e) {
      _setError('加载快递信息失败: $e');
    }
  }

  // 手动添加快递信息
  Future<bool> addExpressManually({
    required String pickupCode,
    required String stationName,
    String? stationAddress,
    String? courierCompany,
  }) async {
    try {
      final success = await _smsService.addExpressManually(
        pickupCode: pickupCode,
        stationName: stationName,
        stationAddress: stationAddress,
        courierCompany: courierCompany,
      );

      if (success) {
        await loadExpressInfo();
        return true;
      }
      return false;
    } catch (e) {
      _setError('添加快递信息失败: $e');
      return false;
    }
  }

  // 标记为已取件
  Future<bool> markAsPickedUp(String id) async {
    try {
      final success = await _smsService.markAsPickedUp(id);
      if (success) {
        await loadExpressInfo();
        return true;
      }
      return false;
    } catch (e) {
      _setError('标记已取件失败: $e');
      return false;
    }
  }

  // 删除快递信息
  Future<bool> deleteExpressInfo(String id) async {
    try {
      final success = await _smsService.deleteExpressInfo(id);
      if (success) {
        await loadExpressInfo();
        return true;
      }
      return false;
    } catch (e) {
      _setError('删除快递信息失败: $e');
      return false;
    }
  }

  // 刷新数据
  Future<void> refresh() async {
    await loadExpressInfo();
  }

  // 更新小组件
  Future<void> _updateWidget() async {
    try {
      await WidgetService.updateWidget();
    } catch (e) {
      print('更新小组件失败: $e');
    }
  }

  // 设置加载状态
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // 设置错误信息
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  // 清除错误信息
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _smsService.dispose();
    super.dispose();
  }
}