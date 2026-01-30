import 'package:flutter/material.dart';

/// Widget hiển thị khi không có kết nối mạng
/// 
/// Widget này rất quan trọng để Apple approve app!
/// Apple yêu cầu app phải xử lý tốt trường hợp offline
class OfflineWidget extends StatelessWidget {
  /// Callback khi người dùng nhấn nút "Thử lại"
  final VoidCallback? onRetry;

  const OfflineWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon offline
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 64,
                  color: Colors.grey[400],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Tiêu đề
              const Text(
                'Không có kết nối mạng',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Mô tả
              Text(
                'Vui lòng kiểm tra kết nối WiFi hoặc dữ liệu di động của bạn và thử lại',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Nút thử lại
              if (onRetry != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
