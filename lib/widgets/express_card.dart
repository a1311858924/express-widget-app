import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/express_info.dart';

class ExpressCard extends StatelessWidget {
  final ExpressInfo expressInfo;
  final Function(String) onMarkAsPickedUp;
  final Function(String) onDelete;

  const ExpressCard({
    super.key,
    required this.expressInfo,
    required this.onMarkAsPickedUp,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部信息
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCompanyColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    expressInfo.courierCompany,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (expressInfo.isPickedUp)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '已取件',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            
            // 取件码
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.confirmation_number, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    '取件码：',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      expressInfo.pickupCode,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: expressInfo.pickupCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('取件码已复制到剪贴板')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // 驿站信息
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expressInfo.stationName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (expressInfo.stationAddress.isNotEmpty)
                        Text(
                          expressInfo.stationAddress,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // 时间信息
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Text(
                  '收到时间：${_formatDateTime(expressInfo.receivedTime)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 操作按钮
            Row(
              children: [
                if (!expressInfo.isPickedUp) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onMarkAsPickedUp(expressInfo.id),
                      icon: const Icon(Icons.check),
                      label: const Text('标记已取件'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => onDelete(expressInfo.id),
                    icon: const Icon(Icons.delete),
                    label: const Text('删除'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCompanyColor() {
    switch (expressInfo.courierCompany) {
      case '菜鸟驿站':
        return Colors.orange;
      case '丰巢':
        return Colors.green;
      case '京东快递':
        return Colors.red;
      case '顺丰速运':
        return Colors.yellow[700]!;
      case '中通快递':
        return Colors.blue;
      case '圆通速递':
        return Colors.purple;
      case '申通快递':
        return Colors.teal;
      case '韵达快递':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}