import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notion_to_anki/l10n/l10n.dart';

import '../conversion.dart';

/// Settings overview at the top of the [ConversionView].
///
/// Every contained widget accesses the [ConversionSettingsCubit].
class ConversionSettingsWidget extends StatelessWidget {
  const ConversionSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          SelectedFileOrFolderSettingWidget(),
          SizedBox(height: 20),
          RemovePropertiesTableSettingWidget(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Displays the selected files to convert and lets the user change it.
class SelectedFileOrFolderSettingWidget extends StatelessWidget {
  const SelectedFileOrFolderSettingWidget({super.key});

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
          onPressed: () => _openFilesDialog(context.read<ConversionSettingsCubit>()),
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

///
class RemovePropertiesTableSettingWidget extends StatelessWidget {
  const RemovePropertiesTableSettingWidget({super.key});

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
          onChanged: (newValue) => _changeValue(
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
