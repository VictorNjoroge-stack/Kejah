import 'package:flutter/material.dart';

class DashboardLoading extends StatelessWidget {
  const DashboardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        _LoadingBlock(height: 80),
        SizedBox(height: 24),

        Row(
          children: [
            Expanded(child: _LoadingBlock(height: 150)),
            SizedBox(width: 16),
            Expanded(child: _LoadingBlock(height: 150)),
          ],
        ),

        SizedBox(height: 16),

        Row(
          children: [
            Expanded(child: _LoadingBlock(height: 150)),
            SizedBox(width: 16),
            Expanded(child: _LoadingBlock(height: 150)),
          ],
        ),

        SizedBox(height: 24),

        _LoadingBlock(height: 220),

        SizedBox(height: 24),

        _LoadingBlock(height: 180),
      ],
    );
  }
}

class _LoadingBlock extends StatelessWidget {
  final double height;

  const _LoadingBlock({
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}