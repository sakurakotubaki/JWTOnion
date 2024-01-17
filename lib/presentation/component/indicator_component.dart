import 'package:flutter/material.dart';

/// [インジケーターを表示するコンポーネント]
class IndicatorComponent extends StatelessWidget {
  const IndicatorComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: CircularProgressIndicator(
          color: Colors.orangeAccent,
          backgroundColor: Colors.blueGrey,
        ),
      ),
    );
  }
}
