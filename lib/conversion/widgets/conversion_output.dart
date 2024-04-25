import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notion_to_anki/conversion/conversion.dart';
import 'package:notion_to_anki/l10n/l10n.dart';

/// Displays the state of the conversion.
class ConversionStateWidget extends StatelessWidget {
  const ConversionStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: BlocBuilder<ConversionBloc, ConversionState>(builder: (context, state) {
        return switch (state) {
          InitialConversionState() => const SizedBox(),
          RunningConversionState() => Text(context.l10n.convertingFilesDescription),
          FinishedConversionState() => ConversionResultsWidget(finishedConversionState: state),
        };
      }),
    );
  }
}

/// Displays the results of a finished conversion as a list of the converted files.
class ConversionResultsWidget extends StatelessWidget {
  const ConversionResultsWidget({super.key, required this.finishedConversionState});

  final FinishedConversionState finishedConversionState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.convertedFilesTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...(finishedConversionState.results.map((r) => ConvertedFileWidget(result: r)).toList())
      ],
    );
  }
}

/// List item that displays the filename of a converted file and has an option
/// to copy the contents of that file.
class ConvertedFileWidget extends StatefulWidget {
  const ConvertedFileWidget({super.key, required this.result});

  final FileConversionResult result;

  @override
  State<ConvertedFileWidget> createState() => _ConvertedFileWidgetState();
}

class _ConvertedFileWidgetState extends State<ConvertedFileWidget> {
  bool copied = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.result.title ?? widget.result.convertedFilePath.split("/").last,
            ),
          ),
          const SizedBox(width: 4),
          TextButton(
              onPressed: _onCopyPressed,
              child: Text(
                copied ? context.l10n.copyButtonTextAfterCopy : context.l10n.copyButtonText,
              )),
        ],
      ),
    );
  }

  void _onCopyPressed() async {
    final file = File(widget.result.convertedFilePath);
    if (await file.exists()) {
      Clipboard.setData(ClipboardData(text: await file.readAsString()));
      setState(() => copied = true);
    }
  }
}
