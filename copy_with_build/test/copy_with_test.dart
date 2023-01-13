import 'package:code_gen_tester/code_gen_tester.dart';
import 'package:copy_with_build/src/generator.dart';
import 'package:test/test.dart';

void main() {
  final tester = SourceGenTester.fromPath("test/src/copy_with.dart");
  final generator = CopyWithGenerator();
  Future<void> expectGen(String name, Matcher matcher) async =>
      expectGenerateNamed(await tester, name, generator, matcher);

  group("CopyWith", () {
    test("empty", () async {
      await expectGen("Empty", completion("""
extension \$EmptyCopyWith on Empty {
  Empty copyWith() => _\$copyWith();

  Empty _\$copyWith() {
    return Empty();
  }
}
"""));
    });

    test("signel field", () async {
      await expectGen("SingleField", completion("""
abstract class \$SingleFieldCopyWithWorker {
  SingleField call({int? abc});
}

class _\$SingleFieldCopyWithWorkerImpl implements \$SingleFieldCopyWithWorker {
  _\$SingleFieldCopyWithWorkerImpl(this.that);

  @override
  SingleField call({dynamic abc}) {
    return SingleField(abc: abc as int? ?? that.abc);
  }

  final SingleField that;
}

extension \$SingleFieldCopyWith on SingleField {
  \$SingleFieldCopyWithWorker get copyWith => _\$copyWith;
  \$SingleFieldCopyWithWorker get _\$copyWith =>
      _\$SingleFieldCopyWithWorkerImpl(this);
}
"""));
    });

    test("multiple fields", () async {
      await expectGen("MultipleField", completion("""
abstract class \$MultipleFieldCopyWithWorker {
  MultipleField call({int? abc, int? def});
}

class _\$MultipleFieldCopyWithWorkerImpl
    implements \$MultipleFieldCopyWithWorker {
  _\$MultipleFieldCopyWithWorkerImpl(this.that);

  @override
  MultipleField call({dynamic abc, dynamic def}) {
    return MultipleField(
        abc: abc as int? ?? that.abc, def: def as int? ?? that.def);
  }

  final MultipleField that;
}

extension \$MultipleFieldCopyWith on MultipleField {
  \$MultipleFieldCopyWithWorker get copyWith => _\$copyWith;
  \$MultipleFieldCopyWithWorker get _\$copyWith =>
      _\$MultipleFieldCopyWithWorkerImpl(this);
}
"""));
    });

    test("nullable field", () async {
      await expectGen("NullableField", completion("""
abstract class \$NullableFieldCopyWithWorker {
  NullableField call({int? abc});
}

class _\$NullableFieldCopyWithWorkerImpl
    implements \$NullableFieldCopyWithWorker {
  _\$NullableFieldCopyWithWorkerImpl(this.that);

  @override
  NullableField call({dynamic abc = copyWithNull}) {
    return NullableField(abc: abc == copyWithNull ? that.abc : abc as int?);
  }

  final NullableField that;
}

extension \$NullableFieldCopyWith on NullableField {
  \$NullableFieldCopyWithWorker get copyWith => _\$copyWith;
  \$NullableFieldCopyWithWorker get _\$copyWith =>
      _\$NullableFieldCopyWithWorkerImpl(this);
}
"""));
    });

    test("derived class", () async {
      await expectGen("DerivedClass", completion("""
abstract class \$DerivedClassCopyWithWorker {
  DerivedClass call({int? abc, int? def});
}

class _\$DerivedClassCopyWithWorkerImpl implements \$DerivedClassCopyWithWorker {
  _\$DerivedClassCopyWithWorkerImpl(this.that);

  @override
  DerivedClass call({dynamic abc, dynamic def}) {
    return DerivedClass(
        abc: abc as int? ?? that.abc, def: def as int? ?? that.def);
  }

  final DerivedClass that;
}

extension \$DerivedClassCopyWith on DerivedClass {
  \$DerivedClassCopyWithWorker get copyWith => _\$copyWith;
  \$DerivedClassCopyWithWorker get _\$copyWith =>
      _\$DerivedClassCopyWithWorkerImpl(this);
}
"""));
    });

    test("static field", () async {
      await expectGen("StaticField", completion("""
extension \$StaticFieldCopyWith on StaticField {
  StaticField copyWith() => _\$copyWith();

  StaticField _\$copyWith() {
    return StaticField();
  }
}
"""));
    });

    test("private field", () async {
      await expectGen("PrivateField", completion("""
extension \$PrivateFieldCopyWith on PrivateField {
  PrivateField copyWith() => _\$copyWith();

  PrivateField _\$copyWith() {
    return PrivateField();
  }
}
"""));
    });

    test("getter", () async {
      await expectGen("Getter", completion("""
extension \$GetterCopyWith on Getter {
  Getter copyWith() => _\$copyWith();

  Getter _\$copyWith() {
    return Getter();
  }
}
"""));
    });

    test("template field", () async {
      await expectGen("TemplateField", completion("""
abstract class \$TemplateFieldCopyWithWorker {
  TemplateField call({List<int>? abc});
}

class _\$TemplateFieldCopyWithWorkerImpl
    implements \$TemplateFieldCopyWithWorker {
  _\$TemplateFieldCopyWithWorkerImpl(this.that);

  @override
  TemplateField call({dynamic abc}) {
    return TemplateField(abc: abc as List<int>? ?? that.abc);
  }

  final TemplateField that;
}

extension \$TemplateFieldCopyWith on TemplateField {
  \$TemplateFieldCopyWithWorker get copyWith => _\$copyWith;
  \$TemplateFieldCopyWithWorker get _\$copyWith =>
      _\$TemplateFieldCopyWithWorkerImpl(this);
}
"""));
    });

    test("function field", () async {
      await expectGen("FunctionField", completion("""
abstract class \$FunctionFieldCopyWithWorker {
  FunctionField call({void Function()? abc});
}

class _\$FunctionFieldCopyWithWorkerImpl
    implements \$FunctionFieldCopyWithWorker {
  _\$FunctionFieldCopyWithWorkerImpl(this.that);

  @override
  FunctionField call({dynamic abc}) {
    return FunctionField(abc: abc as void Function()? ?? that.abc);
  }

  final FunctionField that;
}

extension \$FunctionFieldCopyWith on FunctionField {
  \$FunctionFieldCopyWithWorker get copyWith => _\$copyWith;
  \$FunctionFieldCopyWithWorker get _\$copyWith =>
      _\$FunctionFieldCopyWithWorkerImpl(this);
}
"""));
    });

    test("alias field", () async {
      await expectGen("AliasField", completion("""
abstract class \$AliasFieldCopyWithWorker {
  AliasField call({SuperType? abc});
}

class _\$AliasFieldCopyWithWorkerImpl implements \$AliasFieldCopyWithWorker {
  _\$AliasFieldCopyWithWorkerImpl(this.that);

  @override
  AliasField call({dynamic abc}) {
    return AliasField(abc: abc as SuperType? ?? that.abc);
  }

  final AliasField that;
}

extension \$AliasFieldCopyWith on AliasField {
  \$AliasFieldCopyWithWorker get copyWith => _\$copyWith;
  \$AliasFieldCopyWithWorker get _\$copyWith =>
      _\$AliasFieldCopyWithWorkerImpl(this);
}
"""));
    });

    test("ignore field", () async {
      await expectGen("IgnoreField", completion("""
abstract class \$IgnoreFieldCopyWithWorker {
  IgnoreField call({int? def});
}

class _\$IgnoreFieldCopyWithWorkerImpl implements \$IgnoreFieldCopyWithWorker {
  _\$IgnoreFieldCopyWithWorkerImpl(this.that);

  @override
  IgnoreField call({dynamic def}) {
    return IgnoreField(def: def as int? ?? that.def);
  }

  final IgnoreField that;
}

extension \$IgnoreFieldCopyWith on IgnoreField {
  \$IgnoreFieldCopyWithWorker get copyWith => _\$copyWith;
  \$IgnoreFieldCopyWithWorker get _\$copyWith =>
      _\$IgnoreFieldCopyWithWorkerImpl(this);
}
"""));
    });

    test("keep field", () async {
      await expectGen("KeepField", completion("""
abstract class \$KeepFieldCopyWithWorker {
  KeepField call({int? def});
}

class _\$KeepFieldCopyWithWorkerImpl implements \$KeepFieldCopyWithWorker {
  _\$KeepFieldCopyWithWorkerImpl(this.that);

  @override
  KeepField call({dynamic def}) {
    return KeepField(abc: that.abc, def: def as int? ?? that.def);
  }

  final KeepField that;
}

extension \$KeepFieldCopyWith on KeepField {
  \$KeepFieldCopyWithWorker get copyWith => _\$copyWith;
  \$KeepFieldCopyWithWorker get _\$copyWith =>
      _\$KeepFieldCopyWithWorkerImpl(this);
}
"""));
    });

    test("polymorphic call", () async {
      await expectGen("PolymorphicCall", completion("""
abstract class \$PolymorphicCallCopyWithWorker
    implements \$PolymorphicCallBaseCopyWithWorker {
  @override
  PolymorphicCall call({int? abc, int? def});
}

class _\$PolymorphicCallCopyWithWorkerImpl
    implements \$PolymorphicCallCopyWithWorker {
  _\$PolymorphicCallCopyWithWorkerImpl(this.that);

  @override
  PolymorphicCall call({dynamic abc, dynamic def}) {
    return PolymorphicCall(
        abc: abc as int? ?? that.abc, def: def as int? ?? that.def);
  }

  final PolymorphicCall that;
}

extension \$PolymorphicCallCopyWith on PolymorphicCall {
  \$PolymorphicCallCopyWithWorker get copyWith => _\$copyWith;
  \$PolymorphicCallCopyWithWorker get _\$copyWith =>
      _\$PolymorphicCallCopyWithWorkerImpl(this);
}
"""));
    });
  });
}
