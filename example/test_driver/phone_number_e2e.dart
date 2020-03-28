import 'package:flutter_test/flutter_test.dart';
import 'package:e2e/e2e.dart';
import 'package:phone_number/phone_number.dart';

void main() {
  E2EWidgetsFlutterBinding.ensureInitialized();

  testWidgets('parse "+49 30 12345678"', (WidgetTester tester) async {
    final state = await PhoneNumber().parse('+49 30 12345678');

    expect(state, {
      'country_code': '49',
      'e164': '+493012345678',
      'national': '030 12345678',
      'type': 'fixedLine',
      'international': '+49 30 12345678',
      'national_number': '3012345678'
    });
  });
}
