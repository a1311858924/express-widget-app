import '../models/express_info.dart';

// 短信解析服务
class SmsParser {
  // 常见快递公司的短信模式
  static final List<ExpressPattern> _patterns = [
    // 菜鸟驿站
    ExpressPattern(
      company: '菜鸟驿站',
      pattern: r'您的快递已到达(.+?)，取件码：(\w+)',
      codeGroup: 2,
      stationGroup: 1,
    ),
    // 丰巢
    ExpressPattern(
      company: '丰巢',
      pattern: r'您的快递已存放在(.+?)，取件码：(\w+)',
      codeGroup: 2,
      stationGroup: 1,
    ),
    // 京东快递
    ExpressPattern(
      company: '京东快递',
      pattern: r'您的包裹已到达(.+?)，取件码：(\w+)',
      codeGroup: 2,
      stationGroup: 1,
    ),
    // 顺丰速运
    ExpressPattern(
      company: '顺丰速运',
      pattern: r'您的快递已到(.+?)，取件码：(\w+)',
      codeGroup: 2,
      stationGroup: 1,
    ),
    // 中通快递
    ExpressPattern(
      company: '中通快递',
      pattern: r'您的快递已到达(.+?)，取件码：(\w+)',
      codeGroup: 2,
      stationGroup: 1,
    ),
    // 圆通速递
    ExpressPattern(
      company: '圆通速递',
      pattern: r'您的快递已到(.+?)，取件码：(\w+)',
      codeGroup: 2,
      stationGroup: 1,
    ),
    // 申通快递
    ExpressPattern(
      company: '申通快递',
      pattern: r'您的快递已到达(.+?)，取件码：(\w+)',
      codeGroup: 2,
      stationGroup: 1,
    ),
    // 韵达快递
    ExpressPattern(
      company: '韵达快递',
      pattern: r'您的快递已到(.+?)，取件码：(\w+)',
      codeGroup: 2,
      stationGroup: 1,
    ),
    // 通用模式
    ExpressPattern(
      company: '快递',
      pattern: r'取件码[：:](\w+)',
      codeGroup: 1,
      stationGroup: 0,
    ),
  ];

  // 解析短信内容
  static ExpressInfo? parseMessage(String message, String? sender, DateTime receivedTime) {
    for (final pattern in _patterns) {
      final match = RegExp(pattern.pattern, caseSensitive: false).firstMatch(message);
      if (match != null) {
        final pickupCode = match.group(pattern.codeGroup) ?? '';
        final stationName = pattern.stationGroup > 0 
            ? (match.group(pattern.stationGroup) ?? '未知驿站')
            : _extractStationFromMessage(message);
        
        if (pickupCode.isNotEmpty) {
          return ExpressInfo(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            pickupCode: pickupCode,
            stationName: stationName,
            stationAddress: _extractAddressFromMessage(message),
            courierCompany: pattern.company,
            receivedTime: receivedTime,
            phoneNumber: sender,
            originalMessage: message,
          );
        }
      }
    }
    return null;
  }

  // 从消息中提取驿站名称
  static String _extractStationFromMessage(String message) {
    // 尝试提取常见的驿站关键词
    final stationPatterns = [
      r'(.+?驿站)',
      r'(.+?快递柜)',
      r'(.+?自提点)',
      r'(.+?代收点)',
    ];
    
    for (final pattern in stationPatterns) {
      final match = RegExp(pattern).firstMatch(message);
      if (match != null) {
        return match.group(1) ?? '未知驿站';
      }
    }
    return '未知驿站';
  }

  // 从消息中提取地址信息
  static String _extractAddressFromMessage(String message) {
    // 尝试提取地址信息
    final addressPatterns = [
      r'地址[：:](.+?)(?:[，。]|$)',
      r'位于(.+?)(?:[，。]|$)',
      r'在(.+?)(?:[，。]|$)',
    ];
    
    for (final pattern in addressPatterns) {
      final match = RegExp(pattern).firstMatch(message);
      if (match != null) {
        return match.group(1) ?? '';
      }
    }
    return '';
  }

  // 检查消息是否包含快递信息
  static bool isExpressMessage(String message) {
    final keywords = ['取件码', '快递', '包裹', '驿站', '快递柜', '自提'];
    return keywords.any((keyword) => message.contains(keyword));
  }
}

// 快递模式类
class ExpressPattern {
  final String company;
  final String pattern;
  final int codeGroup;
  final int stationGroup;

  ExpressPattern({
    required this.company,
    required this.pattern,
    required this.codeGroup,
    required this.stationGroup,
  });
}