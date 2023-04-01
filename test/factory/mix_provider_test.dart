import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/factory/mix_provider.dart';

import '../helpers/random_dto.dart';

const textVariant = Variant('textVariant');

final overrideTextAttribute = TextAttributes.fromValues(
  style: const TextStyle(
    fontSize: 18,
    color: Colors.blue,
  ),
);

final pressableMix = Mix.fromAttributes([
  RandomGenerator.boxAttributes(),
  RandomGenerator.textAttributes(),
  textVariant(overrideTextAttribute),
]);

void main() {
  group("Mix Provider", () {
    testWidgets('Mix Provider exist and Matches', (tester) async {
      await tester.pumpWidget(Box(
        mix: pressableMix,
      ));

      final widgetFinder = find.byType(BoxMixedWidget);

      // Get BuildContext for boxWidget
      BuildContext context = tester.element(widgetFinder);

      // Grab the MixContext from the BoxMixedWidget MixContext.of(context)
      final mix = MixProvider.of(context);

      final matchMix = MixData.create(
        context: context,
        mix: pressableMix,
      );

      final clonedMix = MixData.create(
        context: context,
        mix: pressableMix.clone(),
      );

      expect(mix?.toValues(), matchMix.toValues());

      expect(
        mix?.toValues(),
        matchMix.toValues(),
        reason: 'MixValues should be the same',
      );

      // Different instance but same properties
      expect(matchMix.hashCode == mix.hashCode, true);
      expect(clonedMix.hashCode == mix.hashCode, false);
      expect(matchMix, equals(mix));
      expect(clonedMix, equals(mix));
      expect(widgetFinder, findsOneWidget);
    });
  });
}