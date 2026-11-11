import 'package:flutter/material.dart';

// 1. StatelessWidget: Chỉ hiển thị tĩnh, không có State nội tại
class StaticHeader extends StatelessWidget {
  const StaticHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Đây là StatelessWidget (Giao diện tĩnh)',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

// 2. StatefulWidget: Bật/tắt widget con để quan sát trọn vẹn vòng đời
class StateLifecycleDemo extends StatefulWidget {
  const StateLifecycleDemo({super.key});

  @override
  State<StateLifecycleDemo> createState() => _StateLifecycleDemoState();
}

class _StateLifecycleDemoState extends State<StateLifecycleDemo> {
  bool _showCounter = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const StaticHeader(),
          const SizedBox(height: 20),
          if (_showCounter)
            const _CounterLifecycleBox()
          else
            const Text(
              'Widget đã bị hủy → dispose() vừa được gọi!\n(Bấm nút dưới để tạo lại từ initState)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _showCounter = !_showCounter;
              });
            },
            child: Text(
              _showCounter
                  ? 'Hủy Widget (test dispose)'
                  : 'Tạo lại Widget (test initState)',
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterLifecycleBox extends StatefulWidget {
  const _CounterLifecycleBox();

  @override
  State<_CounterLifecycleBox> createState() => _CounterLifecycleBoxState();
}

class _CounterLifecycleBoxState extends State<_CounterLifecycleBox> {
  int _count = 0;
  int _buildCount = 0;

  @override
  void initState() {
    super.initState();
    // Chạy đúng 1 lần duy nhất khi State được tạo
    debugPrint('1. initState() được gọi');
  }

  @override
  void dispose() {
    // Chạy khi widget bị hủy khỏi cây giao diện
    debugPrint('3. dispose() được gọi');
    super.dispose();
  }

  void _increment() {
    setState(() {
      _count++; // Thay đổi dữ liệu -> đánh dấu cần build() lại
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    debugPrint('2. build() được gọi (Lần $_buildCount)');

    return Column(
      children: [
        Text(
          'Giá trị State hiện tại: $_count',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Vòng đời: initState() (1 lần) → build() (lần $_buildCount)',
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _increment,
          child: const Text('Bấm để gọi setState() (+1)'),
        ),
      ],
    );
  }
}
