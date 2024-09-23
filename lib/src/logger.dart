import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class Logger {
  static const int logRetentionDays = 30;
  static Directory? _logDirectory;

  // Lấy thư mục log
  static Future<Directory> _getLogDirectory() async {
    if (_logDirectory == null) {
      _logDirectory = await getApplicationDocumentsDirectory();
    }
    return _logDirectory!;
  }

  // Lấy đường dẫn file log theo ngày
  static Future<File> _getLogFile() async {
    final logDirectory = await _getLogDirectory();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String fileName = 'log_$formattedDate.txt';
    final String filePath = '${logDirectory.path}/$fileName';
    final File logFile = File(filePath);

    // Tạo file nếu chưa tồn tại
    if (!await logFile.exists()) {
      await logFile.create();
    }
    return logFile;
  }

  // Ghi log vào file
  static Future<void> log(String message) async {
    final File logFile = await _getLogFile();
    final String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    await logFile.writeAsString('[$timestamp] $message\n', mode: FileMode.append);

    // Kiểm tra và xóa file log cũ quá 30 ngày
    await _deleteOldLogs();
  }

  // Xóa các file log cũ hơn 30 ngày
  static Future<void> _deleteOldLogs() async {
    final logDirectory = await _getLogDirectory();
    final List<FileSystemEntity> files = logDirectory.listSync();

    final DateTime now = DateTime.now();
    final DateTime retentionThreshold = now.subtract(Duration(days: logRetentionDays));

    for (final FileSystemEntity entity in files) {
      if (entity is File) {
        final String fileName = entity.path.split('/').last;

        // Kiểm tra file log theo định dạng 'log_yyyy-MM-dd.txt'
        if (fileName.startsWith('log_') && fileName.endsWith('.txt')) {
          final String datePart = fileName.substring(4, 14); // 'yyyy-MM-dd'
          final DateTime fileDate = DateFormat('yyyy-MM-dd').parse(datePart);

          // Nếu file quá 30 ngày thì xóa
          if (fileDate.isBefore(retentionThreshold)) {
            await entity.delete();
          }
        }
      }
    }
  }

  // Lấy danh sách tất cả các file log
  static Future<List<File>> getAllLogFiles() async {
    final logDirectory = await _getLogDirectory();
    final List<FileSystemEntity> files = logDirectory.listSync();

    List<File> logFiles = [];

    for (final FileSystemEntity entity in files) {
      if (entity is File) {
        final String fileName = entity.path.split('/').last;

        // Kiểm tra file log theo định dạng 'log_yyyy-MM-dd.txt'
        if (fileName.startsWith('log_') && fileName.endsWith('.txt')) {
          logFiles.add(entity);
        }
      }
    }
    return logFiles;
  }
}