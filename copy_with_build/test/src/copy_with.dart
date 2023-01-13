// ignore_for_file: unused_field

import 'package:copy_with/copy_with.dart';

@genCopyWith
class Empty {}

@genCopyWith
class SingleField {
  const SingleField({required this.abc});

  final int abc;
}

@genCopyWith
class MultipleField {
  const MultipleField({required this.abc, required this.def});

  final int abc;
  final int def;
}

@genCopyWith
class NullableField {
  NullableField({required this.abc});

  int? abc;
}

class BaseClass {
  const BaseClass({required this.abc});

  final int abc;
}

@genCopyWith
class DerivedClass extends BaseClass {
  const DerivedClass({required super.abc, required this.def});

  final int def;
}

@genCopyWith
class StaticField {
  static final int abc = 1;
}

@genCopyWith
class PrivateField {
  final int _abc = 1;
}

@genCopyWith
class Getter {
  int get abc => 1;
}

@genCopyWith
class TemplateField {
  const TemplateField({required this.abc});

  final List<int> abc;
}

@genCopyWith
class FunctionField {
  const FunctionField({required this.abc});

  final void Function() abc;
}

@genCopyWith
class AliasField {
  const AliasField({required this.abc});

  final SuperType abc;
}

@genCopyWith
class IgnoreField {
  const IgnoreField({this.abc = 0, required this.def});

  @ignore
  final int abc;
  final int def;
}

@genCopyWith
class KeepField {
  const KeepField({required this.abc, required this.def});

  @keep
  final int abc;
  final int def;
}

typedef SuperType = int;
