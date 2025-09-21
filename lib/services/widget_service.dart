import '../models/express_info.dart';
import 'storage_service.dart';

// 小组件服务（简化版本，暂不支持实际小组件功能）
class WidgetService {
  // 初始化小组件
  static Future<void> initialize() async {
    // 简化版本，暂时不实现小组件功能
    print('小组件服务已初始化（简化版本）');
  }
  
  // 更新小组件数据
  static Future<void> updateWidget() async {
    try {
      final storageService = StorageService();
      final unpickedExpress = await storageService.getUnpickedExpressInfo();
      
      // 准备小组件数据
      final widgetData = _prepareWidgetData(unpickedExpress);
      
      print('小组件数据已准备: $widgetData');
      // 在实际实现中，这里会更新iOS小组件
    } catch (e) {
      print('更新小组件失败: $e');
    }
  }
  
  // 准备小组件显示的数据
  static String _prepareWidgetData(List<ExpressInfo> expressList) {
    if (expressList.isEmpty) {
      return '暂无待取快递';
    }
    
    // 取最新的3个快递信息
    final displayList = expressList.take(3).toList();
    final StringBuffer buffer = StringBuffer();
    
    for (int i = 0; i < displayList.length; i++) {
      final express = displayList[i];
      buffer.write('${express.courierCompany}\n');
      buffer.write('取件码: ${express.pickupCode}\n');
      buffer.write('${express.stationName}\n');
      
      if (i < displayList.length - 1) {
        buffer.write('\n---\n');
      }
    }
    
    if (expressList.length > 3) {
      buffer.write('\n还有${expressList.length - 3}个待取快递...');
    }
    
    return buffer.toString();
  }
  
  // 获取小组件点击回调
  static Future<void> handleWidgetClick(String? action) async {
    if (action == 'open_app') {
      print('小组件被点击，打开应用');
    }
  }
  
  // 清除小组件数据
  static Future<void> clearWidgetData() async {
    try {
      print('小组件数据已清除');
    } catch (e) {
      print('清除小组件数据失败: $e');
    }
  }
}