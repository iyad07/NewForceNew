import 'new_force_articles.dart';

/// A safer version of NewForceArticlesRow that handles null values for createdAt
class SafeNewForceArticlesRow extends NewForceArticlesRow {
  SafeNewForceArticlesRow(super.data);

  @override
  DateTime get createdAt {
    try {
      final value = getField<DateTime>('created_at');
      return value ?? DateTime.now();
    } catch (e) {
      print('Error accessing createdAt: $e');
      return DateTime.now();
    }
  }
}

/// Extension to convert NewForceArticlesRow to SafeNewForceArticlesRow
extension NewForceArticlesRowExtension on NewForceArticlesRow {
  SafeNewForceArticlesRow toSafe() {
    return SafeNewForceArticlesRow(data);
  }
}
