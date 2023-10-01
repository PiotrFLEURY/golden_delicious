library golden_delicious;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mason_logger/mason_logger.dart';

/// Override the default [GoldenFileComparator] with a tolerant comparator.
///
/// This comparator will ignore differences if they are less than the given
/// [tolerance].
///
/// To specify tolerance, add --dart-define=golden_tolerance=<tolerance> to the
/// flutter test command.
///
/// For example, to set the tolerance to 1%, run:
///   flutter test --dart-define=golden_tolerance=1
///
/// See https://github.com/flutter/flutter/issues/56383 for more information.
///
get goldenDeliciousComparator {
  /// Tolerance argument
  /// Default value is 0.0
  /// 0.0 means no tolerance
  /// 1.0 means 1% tolerance
  /// 50.0 means 50% tolerance
  /// 100.0 means 100% tolerance
  const toleranceArg = String.fromEnvironment(
    'golden_tolerance',
    defaultValue: '0.0',
  );
  final tolerance = double.parse(toleranceArg) / 100;
  final currentDirUri = goldenFileComparator is LocalFileComparator
      ? (goldenFileComparator as LocalFileComparator).basedir
      : Uri.file(Directory.current.path);

  final currentFileUri =
      Directory(currentDirUri.toFilePath()).listSync().first.uri;
  return GoldenDeliciousComparator(
    tolerance,
    currentFileUri,
  );
}

/// A [GoldenFileComparator] that ignores differences if they are less than the
/// given [tolerance].
class GoldenDeliciousComparator extends LocalFileComparator {
  /// Creates a new [GoldenDeliciousComparator].
  /// [tolerance] is the tolerance in percentage.
  ///   0.0 means no tolerance
  ///   0.5 means 50% tolerance
  ///   1.0 means 100% tolerance
  /// [uri] is the uri of the current file.
  GoldenDeliciousComparator(this.tolerance, super.uri);

  /// The tolerance in percentage.
  ///   0.0 means no tolerance
  ///   0.5 means 50% tolerance
  ///   1.0 means 100% tolerance
  double tolerance;

  /// Logger instance
  final _logger = Logger(
    theme: LogTheme(
      info: (m) => backgroundDarkGray.wrap(styleBold.wrap(white.wrap(m))),
      warn: (m) => backgroundDarkGray.wrap(styleBold.wrap(red.wrap(m))),
      success: (m) => backgroundDarkGray.wrap(styleBold.wrap(green.wrap(m))),
      err: (m) => backgroundRed.wrap(styleBold.wrap(white.wrap(m))),
    ),
  );

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    _logger.info(
      '🍏 golden_delicious tolerance is ${tolerance * 100}%',
    );

    final ComparisonResult result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (result.diffPercent > 0) {
      _logger.warn('😯 found a difference of ${result.diffPercent * 100}%');
    } else {
      _logger.success(
          '😋 Miam! "$golden" compared with a diff of ${result.diffPercent}%');
    }

    if (!result.passed && result.diffPercent > tolerance) {
      _logger.err('😡 tolerance exceeded!');
      final String error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }

    return result.diffPercent <= tolerance;
  }
}
