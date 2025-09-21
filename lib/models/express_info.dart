// 快递信息模型
class ExpressInfo {
  final String id;
  final String pickupCode;
  final String stationName;
  final String stationAddress;
  final String courierCompany;
  final DateTime receivedTime;
  final bool isPickedUp;
  final String? phoneNumber;
  final String originalMessage;

  ExpressInfo({
    required this.id,
    required this.pickupCode,
    required this.stationName,
    required this.stationAddress,
    required this.courierCompany,
    required this.receivedTime,
    this.isPickedUp = false,
    this.phoneNumber,
    required this.originalMessage,
  });

  // 从JSON创建对象
  factory ExpressInfo.fromJson(Map<String, dynamic> json) {
    return ExpressInfo(
      id: json['id'],
      pickupCode: json['pickupCode'],
      stationName: json['stationName'],
      stationAddress: json['stationAddress'],
      courierCompany: json['courierCompany'],
      receivedTime: DateTime.parse(json['receivedTime']),
      isPickedUp: json['isPickedUp'] ?? false,
      phoneNumber: json['phoneNumber'],
      originalMessage: json['originalMessage'],
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pickupCode': pickupCode,
      'stationName': stationName,
      'stationAddress': stationAddress,
      'courierCompany': courierCompany,
      'receivedTime': receivedTime.toIso8601String(),
      'isPickedUp': isPickedUp,
      'phoneNumber': phoneNumber,
      'originalMessage': originalMessage,
    };
  }

  // 复制并修改
  ExpressInfo copyWith({
    String? id,
    String? pickupCode,
    String? stationName,
    String? stationAddress,
    String? courierCompany,
    DateTime? receivedTime,
    bool? isPickedUp,
    String? phoneNumber,
    String? originalMessage,
  }) {
    return ExpressInfo(
      id: id ?? this.id,
      pickupCode: pickupCode ?? this.pickupCode,
      stationName: stationName ?? this.stationName,
      stationAddress: stationAddress ?? this.stationAddress,
      courierCompany: courierCompany ?? this.courierCompany,
      receivedTime: receivedTime ?? this.receivedTime,
      isPickedUp: isPickedUp ?? this.isPickedUp,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      originalMessage: originalMessage ?? this.originalMessage,
    );
  }
}