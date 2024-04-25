import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notion_to_anki/l10n/l10n.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../conversion.dart';

/// Settings overview at the top of the [ConversionView].
///
/// Every contained widget accesses the [ConversionSettingsCubit].
class ConversionSettingsWidget extends StatelessWidget {
  const ConversionSettingsWidget({super.key, required this.onConversionPressed});

  /// A callback function when the conversion button was pressed.
  final VoidCallback onConversionPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversionBloc, ConversionState>(builder: (context, state) {
      final enabled = state is! RunningConversionState;

      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SelectedFileOrFolderSettingWidget(enabled: enabled),
            const SizedBox(height: 20),
            RemovePropertiesTableSettingWidget(enabled: enabled),
            const SizedBox(height: 20),
            ImageReplacementPathSettingWidget(enabled: enabled),
            const SizedBox(height: 20),
            ConvertButtonWidget(
              enabled: enabled,
              onConversionPressed: onConversionPressed,
            ),
          ],
        ),
      );
    });
  }
}

/// Displays the selected files to convert and lets the user change it.
class SelectedFileOrFolderSettingWidget extends StatelessWidget {
  const SelectedFileOrFolderSettingWidget({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversionSettingsCubit, ConversionSettingsState>(
      builder: (context, state) => Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.selectFilesTitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (state.fileSelection != null) ...[
                Text(
                  context.l10n.numberOfFilesSelectedLabel(state.fileSelection!.count),
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ]
            ],
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton(
          onPressed:
              enabled ? () => _openFilesDialog(context.read<ConversionSettingsCubit>()) : null,
          child: Text(context.l10n.selectFilesButton),
        ),
      ]),
    );
  }

  Future<void> _openFilesDialog(ConversionSettingsCubit settingsCubit) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['html'],
    );

    if (result != null && result.count > 0) {
      settingsCubit.changeFileSelection(result);
    }
  }
}

class RemovePropertiesTableSettingWidget extends StatelessWidget {
  const RemovePropertiesTableSettingWidget({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversionSettingsCubit, ConversionSettingsState>(
      builder: (context, state) => Row(children: [
        Expanded(
          child: Text(
            context.l10n.removePropertiesTableTitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: state.removePropertiesTable,
          onChanged: !enabled
              ? null
              : (newValue) => _changeValue(
                    newValue,
                    context.read<ConversionSettingsCubit>(),
                  ),
        ),
      ]),
    );
  }

  void _changeValue(bool newValue, ConversionSettingsCubit settingsCubit) {
    settingsCubit.changeRemovePropertiesTable(newValue);
  }
}

/// Implements a textfield for the user to enter the image replacement paths.
class ImageReplacementPathSettingWidget extends StatelessWidget {
  const ImageReplacementPathSettingWidget({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(child: Text(context.l10n.imageReplacementPathsTitle)),
          IconButton(
            onPressed: () => _helpButtonPressed(context),
            icon: const Icon(Icons.info_outline, size: 16),
          ),
        ]),
        TextFormField(
          keyboardType: TextInputType.multiline,
          initialValue: context.read<ConversionSettingsCubit>().state.imageReplacementPaths,
          minLines: 2,
          maxLines: null,
          enabled: enabled,
          style: Theme.of(context).textTheme.bodyMedium,
          onChanged: (newString) => _onTextChanged(newString, context),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: const OutlineInputBorder(),
            labelText: context.l10n.imageReplacementPathsLabel,
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withAlpha(150),
                ),
          ),
        ),
      ],
    );
  }

  void _helpButtonPressed(BuildContext context) =>
      launchUrlString(context.l10n.imageReplacementPathsHelpUrl);

  void _onTextChanged(String newValue, BuildContext context) {
    context.read<ConversionSettingsCubit>().changeImageReplacementPaths(newValue);
  }
}

/// On press starts the conversion process
class ConvertButtonWidget extends StatelessWidget {
  const ConvertButtonWidget({
    super.key,
    required this.enabled,
    required this.onConversionPressed,
  });

  final bool enabled;
  final VoidCallback onConversionPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversionSettingsCubit, ConversionSettingsState>(
      builder: (context, state) {
        final enabled =
            state.fileSelection != null && state.fileSelection!.count > 0 && this.enabled;

        return FilledButton(
          onPressed: enabled ? onConversionPressed : null,
          child: Text(context.l10n.convertButton),
        );
      },
    );
  }
}
