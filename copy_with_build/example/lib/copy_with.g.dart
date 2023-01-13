// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'copy_with.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $BasicCopyWithWorker {
  Basic call({int? abc, int? def});
}

class _$BasicCopyWithWorkerImpl implements $BasicCopyWithWorker {
  _$BasicCopyWithWorkerImpl(this.that);

  @override
  Basic call({dynamic abc, dynamic def = copyWithNull}) {
    return Basic(
        abc: abc as int? ?? that.abc,
        def: def == copyWithNull ? that.def : def as int?);
  }

  final Basic that;
}

extension $BasicCopyWith on Basic {
  $BasicCopyWithWorker get copyWith => _$copyWith;
  $BasicCopyWithWorker get _$copyWith => _$BasicCopyWithWorkerImpl(this);
}

abstract class $BaseClassCopyWithWorker {
  BaseClass call({int? abc});
}

class _$BaseClassCopyWithWorkerImpl implements $BaseClassCopyWithWorker {
  _$BaseClassCopyWithWorkerImpl(this.that);

  @override
  BaseClass call({dynamic abc}) {
    return BaseClass(abc: abc as int? ?? that.abc);
  }

  final BaseClass that;
}

extension $BaseClassCopyWith on BaseClass {
  $BaseClassCopyWithWorker get copyWith => _$copyWith;
  $BaseClassCopyWithWorker get _$copyWith =>
      _$BaseClassCopyWithWorkerImpl(this);
}

abstract class $PolymorphismCopyWithWorker implements $BaseClassCopyWithWorker {
  @override
  Polymorphism call({int? abc, int? def});
}

class _$PolymorphismCopyWithWorkerImpl implements $PolymorphismCopyWithWorker {
  _$PolymorphismCopyWithWorkerImpl(this.that);

  @override
  Polymorphism call({dynamic abc, dynamic def}) {
    return Polymorphism(
        abc: abc as int? ?? that.abc, def: def as int? ?? that.def);
  }

  final Polymorphism that;
}

extension $PolymorphismCopyWith on Polymorphism {
  $PolymorphismCopyWithWorker get copyWith => _$copyWith;
  $PolymorphismCopyWithWorker get _$copyWith =>
      _$PolymorphismCopyWithWorkerImpl(this);
}
