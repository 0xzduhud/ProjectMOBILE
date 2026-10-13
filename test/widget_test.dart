import 'package:flutter_test/flutter_test.dart';
import 'package:project/main.dart';

void main() {
  testWidgets('Gerak.in menampilkan halaman login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GerakInApp());

    expect(find.text('Gerak.in'), findsOneWidget);
    expect(find.text('Selamat datang kembali!'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });
}
