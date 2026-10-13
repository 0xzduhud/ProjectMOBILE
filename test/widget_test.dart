import 'package:flutter_test/flutter_test.dart';
import 'package:project/main.dart';

void main() {
  testWidgets('FitTrack menampilkan navigasi utama', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FitTrackApp());

    expect(find.text('FitTrack'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Aktivitas'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}
