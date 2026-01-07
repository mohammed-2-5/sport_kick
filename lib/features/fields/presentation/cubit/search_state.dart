import 'package:equatable/equatable.dart';

/// Base state for search feature.
sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Initial search state.
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// Search history loaded state.
class SearchHistoryLoaded extends SearchState {
  final List<String> history;

  const SearchHistoryLoaded({required this.history});

  @override
  List<Object?> get props => [history];

  bool get isEmpty => history.isEmpty;
}

/// Search is being performed.
class SearchInProgress extends SearchState {
  const SearchInProgress();
}

/// Search history updated (after add/remove).
class SearchHistoryUpdated extends SearchState {
  final List<String> history;

  const SearchHistoryUpdated({required this.history});

  @override
  List<Object?> get props => [history];
}

/// Error state.
class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}
