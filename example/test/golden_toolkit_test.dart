import 'package:example/main.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('tolerance comparator example', (tester) async {
    const widget = MyApp();
    final builder = DeviceBuilder()
      ..addScenario(name: 'default page', widget: widget);

    await tester.pumpDeviceBuilder(builder);
    await screenMatchesGolden(tester, 'my_golden_app');
  });
}
