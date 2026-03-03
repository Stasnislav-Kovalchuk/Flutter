import 'package:flutter_test/flutter_test.dart';

import 'package:offroad_vehicle_monitoring/screens/drive_mode_screen.dart';

void main() {
  group('Drive mode parsing', () {
    test('accepts valid modes (case/space tolerant)', () {
      expect(parseDriveMode('sand'), DriveMode.sand);
      expect(parseDriveMode('  MUD  '), DriveMode.mud);
      expect(parseDriveMode('Snow'), DriveMode.snow);
      expect(parseDriveMode('mountain'), DriveMode.mountain);
      expect(parseDriveMode('2wd'), DriveMode.twoWd);
    });

    test('rejects invalid input', () {
      expect(parseDriveMode(''), isNull);
      expect(parseDriveMode('4wd'), isNull);
      expect(parseDriveMode('sand!'), isNull);
      expect(parseDriveMode('unknown'), isNull);
    });
  });

  group('Drive state mapping', () {
    test('sand -> 4x4 ON, low OFF, diff OFF', () {
      final state = driveStateFor(DriveMode.sand);
      expect(state.is4x4, isTrue);
      expect(state.lowGear, isFalse);
      expect(state.diffLock, isFalse);
    });

    test('mud -> 4x4 ON, low ON, diff ON', () {
      final state = driveStateFor(DriveMode.mud);
      expect(state.is4x4, isTrue);
      expect(state.lowGear, isTrue);
      expect(state.diffLock, isTrue);
    });

    test('snow -> 4x4 ON, low OFF, diff OFF', () {
      final state = driveStateFor(DriveMode.snow);
      expect(state.is4x4, isTrue);
      expect(state.lowGear, isFalse);
      expect(state.diffLock, isFalse);
    });

    test('mountain -> 4x4 ON, low ON, diff ON', () {
      final state = driveStateFor(DriveMode.mountain);
      expect(state.is4x4, isTrue);
      expect(state.lowGear, isTrue);
      expect(state.diffLock, isTrue);
    });

    test('2wd -> all OFF', () {
      final state = driveStateFor(DriveMode.twoWd);
      expect(state.is4x4, isFalse);
      expect(state.lowGear, isFalse);
      expect(state.diffLock, isFalse);
    });
  });
}

