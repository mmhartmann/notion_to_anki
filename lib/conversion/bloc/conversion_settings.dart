import 'package:flutter_bloc/flutter_bloc.dart';

/// A cubit handling the [ConversionSettings].
class ConversionSettingsCubit extends Cubit<ConversionSettings> {
  ConversionSettingsCubit() : super(ConversionSettings());

  void changeSelectedFileOrFolderPath(String newPath) =>
      emit(state..selectedFileOrFolderPath = newPath);

  void changeRemovePropertiesTable(bool newState) => emit(state..removePropertiesTable = newState);

  void changeImageReplacementPaths(String newPaths) =>
      emit(state..imageReplacementPaths = newPaths);
}

/// Contains all necessary information needed to execute the conversion command.
class ConversionSettings {
  ConversionSettings({
    this.selectedFileOrFolderPath,
    this.removePropertiesTable = true,
    this.imageReplacementPaths = "",
  });

  /// A specific file or a folder containing the files to be converted.
  String? selectedFileOrFolderPath;

  /// Whether to remove the notion "properties" table.
  bool removePropertiesTable;

  /// A list of paths names that should replace the image names of the exported
  /// notion html separated by '\n'.
  String imageReplacementPaths;
}
