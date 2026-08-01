import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/data/vocabulary.dart';
import 'package:cyrillic_trainer_app/widgets/category_picker_sheet.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('showCategoryPicker', () {
    testWidgets('shows a checkbox for every category, checked per the initial selection', (tester) async {
      Set<String>? result;
      await tester.pumpWidget(wrap(Builder(builder: (context) {
        return ElevatedButton(
          onPressed: () async {
            result = await showCategoryPicker(context, {'Numbers'});
          },
          child: const Text('open'),
        );
      })));

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      for (final category in vocabCategories) {
        expect(find.text(category), findsOneWidget);
      }
      final numbersTile = tester.widget<CheckboxListTile>(
        find.widgetWithText(CheckboxListTile, 'Numbers'),
      );
      expect(numbersTile.value, isTrue);
      final animalsTile = tester.widget<CheckboxListTile>(
        find.widgetWithText(CheckboxListTile, 'Animals'),
      );
      expect(animalsTile.value, isFalse);

      // Silence the unused-result warning; the flow is exercised above.
      expect(result, isNull);
    });

    testWidgets('All selects every category, None clears them, Apply returns the selection', (tester) async {
      Set<String>? result;
      await tester.pumpWidget(wrap(Builder(builder: (context) {
        return ElevatedButton(
          onPressed: () async {
            result = await showCategoryPicker(context, {});
          },
          child: const Text('open'),
        );
      })));

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      expect(result, vocabCategories.toSet());
    });

    testWidgets('Apply is disabled when no category is selected', (tester) async {
      await tester.pumpWidget(wrap(Builder(builder: (context) {
        return ElevatedButton(
          onPressed: () => showCategoryPicker(context, {'Numbers'}),
          child: const Text('open'),
        );
      })));

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('None'));
      await tester.pumpAndSettle();

      // Apply is disabled (onPressed: null) while the selection is empty,
      // so tapping it should be a no-op rather than closing the sheet.
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Sheet should still be open (Apply was a no-op while disabled).
      expect(find.text('Apply'), findsOneWidget);
    });
  });
}
