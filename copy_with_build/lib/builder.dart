import 'package:build/build.dart';
import 'package:copy_with_build/src/generator.dart';
import 'package:source_gen/source_gen.dart';

Builder copyWithBuilder(BuilderOptions options) => SharedPartBuilder(
      [CopyWithLintRuleGenerator(), CopyWithGenerator()],
      "copy_with",
    );
