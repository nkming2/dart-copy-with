import 'package:copy_with/copy_with.dart';

part 'copy_with.g.dart';

@genCopyWith
class BasicUsage {
  const BasicUsage({
    required this.abc,
    required this.def,
  });

  final int abc;
  final int def;
}
