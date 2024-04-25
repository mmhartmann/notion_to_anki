import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notion_to_anki/conversion/bloc/conversion/conversion_repository.dart';

import 'conversion_event.dart';
import 'conversion_state.dart';

/// A bloc that handles all actions for file conversions.
class ConversionBloc extends Bloc<ConversionEvent, ConversionState> {
  ConversionBloc() : super(InitialConversionState()) {
    on<ConversionEvent>((event, emit) async {
      switch (event) {
        case StartConversionEvent():
          await convertAllFiles(event, emit);
          break;
      }
    });
  }

  /// Converts all the selected files in the [event.settings].
  Future convertAllFiles(StartConversionEvent event, Emitter<ConversionState> emit) async {
    emit(RunningConversionState());

    final imageReplacementPathsList = event.settings.imageReplacementPaths.split("\n");
    final filePaths = event.settings.fileSelection!.files.map((e) => e.path);

    final filesToConvert = filePaths.map((path) => ConversionFile(
          path: path!,
          removePropertiesTable: event.settings.removePropertiesTable,
          imageReplacementPathsList: imageReplacementPathsList,
        ));
    final conversionFilesIterator = filesToConvert.iterator;

    List<FileConversionResult> results = [];

    while (conversionFilesIterator.moveNext()) {
      final file = conversionFilesIterator.current;
      final result = await file.convert();
      if (result != null) {
        results.add(result);
      }
    }

    emit(FinishedConversionState(results: results));
  }
}
