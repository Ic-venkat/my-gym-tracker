import 'package:drift/drift.dart';

/// Fallback connection when platform is unsupported.
QueryExecutor openConnection() {
  throw UnsupportedError('No database connection implementation available.');
}

