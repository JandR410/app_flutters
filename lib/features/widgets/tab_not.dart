import 'package:flutter/material.dart';
import 'package:ordencompra/utils/theme/theme.dart';

class TabNot extends StatelessWidget {
  final String title;

  const TabNot({
    super.key,
    required this.title, required style,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}