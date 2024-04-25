import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';

/// Object that lazily handles the conversion of a file.
class ConversionFile extends Equatable {
  const ConversionFile({
    required this.path,
    required this.removePropertiesTable,
    required this.imageReplacementPathsList,
  });

  /// A path to the file that should be converted.
  final String path;

  /// see [ConversionSettingsState.removePropertiesTable]
  final bool removePropertiesTable;

  /// A list of the image paths that should be replaced.
  /// see [ConversionSettingsState.imageReplacementPaths]
  final List<String> imageReplacementPathsList;

  static const String newFileEnding = "converted.html";

  /// Read, convert and write the results to a new file.
  ///
  /// Returns a [FileConversionResult] that contains a new path and the content.
  /// Can return null if file does not exists or already was converted before.
  Future<FileConversionResult?> convert() async {
    if (await File(path).exists() == false || path.endsWith(newFileEnding)) return null;
    var content = await File(path).readAsString();

    final patterns = NotionFindReplacePatterns.getPatterns(removePropertiesTable);
    content = NotionFindReplacePatterns.applyPatterns(content, patterns);
    content = HtmlUtils.replaceImageNames(content, imageReplacementPathsList);
    final title = HtmlUtils.extractTitle(content);

    final newPath = (path.split(".")
          ..removeLast()
          ..add(newFileEnding))
        .join(".");
    await File(newPath).writeAsString(content);

    return FileConversionResult(
      oldFile: this,
      title: title,
      convertedFilePath: newPath,
    );
  }

  @override
  List<Object?> get props => [path, removePropertiesTable, imageReplacementPathsList];
}

/// Information about and content of a converted file.
class FileConversionResult extends Equatable {
  const FileConversionResult({
    required this.oldFile,
    required this.convertedFilePath,
    required this.title,
  });

  /// The file that was converted.
  final ConversionFile oldFile;

  /// The path to the converted file.
  final String convertedFilePath;

  /// Title of the html file.
  final String? title;

  @override
  List<Object?> get props => [oldFile, convertedFilePath];
}

/// Some utility functions to handle html content
class HtmlUtils {
  /// Extract the title property from html content
  static String? extractTitle(String content) {
    final titleRegex = RegExp("<title>(.*)<\/title>", multiLine: true);
    return titleRegex.firstMatch(content)?.group(1);
  }

  /// Replace the paths of images with a specified paths
  static String replaceImageNames(String content, List<String> imagePaths) {
    final imagePathPattern = RegExp(r'(?<=src=")([^\/]*\/*(?=Untitled)[^"]*)', multiLine: true);
    final pathMatches = imagePathPattern.allMatches(content);

    if (imagePaths.length < pathMatches.length) {
      // TODO: implement warning
      print("WARNING: Not enough image paths provided, images will be left empty");
    }

    for (int i = 0; i < min(imagePaths.length, pathMatches.length); i++) {
      content = content.replaceAll(pathMatches.elementAt(i).group(0) ?? "", imagePaths[i]);
    }

    return content;
  }
}

typedef ReplaceFunction = String Function(Match);

class FindReplacePattern {
  FindReplacePattern._({
    required this.find,
    required this.replace,
  });

  factory FindReplacePattern({
    required String findPattern,
    required String replacePattern,
  }) =>
      FindReplacePattern._(
        find: RegExp(findPattern, multiLine: true),
        replace: (Match matches) => replaceMatches(replacePattern, matches),
      );

  final RegExp find;
  final ReplaceFunction replace;

  String execute(String content) => content.replaceAllMapped(find, replace);

  static String replaceMatches(String replacePattern, Match matches) {
    for (int i = 1; i <= matches.groupCount; i++) {
      replacePattern = replacePattern.replaceAll("\$$i", matches.group(i - 1) ?? "");
    }
    return replacePattern;
  }
}

/// A list of all regex search and replace functions that will be run on the files.
class NotionFindReplacePatterns {
  static final _deleteHeaderIcon = FindReplacePattern(
    findPattern: r'<div class="page-header-icon [a-z-_]*"><img class="icon" src'
        '="https:\/\/www\.notion\.so\/icons\/[a-z-_]*\.svg"\/><\/div>',
    replacePattern: '',
  );

  static final _deletePropertiesTable =
      FindReplacePattern(findPattern: r'<table class="properties">.*</table>', replacePattern: '');

  static final _limitStylingToNotionDiv1 =
      FindReplacePattern(findPattern: r'(^[^#@\n].+\s\{)', replacePattern: r'#notion $1');

  static final _limitStylingToNotionDiv2 =
      FindReplacePattern(findPattern: r'(^[^#@\n].+,$)', replacePattern: r'#notion $1');

  static final _wrapBodyInDiv = FindReplacePattern(
      findPattern: r'<body>((.|\n)*)</body>',
      replacePattern: r'<body><div id="notion">$2</div></body>');

  static final _applyCustomStyling = FindReplacePattern(
    findPattern: r'\/\* cspell:disable-file \*\/',
    replacePattern: r'* {} body { background-color: #fff; overflow-x: scroll;}'
        ' body * { color: #000; }',
  );

  static final closeToggles =
      FindReplacePattern(findPattern: r'<details open="">', replacePattern: r'<details>');

  static List<FindReplacePattern> getPatterns(bool includeDeletePropertiesTable) => [
        _deleteHeaderIcon,
        if (includeDeletePropertiesTable) _deletePropertiesTable,
        _limitStylingToNotionDiv1,
        _limitStylingToNotionDiv2,
        _wrapBodyInDiv,
        _applyCustomStyling,
      ];

  /// Runs the definitions' search and replace functions
  static String applyPatterns(String content, List<FindReplacePattern> definitions) {
    for (final definition in definitions) {
      content = definition.execute(content);
    }
    return content;
  }
}
