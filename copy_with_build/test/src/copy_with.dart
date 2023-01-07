// ignore_for_file: unused_field

import 'package:copy_with/copy_with.dart';

@autoCopyWith
class Empty {}

@autoCopyWith
class SingleField {
  const SingleField({required this.abc});

  final int abc;
}

@autoCopyWith
class MultipleField {
  const MultipleField({required this.abc, required this.def});

  final int abc;
  final int def;
}

@autoCopyWith
class NullableField {
  NullableField({required this.abc});

  int? abc;
}

class BaseClass {
  const BaseClass({required this.abc});

  final int abc;
}

@autoCopyWith
class DerivedClass extends BaseClass {
  const DerivedClass({required super.abc, required this.def});

  final int def;
}

@autoCopyWith
class StaticField {
  static final int abc = 1;
}

@autoCopyWith
class PrivateField {
  final int _abc = 1;
}

@autoCopyWith
class Getter {
  int get abc => 1;
}

@autoCopyWith
class TemplateField {
  const TemplateField({required this.abc});

  final List<int> abc;
}

@autoCopyWith
class FunctionField {
  const FunctionField({required this.abc});

  final void Function() abc;
}

@autoCopyWith
class AliasField {
  const AliasField({required this.abc});

  final SuperType abc;
}

@autoCopyWith
class IgnoreField {
  const IgnoreField({this.abc = 0, required this.def});

  @ignoreCopyWith
  final int abc;
  final int def;
}

@autoCopyWith
class KeepField {
  const KeepField({required this.abc, required this.def});

  @keepCopyWith
  final int abc;
  final int def;
}

typedef SuperType = int;
