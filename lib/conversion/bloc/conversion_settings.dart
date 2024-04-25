import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A cubit handling the [ConversionSettingsState].
class ConversionSettingsCubit extends Cubit<ConversionSettingsState> {
  ConversionSettingsCubit() : super(const ConversionSettingsState());

  void changeFileSelection(FilePickerResult newSelection) =>
      emit(state.copyWith(fileSelection: newSelection));

  void changeRemovePropertiesTable(bool newState) =>
      emit(state.copyWith(removePropertiesTable: newState));

  void changeImageReplacementPaths(String newPaths) =>
      emit(state.copyWith(imageReplacementPaths: newPaths));
}

/// Contains all necessary information needed to execute the conversion command.
class ConversionSettingsState extends Equatable {
  const ConversionSettingsState({
    this.fileSelection,
    this.removePropertiesTable = true,
    this.imageReplacementPaths = "",
  });

  /// Selected single or multiple files or a folders containing the files to be
  /// converted.
  final FilePickerResult? fileSelection;

  /// Whether to remove the notion "properties" table.
  final bool removePropertiesTable;

  /// A list of paths names that should replace the image names of the exported
  /// notion html separated by '\n'.
  final String imageReplacementPaths;

  ConversionSettingsState copyWith({
    FilePickerResult? fileSelection,
    bool? removePropertiesTable,
    String? imageReplacementPaths,
  }) =>
      ConversionSettingsState(
        fileSelection: fileSelection ?? this.fileSelection,
        removePropertiesTable: removePropertiesTable ?? this.removePropertiesTable,
        imageReplacementPaths: imageReplacementPaths ?? this.imageReplacementPaths,
      );

  @override
  List<Object?> get props => [fileSelection, removePropertiesTable, imageReplacementPaths];
}
