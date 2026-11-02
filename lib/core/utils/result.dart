/// Generic Result type to avoid throwing exceptions across layers.
sealed class Result<T> {
  const Result();

  /// Whether this result is a success.
  bool get isSuccess => this is Success<T>;

  /// Whether this result is a failure.
  bool get isFailure => this is Failure<T>;

  /// Returns value if success, null otherwise.
  T? get dataOrNull => switch (this) {
    Success<T>(data: final data) => data,
    Failure<T>() => null,
  };
}

/// Represents a successful operation containing [data].
final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

/// Represents a failed operation containing [message] and optional [error].
final class Failure<T> extends Result<T> {
  const Failure(this.message, [this.error]);

  final String message;
  final Object? error;
}

