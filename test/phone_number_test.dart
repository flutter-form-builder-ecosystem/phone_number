import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:phone_number/phone_number.dart';

void main() {
  MockMethodChannel methodChannel;
  PhoneNumber phoneNumber;
  setUp(() {
    methodChannel = MockMethodChannel();

    phoneNumber = PhoneNumber.private(methodChannel);
  });

  group('parse', () {
    const input = '1234';
    const region = 'GB';
    const sample = {
      'type': 'fake',
    };

    setUp(() {
      when(
        methodChannel.invokeMapMethod<String, String>(
          'parse',
          {'string': '1234', 'region': 'GB'},
        ),
      ).thenAnswer((_) async => sample);
    });

    test('calls through', () async {
      await phoneNumber.parse(input, region: region);

      verify(methodChannel.invokeMapMethod<String, String>('parse', {
        'string': input,
        'region': region,
      }));
      verifyNoMoreInteractions(methodChannel);
    });

    test('returns data', () async {
      final Map<String, String> info =
          await phoneNumber.parse(input, region: region);
      expect(mapEquals(sample, info), isTrue);
    });
  });
  group('allSupportedRegions', () {
    const sample = {'DE': 49, 'GB': 44};
    setUp(() {
      when(
        methodChannel.invokeMapMethod<String, int>('get_all_supported_regions'),
      ).thenAnswer((_) async => sample);
    });

    test('calls through', () async {
      await phoneNumber.allSupportedRegions();

      verify(methodChannel
          .invokeMapMethod<String, int>('get_all_supported_regions'));
      verifyNoMoreInteractions(methodChannel);
    });

    test('returns data', () async {
      final Map<String, int> regions = await phoneNumber.allSupportedRegions();
      expect(mapEquals(sample, regions), isTrue);
    });
  });
}

class MockMethodChannel extends Mock implements MethodChannel {}
