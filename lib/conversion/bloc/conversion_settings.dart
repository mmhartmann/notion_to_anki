import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A cubit handling the [ConversionSettingsState].
class ConversionSettingsCubit extends Cubit<ConversionSettingsState> {
  ConversionSettingsCubit() : super(ConversionSettingsState());

  void changeFileSelection(FilePickerResult newSelection) =>
      emit(state..fileSelection = newSelection);

  void changeRemovePropertiesTable(bool newState) => emit(state..removePropertiesTable = newState);

  void changeImageReplacementPaths(String newPaths) =>
      emit(state..imageReplacementPaths = newPaths);
}

/// Contains all necessary information needed to execute the conversion command.
class ConversionSettingsState {
  ConversionSettingsState({
    this.fileSelection,
    this.removePropertiesTable = true,
    this.imageReplacementPaths = "",
  });

  /// Selected single or multiple files or a folders containing the files to be
  /// converted.
  FilePickerResult? fileSelection;

  /// Whether to remove the notion "properties" table.
  bool removePropertiesTable;

  /// A list of paths names that should replace the image names of the exported
  /// notion html separated by '\n'.
  String imageReplacementPaths;
}
