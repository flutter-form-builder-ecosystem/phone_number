import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:phone_number/phone_number.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MockMethodChannel methodChannel;
  PhoneNumber phoneNumber;

  setUp(() {
    methodChannel = MockMethodChannel();
    phoneNumber = PhoneNumber.withChannel(methodChannel);
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
  });
}

class MockMethodChannel extends Mock implements MethodChannel {}
