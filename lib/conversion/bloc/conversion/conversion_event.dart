import 'package:equatable/equatable.dart';

import '../../conversion.dart';

sealed class ConversionEvent extends Equatable {
  const ConversionEvent();
}

/// Start the conversion process given the settings specified by the user.
class StartConversionEvent extends ConversionEvent {
  const StartConversionEvent({required this.settings});

  final ConversionSettingsState settings;

  @override
  List<Object?> get props => [settings];
}
