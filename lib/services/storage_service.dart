import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/express_info.dart';

// 本地存储服务
class StorageService {
  static const String _keyExpressList = 'express_list';
  
  // 保存快递信息
  Future<bool> saveExpressInfo(ExpressInfo expressInfo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<ExpressInfo> currentList = await getAllExpressInfo();
      
      // 检查是否已存在相同的取件码
      final existingIndex = currentList.indexWhere(
        (item) => item.pickupCode == expressInfo.pickupCode && 
                  item.stationName == expressInfo.stationName,
      );
      
      if (existingIndex != -1) {
        // 更新现有记录
        currentList[existingIndex] = expressInfo;
      } else {
        // 添加新记录
        currentList.add(expressInfo);
      }
      
      // 按时间排序，最新的在前面
      currentList.sort((a, b) => b.receivedTime.compareTo(a.receivedTime));
      
      final String jsonString = jsonEncode(
        currentList.map((item) => item.toJson()).toList(),
      );
      
      return await prefs.setString(_keyExpressList, jsonString);
    } catch (e) {
      print('保存快递信息失败: $e');
      return false;
    }
  }
  
  // 获取所有快递信息
  Future<List<ExpressInfo>> getAllExpressInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_keyExpressList);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ExpressInfo.fromJson(json)).toList();
    } catch (e) {
      print('获取快递信息失败: $e');
      return [];
    }
  }
  
  // 获取未取件的快递信息
  Future<List<ExpressInfo>> getUnpickedExpressInfo() async {
    final allExpress = await getAllExpressInfo();
    return allExpress.where((item) => !item.isPickedUp).toList();
  }
  
  // 标记为已取件
  Future<bool> markAsPickedUp(String id) async {
    try {
      final List<ExpressInfo> currentList = await getAllExpressInfo();
      final index = currentList.indexWhere((item) => item.id == id);
      
      if (index != -1) {
        currentList[index] = currentList[index].copyWith(isPickedUp: true);
        
        final prefs = await SharedPreferences.getInstance();
        final String jsonString = jsonEncode(
          currentList.map((item) => item.toJson()).toList(),
        );
        
        return await prefs.setString(_keyExpressList, jsonString);
      }
      
      return false;
    } catch (e) {
      print('标记已取件失败: $e');
      return false;
    }
  }
  
  // 删除快递信息
  Future<bool> deleteExpressInfo(String id) async {
    try {
      final List<ExpressInfo> currentList = await getAllExpressInfo();
      currentList.removeWhere((item) => item.id == id);
      
      final prefs = await SharedPreferences.getInstance();
      final String jsonString = jsonEncode(
        currentList.map((item) => item.toJson()).toList(),
      );
      
      return await prefs.setString(_keyExpressList, jsonString);
    } catch (e) {
      print('删除快递信息失败: $e');
      return false;
    }
  }
  
  // 清空所有数据
  Future<bool> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_keyExpressList);
    } catch (e) {
      print('清空数据失败: $e');
      return false;
    }
  }
}