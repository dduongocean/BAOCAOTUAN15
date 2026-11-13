import 'package:flutter/material.dart';

// Minh họa 2 giới hạn của quản lý State cục bộ (setState):
// 1.Prop Drilling: Cha phải truyền biến và hàm callback xuống từng Widget con.
// 2.Rebuild dư thừa: Khi Cha gọi setState(), các Widget con không liên quan cũng bị build() lại.
class LocalStateLimitDemo extends StatefulWidget {
  const LocalStateLimitDemo({super.key});

  @override
  State<LocalStateLimitDemo> createState() => _LocalStateLimitDemoState();
}

class _LocalStateLimitDemoState extends State<LocalStateLimitDemo> {
  int _counter = 0;
  int _parentBuildCount = 0;

  @override
  void initState() {
    super.initState();
    UnrelatedChild.buildCount = 0;
  }

  void _increase() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    _parentBuildCount++;
    debugPrint('Cha (Parent) bị rebuild (Lần $_parentBuildCount)');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Cha giữ State (build lần $_parentBuildCount) → phải truyền xuống Con:',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Con 1: Phải nhận dữ liệu từ Cha truyền xuống (Prop Drilling)
          ChildDisplay(value: _counter),
          const SizedBox(height: 16),

          // Con 2: Phải nhận hàm callback từ Cha truyền xuống để bấm
          ChildButton(onAdd: _increase),
          const SizedBox(height: 28),

          // Con 3: Không dùng biến _counter nhưng vẫn bị build lại khi Cha setState (do không dùng const)
          UnrelatedChild(),
        ],
      ),
    );
  }
}

class ChildDisplay extends StatelessWidget {
  final int value;
  const ChildDisplay({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    debugPrint('Con 1 (Hiển thị) bị rebuild');
    return Text(
      'Con 1 nhận dữ liệu từ Cha: $value',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class ChildButton extends StatelessWidget {
  final VoidCallback onAdd;
  const ChildButton({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    debugPrint('Con 2 (Nút bấm) bị rebuild');
    return ElevatedButton(
      onPressed: onAdd,
      child: const Text('Con 2: Gọi hàm của Cha (+1)'),
    );
  }
}

class UnrelatedChild extends StatelessWidget {
  static int buildCount = 0;

  // Cố tình bỏ const để thấy Widget này bị build() lại mỗi lần Cha gọi setState
  // ignore: prefer_const_constructors_in_immutables
  UnrelatedChild({super.key});

  @override
  Widget build(BuildContext context) {
    buildCount++;
    debugPrint('Con 3 (Không liên quan) cũng bị rebuild dư thừa! (Lần $buildCount)');
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade200,
      child: Text(
        'Con 3 (Không liên quan tới số đếm)\nvẫn bị gọi lại hàm build() dư thừa: $buildCount lần',
        textAlign: TextAlign.center,
      ),
    );
  }
}
