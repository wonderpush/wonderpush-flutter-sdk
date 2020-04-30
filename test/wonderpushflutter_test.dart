import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wonderpushflutter/wonderpushflutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('wonderpushflutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Wonderpushflutter.platformVersion, '42');
  });
}
