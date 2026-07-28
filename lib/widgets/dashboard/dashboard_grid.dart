import 'package:flutter/material.dart';

import 'dashboard_breakpoints.dart';

class DashboardGrid extends StatelessWidget {
  final List<Widget> children;

  const DashboardGrid({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final columns = DashboardBreakpoints.gridColumns(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: children.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: columns == 1 ? 1.25 : 1.15,
          ),
          itemBuilder: (context, index) {
            return children[index];
          },
        );
      },
    );
  }
}