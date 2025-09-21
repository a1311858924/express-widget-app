import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/express_provider.dart';

class AddExpressScreen extends StatefulWidget {
  const AddExpressScreen({super.key});

  @override
  State<AddExpressScreen> createState() => _AddExpressScreenState();
}

class _AddExpressScreenState extends State<AddExpressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupCodeController = TextEditingController();
  final _stationNameController = TextEditingController();
  final _stationAddressController = TextEditingController();
  String _selectedCompany = '菜鸟驿站';
  bool _isLoading = false;

  final List<String> _companies = [
    '菜鸟驿站',
    '丰巢',
    '京东快递',
    '顺丰速运',
    '中通快递',
    '圆通速递',
    '申通快递',
    '韵达快递',
    '其他',
  ];

  @override
  void dispose() {
    _pickupCodeController.dispose();
    _stationNameController.dispose();
    _stationAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加快递信息'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 说明文字
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue[600]),
                      const SizedBox(width: 8),
                      const Text(
                        '手动添加快递信息',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '在iOS设备上，由于系统限制无法自动读取短信。您可以手动输入快递信息来管理您的取件码。',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 快递公司选择
            DropdownButtonFormField<String>(
              value: _selectedCompany,
              decoration: const InputDecoration(
                labelText: '快递公司',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              items: _companies.map((company) {
                return DropdownMenuItem(
                  value: company,
                  child: Text(company),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCompany = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // 取件码输入
            TextFormField(
              controller: _pickupCodeController,
              decoration: const InputDecoration(
                labelText: '取件码',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.confirmation_number),
                hintText: '请输入取件码',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入取件码';
                }
                return null;
              },
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 16),

            // 驿站名称输入
            TextFormField(
              controller: _stationNameController,
              decoration: const InputDecoration(
                labelText: '驿站名称',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
                hintText: '请输入驿站名称',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入驿站名称';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 驿站地址输入（可选）
            TextFormField(
              controller: _stationAddressController,
              decoration: const InputDecoration(
                labelText: '驿站地址（可选）',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.place),
                hintText: '请输入驿站详细地址',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 32),

            // 添加按钮
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _addExpress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        '添加快递信息',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addExpress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = context.read<ExpressProvider>();
      final success = await provider.addExpressManually(
        pickupCode: _pickupCodeController.text.trim(),
        stationName: _stationNameController.text.trim(),
        stationAddress: _stationAddressController.text.trim(),
        courierCompany: _selectedCompany,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('快递信息添加成功'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('添加失败，请重试'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('添加失败：$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}