import 'package:equatable/equatable.dart';

import 'conversion_repository.dart';

sealed class ConversionState extends Equatable {
  const ConversionState();
}

/// The state before any conversion was configured or run
class InitialConversionState extends ConversionState {
  @override
  List<Object?> get props => [];
}

class RunningConversionState extends ConversionState {
  @override
  List<Object?> get props => [];
}

class FinishedConversionState extends ConversionState {
  const FinishedConversionState({required this.results});

  /// List of the content of all converted files.
  final List<FileConversionResult> results;

  @override
  List<Object?> get props => [results];
}
