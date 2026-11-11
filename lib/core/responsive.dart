import 'package:flutter/material.dart';

/// Helper utility untuk menangani layout responsif (Compact vs Wide/Expanded)
/// sesuai spesifikasi penilaian UTS Mobile Programming.
class Responsive extends StatelessWidget {
  final Widget compact;
  final Widget wide;

  const Responsive({
    super.key,
    required this.compact,
    required this.wide,
  });

  // Breakpoint 600dp (standar Material Design untuk tablet/landscape/desktop)
  static const double breakpointWide = 600;

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < breakpointWide;

  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= breakpointWide;

  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= breakpointWide) {
          return wide;
        }
        return compact;
      },
    );
  }
}
