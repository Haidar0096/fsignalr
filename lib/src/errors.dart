/// Error thrown when an unknown hub ID is provided to a method channel API.
class UnknownHubIDError extends Error {
  /// Creates an assertion error with the provided [hubId] and optional
  /// [message].
  UnknownHubIDError(this.hubId, [this.message]);

  /// The unknown ID.
  final int hubId;

  /// Message describing the assertion error.
  final Object? message;

  @override
  String toString() {
    if (message != null) {
      return 'Unknown hub ID $hubId: ${Error.safeToString(message)}';
    }
    return 'Unknown hub ID $hubId';
  }
}

/// Error thrown when a duplicate hub ID is provided to a method channel API.
class DuplicateHubIDError extends Error {
  /// Creates an assertion error with the provided [hubId] and optional
  /// [message].
  DuplicateHubIDError(this.hubId, [this.message]);

  /// The duplicate ID.
  final int hubId;

  /// Message describing the assertion error.
  final Object? message;

  @override
  String toString() {
    if (message != null) {
      return 'Duplicate hub ID $hubId: ${Error.safeToString(message)}';
    }
    return 'Duplicate hub ID $hubId';
  }
}
