import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avenue/services/local_storage_service.dart';

/// ══════════════════════════════════════════════════════════════════════════════
/// Unit Tests cho LocalStorageService
/// ══════════════════════════════════════════════════════════════════════════════
void main() {
  group('LocalStorageService', () {
    setUp(() async {
      // Setup: Mock SharedPreferences trước mỗi test
      SharedPreferences.setMockInitialValues({});
      await LocalStorageService.init();
    });

    group('String Operations', () {
      test('should save and read string value', () async {
        // Arrange
        const key = 'test_key';
        const value = 'test_value';

        // Act
        final saveResult = await LocalStorageService.save(key, value);
        final readValue = await LocalStorageService.read(key);

        // Assert
        expect(saveResult, true);
        expect(readValue, value);
      });

      test('should return null for non-existent key', () async {
        // Act
        final result = await LocalStorageService.read('non_existent_key');

        // Assert
        expect(result, null);
      });

      test('should remove string value', () async {
        // Arrange
        const key = 'test_key';
        const value = 'test_value';
        await LocalStorageService.save(key, value);

        // Act
        final removeResult = await LocalStorageService.remove(key);
        final readValue = await LocalStorageService.read(key);

        // Assert
        expect(removeResult, true);
        expect(readValue, null);
      });
    });

    group('Int Operations', () {
      test('should save and read int value', () async {
        // Arrange
        const key = 'test_int';
        const value = 42;

        // Act
        final saveResult = await LocalStorageService.saveInt(key, value);
        final readValue = await LocalStorageService.readInt(key);

        // Assert
        expect(saveResult, true);
        expect(readValue, value);
      });
    });

    group('Bool Operations', () {
      test('should save and read bool value', () async {
        // Arrange
        const key = 'test_bool';
        const value = true;

        // Act
        final saveResult = await LocalStorageService.saveBool(key, value);
        final readValue = await LocalStorageService.readBool(key);

        // Assert
        expect(saveResult, true);
        expect(readValue, value);
      });
    });

    group('Double Operations', () {
      test('should save and read double value', () async {
        // Arrange
        const key = 'test_double';
        const value = 3.14;

        // Act
        final saveResult = await LocalStorageService.saveDouble(key, value);
        final readValue = await LocalStorageService.readDouble(key);

        // Assert
        expect(saveResult, true);
        expect(readValue, value);
      });
    });

    group('StringList Operations', () {
      test('should save and read string list', () async {
        // Arrange
        const key = 'test_list';
        const value = ['item1', 'item2', 'item3'];

        // Act
        final saveResult = await LocalStorageService.saveStringList(key, value);
        final readValue = await LocalStorageService.readStringList(key);

        // Assert
        expect(saveResult, true);
        expect(readValue, value);
      });
    });

    group('Key Operations', () {
      test('should check if key exists', () async {
        // Arrange
        const key = 'test_key';
        const value = 'test_value';
        await LocalStorageService.save(key, value);

        // Act
        final exists = await LocalStorageService.containsKey(key);
        final notExists = await LocalStorageService.containsKey('non_existent');

        // Assert
        expect(exists, true);
        expect(notExists, false);
      });

      test('should get all keys', () async {
        // Arrange
        await LocalStorageService.save('key1', 'value1');
        await LocalStorageService.save('key2', 'value2');

        // Act
        final keys = await LocalStorageService.getAllKeys();

        // Assert
        expect(keys.contains('key1'), true);
        expect(keys.contains('key2'), true);
      });
    });

    group('Clear Operations', () {
      test('should clear all data', () async {
        // Arrange
        await LocalStorageService.save('key1', 'value1');
        await LocalStorageService.save('key2', 'value2');

        // Act
        final clearResult = await LocalStorageService.clear();
        final keys = await LocalStorageService.getAllKeys();

        // Assert
        expect(clearResult, true);
        expect(keys.isEmpty, true);
      });
    });

    group('Convenience Methods', () {
      test('should save and get access token', () async {
        // Note: Secure storage tests need integration testing
        // Skipping for unit tests
      }, skip: 'Requires platform bindings (integration test)');

      test('should check login status', () async {
        // Note: isLoggedIn() uses secure storage
        // Skipping for unit tests
      }, skip: 'Requires platform bindings (integration test)');

      test('should save user session', () async {
        // Note: saveUserSession() uses secure storage
        // Skipping for unit tests
      }, skip: 'Requires platform bindings (integration test)');

      test('should clear user session', () async {
        // Note: clearUserSession() uses secure storage
        // Skipping for unit tests
      }, skip: 'Requires platform bindings (integration test)');
    });
  });
}
