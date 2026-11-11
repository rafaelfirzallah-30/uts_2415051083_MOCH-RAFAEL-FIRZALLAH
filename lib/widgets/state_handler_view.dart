import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Reusable Widget untuk menangani 3 status wajib aplikasi sesuai rubrik UTS:
/// 1. Loading State
/// 2. Error State (Network, Database, dsb.) dengan tombol Coba Lagi
/// 3. Empty State dengan pesan informatif & tombol aksi
class StateHandlerView extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final bool isEmpty;
  final Widget child;
  final VoidCallback? onRetry;
  final String loadingMessage;
  final String emptyTitle;
  final String emptyMessage;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyAction;

  const StateHandlerView({
    super.key,
    required this.isLoading,
    this.errorMessage,
    required this.isEmpty,
    required this.child,
    this.onRetry,
    this.loadingMessage = 'Memuat data...',
    this.emptyTitle = 'Data Masih Kosong',
    this.emptyMessage = 'Belum ada data yang dapat ditampilkan.',
    this.emptyActionLabel,
    this.onEmptyAction,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Loading State
    if (isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 44,
                height: 44,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                loadingMessage,
                style: const TextStyle(
                  color: AppTheme.lightText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 2. Error State
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red.shade600,
                  size: 52,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Terjadi Kendala',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.lightText,
                  height: 1.4,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Coba Lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // 3. Empty State
    if (isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_empty_rounded,
                  color: AppTheme.primaryBlue,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                emptyTitle,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.lightText,
                ),
              ),
              if (emptyActionLabel != null && onEmptyAction != null) ...[
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: onEmptyAction,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(emptyActionLabel!),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlue,
                    side: const BorderSide(color: AppTheme.primaryBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // 4. Data Content
    return child;
  }
}
