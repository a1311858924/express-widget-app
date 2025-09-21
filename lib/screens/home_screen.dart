import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/express_provider.dart';
import '../widgets/express_card.dart';
import 'add_express_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // 初始化应用
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpressProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('快递取件码助手'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ExpressProvider>().refresh();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '待取快递', icon: Icon(Icons.local_shipping)),
            Tab(text: '全部快递', icon: Icon(Icons.list)),
          ],
        ),
      ),
      body: Consumer<ExpressProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.refresh();
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildExpressList(provider.unpickedExpress, provider, true),
              _buildExpressList(provider.expressList, provider, false),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddExpressScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildExpressList(List expressList, ExpressProvider provider, bool isUnpickedOnly) {
    if (expressList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUnpickedOnly ? Icons.check_circle_outline : Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isUnpickedOnly ? '暂无待取快递' : '暂无快递记录',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isUnpickedOnly 
                  ? '点击右下角按钮添加快递信息'
                  : '开始使用应用来管理您的快递',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await provider.refresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: expressList.length,
        itemBuilder: (context, index) {
          return ExpressCard(
            expressInfo: expressList[index],
            onMarkAsPickedUp: (id) async {
              final success = await provider.markAsPickedUp(id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已标记为已取件')),
                );
              }
            },
            onDelete: (id) async {
              final confirmed = await _showDeleteConfirmDialog();
              if (confirmed == true) {
                final success = await provider.deleteExpressInfo(id);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已删除快递信息')),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }

  Future<bool?> _showDeleteConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这条快递信息吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}