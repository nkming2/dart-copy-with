import 'package:copy_with/copy_with.dart';

part 'copy_with.g.dart';

@genCopyWith
class Basic {
  const Basic({
    required this.abc,
    this.def,
  });

  final int abc;
  final int? def;
}

@genCopyWith
class BaseClass {
  const BaseClass({required this.abc});

  $BaseClassCopyWithWorker get copyWith => _$copyWith;

  final int abc;
}

@CopyWith(parent: "BaseClass")
class Polymorphism extends BaseClass {
  const Polymorphism({required super.abc, required this.def});

  @override
  $BaseClassCopyWithWorker get copyWith => _$copyWith;

  final int def;
}
