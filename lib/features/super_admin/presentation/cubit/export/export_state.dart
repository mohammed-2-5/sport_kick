import 'package:equatable/equatable.dart';

/// Base state for export operations.
sealed class ExportState extends Equatable {
  const ExportState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class ExportInitial extends ExportState {
  const ExportInitial();
}

/// Loading state with optional message.
class ExportLoading extends ExportState {
  final String message;

  const ExportLoading({this.message = 'Exporting...'});

  @override
  List<Object?> get props => [message];
}

/// Export completed successfully.
class ExportSuccess extends ExportState {
  final String message;

  const ExportSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Error state with error message.
class ExportError extends ExportState {
  final String message;

  const ExportError(this.message);

  @override
  List<Object?> get props => [message];
}
