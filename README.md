# golden_delicious

![build](https://github.com/PiotrFLEURY/golden_delicious/actions/workflows/ci.yml/badge.svg?branch=main)
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

Tolerance comparator for Flutter golden tests.

# Setup

## 1. Single test file setup

To use it, override the `goldenFileComparator` property in your test file:

```dart

import 'package:flutter_test/flutter_test.dart';
import 'package:golden_delicious/golden_delicious.dart';

main() {
  goldenFileComparator = goldenDeliciousComparator;
  
  testWidgets('MyWidget', (tester) async {
    await tester.pumpWidget(MyWidget());
    await expectLater(find.byType(MyWidget), matchesGoldenFile('my_widget.png'));
  });
}

```

## 2. Using flutter_test_config

You can also configure the tolerance percentage via the `flutter_test_config.dart` file. This file is automatically loaded by the `flutter_test` package.

```dart
# flutter_test_config.dart
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:golden_delicious/golden_delicious.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUpAll(() {
    goldenFileComparator = goldenDeliciousComparator;
  });

  await testMain();
}


```

## 3. Using Golden Toolkit

[Golden Toolkit](https://pub.dev/packages/golden_toolkit) is a package that provides a set of utilities to make it easier to work with golden files. It also provides a `GoldenToolkitConfiguration` class that can be used to configure the tolerance percentage.

```dart
# flutter_test_config.dart
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:golden_delicious/golden_delicious.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      goldenFileComparator = goldenDeliciousComparator;
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      defaultDevices: const [
        Device.phone,
        Device.iphone11,
        Device.tabletPortrait,
        Device.tabletLandscape,
      ],
      enableRealShadows: true,
    ),
  );
}

# test/golden_toolkit_test.dart
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('tolerance comparator example', (tester) async {
    const widget = MyHomePage(
      title: 'hello golden toolkit',
    );
    final builder = DeviceBuilder()
      ..addScenario(name: 'default page', widget: widget);

    await tester.pumpDeviceBuilder(builder);
    await screenMatchesGolden(tester, 'main');
  });
}

```

See [golden_toolkit_test.dart](test/golden_toolkit_test.dart) and [flutter_test_config.dart](test/flutter_test_config.dart) for a complete example.

# Usage

Add `--dart-define=golden_tolerance=0.1` to your test command. Default value is `0.0`.

__1 represents 1% of the image bytes__

```bash
# 0.1% tolerance
flutter test --dart-define=golden_tolerance=0.1

# 5% tolerance
flutter test --dart-define=golden_tolerance=5
```


# Visual Studio Code tips

You can define custom runtime configuration in Visual Studio Code to run your tests with a custom tolerance percentage.

> 💚 Thanks to 💚
> 
> [golden_toolkit documentation](https://pub.dev/packages/golden_toolkit#configure-vs-code) 
>
> 🚀 for this tip 🚀

```json
# .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Tolerance",
      "request": "launch",
      "type": "dart",
      "codeLens": {
        "for": ["run-test", "run-test-file"]
      },
      "args": [
        "--dart-define=golden_tolerance=0.1"
      ]
    }
  ]
}
```