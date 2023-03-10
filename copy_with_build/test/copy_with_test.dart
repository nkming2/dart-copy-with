import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:copy_with_build/src/generator.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  _resolveCompilationUnit("test/src/copy_with.dart");
  tearDown(() {
    // Increment this after each test so the next test has it's own package
    _pkgCacheCount++;
  });

  group("CopyWith", () {
    test("empty", () async {
      final src = _genSrc("""
@genCopyWith
class Empty {}
""");
      final expected = _genExpected(r"""
extension $EmptyCopyWith on Empty {
  Empty copyWith() => _$copyWith();

  Empty _$copyWith() {
    return Empty();
  }
}
""");
      return _buildTest(src, expected);
    });

    test("single field", () async {
      final src = _genSrc("""
@genCopyWith
class SingleField {
  const SingleField({required this.abc});

  final int abc;
}
""");
      final expected = _genExpected(r"""
abstract class $SingleFieldCopyWithWorker {
  SingleField call({int? abc});
}

class _$SingleFieldCopyWithWorkerImpl implements $SingleFieldCopyWithWorker {
  _$SingleFieldCopyWithWorkerImpl(this.that);

  @override
  SingleField call({dynamic abc}) {
    return SingleField(abc: abc as int? ?? that.abc);
  }

  final SingleField that;
}

extension $SingleFieldCopyWith on SingleField {
  $SingleFieldCopyWithWorker get copyWith => _$copyWith;
  $SingleFieldCopyWithWorker get _$copyWith =>
      _$SingleFieldCopyWithWorkerImpl(this);
}
""");
      return _buildTest(src, expected);
    });

    test("multiple fields", () async {
      final src = _genSrc("""
@genCopyWith
class MultipleField {
  const MultipleField({required this.abc, required this.def});

  final int abc;
  final int def;
}
""");

      final expected = _genExpected(r"""
abstract class $MultipleFieldCopyWithWorker {
  MultipleField call({int? abc, int? def});
}

class _$MultipleFieldCopyWithWorkerImpl
    implements $MultipleFieldCopyWithWorker {
  _$MultipleFieldCopyWithWorkerImpl(this.that);

  @override
  MultipleField call({dynamic abc, dynamic def}) {
    return MultipleField(
        abc: abc as int? ?? that.abc, def: def as int? ?? that.def);
  }

  final MultipleField that;
}

extension $MultipleFieldCopyWith on MultipleField {
  $MultipleFieldCopyWithWorker get copyWith => _$copyWith;
  $MultipleFieldCopyWithWorker get _$copyWith =>
      _$MultipleFieldCopyWithWorkerImpl(this);
}
""");
      return _buildTest(src, expected);
    });

    test("nullable field", () async {
      final src = _genSrc("""
@genCopyWith
class NullableField {
  NullableField({required this.abc});

  int? abc;
}
""");
      final expected = _genExpected(r"""
abstract class $NullableFieldCopyWithWorker {
  NullableField call({int? abc});
}

class _$NullableFieldCopyWithWorkerImpl
    implements $NullableFieldCopyWithWorker {
  _$NullableFieldCopyWithWorkerImpl(this.that);

  @override
  NullableField call({dynamic abc = copyWithNull}) {
    return NullableField(abc: abc == copyWithNull ? that.abc : abc as int?);
  }

  final NullableField that;
}

extension $NullableFieldCopyWith on NullableField {
  $NullableFieldCopyWithWorker get copyWith => _$copyWith;
  $NullableFieldCopyWithWorker get _$copyWith =>
      _$NullableFieldCopyWithWorkerImpl(this);
}
""");
      return _buildTest(src, expected);
    });

    test("derived class", () async {
      final src = _genSrc("""
class BaseClass {
  const BaseClass({required this.abc});

  final int abc;
}

@genCopyWith
class DerivedClass extends BaseClass {
  const DerivedClass({required super.abc, required this.def});

  final int def;
}
""");
      final expected = _genExpected(r"""
abstract class $DerivedClassCopyWithWorker {
  DerivedClass call({int? abc, int? def});
}

class _$DerivedClassCopyWithWorkerImpl implements $DerivedClassCopyWithWorker {
  _$DerivedClassCopyWithWorkerImpl(this.that);

  @override
  DerivedClass call({dynamic abc, dynamic def}) {
    return DerivedClass(
        abc: abc as int? ?? that.abc, def: def as int? ?? that.def);
  }

  final DerivedClass that;
}

extension $DerivedClassCopyWith on DerivedClass {
  $DerivedClassCopyWithWorker get copyWith => _$copyWith;
  $DerivedClassCopyWithWorker get _$copyWith =>
      _$DerivedClassCopyWithWorkerImpl(this);
}
""");
      return _buildTest(src, expected);
    });

    test("static field", () async {
      final src = _genSrc("""
@genCopyWith
class StaticField {
  static final int abc = 1;
}
""");
      final expected = _genExpected(r"""
extension $StaticFieldCopyWith on StaticField {
  StaticField copyWith() => _$copyWith();

  StaticField _$copyWith() {
    return StaticField();
  }
}
""");
      return _buildTest(src, expected);
    });

    test("private field", () async {
      final src = _genSrc("""
@genCopyWith
class PrivateField {
  final int _abc = 1;
}
""");
      final expected = _genExpected(r"""
extension $PrivateFieldCopyWith on PrivateField {
  PrivateField copyWith() => _$copyWith();

  PrivateField _$copyWith() {
    return PrivateField();
  }
}
""");
      return _buildTest(src, expected);
    });

    test("getter", () async {
      final src = _genSrc("""
@genCopyWith
class Getter {
  int get abc => 1;
}
""");
      final expected = _genExpected(r"""
extension $GetterCopyWith on Getter {
  Getter copyWith() => _$copyWith();

  Getter _$copyWith() {
    return Getter();
  }
}
""");
      return _buildTest(src, expected);
    });

    test("template field", () async {
      final src = _genSrc("""
@genCopyWith
class TemplateField {
  const TemplateField({required this.abc});

  final List<int> abc;
}
""");
      final expected = _genExpected(r"""
abstract class $TemplateFieldCopyWithWorker {
  TemplateField call({List<int>? abc});
}

class _$TemplateFieldCopyWithWorkerImpl
    implements $TemplateFieldCopyWithWorker {
  _$TemplateFieldCopyWithWorkerImpl(this.that);

  @override
  TemplateField call({dynamic abc}) {
    return TemplateField(abc: abc as List<int>? ?? that.abc);
  }

  final TemplateField that;
}

extension $TemplateFieldCopyWith on TemplateField {
  $TemplateFieldCopyWithWorker get copyWith => _$copyWith;
  $TemplateFieldCopyWithWorker get _$copyWith =>
      _$TemplateFieldCopyWithWorkerImpl(this);
}
""");
      return _buildTest(src, expected);
    });

    test("function field", () async {
      final src = _genSrc("""
@genCopyWith
class FunctionField {
  const FunctionField({required this.abc});

  final void Function() abc;
}
""");
      final expected = _genExpected(r"""
abstract class $FunctionFieldCopyWithWorker {
  FunctionField call({void Function()? abc});
}

class _$FunctionFieldCopyWithWorkerImpl
    implements $FunctionFieldCopyWithWorker {
  _$FunctionFieldCopyWithWorkerImpl(this.that);

  @override
  FunctionField call({dynamic abc}) {
    return FunctionField(abc: abc as void Function()? ?? that.abc);
  }

  final FunctionField that;
}

extension $FunctionFieldCopyWith on FunctionField {
  $FunctionFieldCopyWithWorker get copyWith => _$copyWith;
  $FunctionFieldCopyWithWorker get _$copyWith =>
      _$FunctionFieldCopyWithWorkerImpl(this);
}
""");
      return _buildTest(src, expected);
    });

    test("alias field", () async {
      final src = _genSrc("""
typedef SuperType = int;

@genCopyWith
class AliasField {
  const AliasField({required this.abc});

  final SuperType abc;
}
""");
      final expected = _genExpected(r"""
abstract class $AliasFieldCopyWithWorker {
  AliasField call({SuperType? abc});
}

class _$AliasFieldCopyWithWorkerImpl implements $AliasFieldCopyWithWorker {
  _$AliasFieldCopyWithWorkerImpl(this.that);

  @override
  AliasField call({dynamic abc}) {
    return AliasField(abc: abc as SuperType? ?? that.abc);
  }

  final AliasField that;
}

extension $AliasFieldCopyWith on AliasField {
  $AliasFieldCopyWithWorker get copyWith => _$copyWith;
  $AliasFieldCopyWithWorker get _$copyWith =>
      _$AliasFieldCopyWithWorkerImpl(this);
}
""");
      return _buildTest(src, expected);
    });

    test("ignore field", () async {
      final src = _genSrc("""
@genCopyWith
class IgnoreField {
  const IgnoreField({this.abc = 0, required this.def});

  @ignore
  final int abc;
  final int def;
}
""");
      final expected = _genExpected(r"""
abstract class $IgnoreFieldCopyWithWorker {
  IgnoreField call({int? def});
}

class _$IgnoreFieldCopyWithWorkerImpl implements $IgnoreFieldCopyWithWorker {
  _$IgnoreFieldCopyWithWorkerImpl(this.that);

  @override
  IgnoreField call({dynamic def}) {
    return IgnoreField(def: def as int? ?? that.def);
  }

  final IgnoreField that;
}

extension $IgnoreFieldCopyWith on IgnoreField {
  $IgnoreFieldCopyWithWorker get copyWith => _$copyWith;
  $IgnoreFieldCopyWithWorker get _$copyWith =>
      _$IgnoreFieldCopyWithWorkerImpl(this);
}
""");
      return _buildTest(src, expected);
    });

    test("keep field", () async {
      final src = _genSrc("""
@genCopyWith
class KeepField {
  const KeepField({required this.abc, required this.def});

  @keep
  final int abc;
  final int def;
}
""");
      final expected = _genExpected(r"""
abstract class $KeepFieldCopyWithWorker {
  KeepField call({int? def});
}

class _$KeepFieldCopyWithWorkerImpl implements $KeepFieldCopyWithWorker {
  _$KeepFieldCopyWithWorkerImpl(this.that);

  @override
  KeepField call({dynamic def}) {
    return KeepField(abc: that.abc, def: def as int? ?? that.def);
  }

  final KeepField that;
}

extension $KeepFieldCopyWith on KeepField {
  $KeepFieldCopyWithWorker get copyWith => _$copyWith;
  $KeepFieldCopyWithWorker get _$copyWith =>
      _$KeepFieldCopyWithWorkerImpl(this);
}
""");
      return _buildTest(src, expected);
    });

    test("polymorphic call", () async {
      final src = _genSrc("""
@genCopyWith
class PolymorphicCallBase {
  const PolymorphicCallBase({required this.abc});

  final int abc;
}

@CopyWith(parent: "PolymorphicCallBase")
class PolymorphicCall extends PolymorphicCallBase {
  const PolymorphicCall({required super.abc, required this.def});

  final int def;
}
""");
      final expected = _genExpected(r"""
abstract class $PolymorphicCallBaseCopyWithWorker {
  PolymorphicCallBase call({int? abc});
}

class _$PolymorphicCallBaseCopyWithWorkerImpl
    implements $PolymorphicCallBaseCopyWithWorker {
  _$PolymorphicCallBaseCopyWithWorkerImpl(this.that);

  @override
  PolymorphicCallBase call({dynamic abc}) {
    return PolymorphicCallBase(abc: abc as int? ?? that.abc);
  }

  final PolymorphicCallBase that;
}

extension $PolymorphicCallBaseCopyWith on PolymorphicCallBase {
  $PolymorphicCallBaseCopyWithWorker get copyWith => _$copyWith;
  $PolymorphicCallBaseCopyWithWorker get _$copyWith =>
      _$PolymorphicCallBaseCopyWithWorkerImpl(this);
}

abstract class $PolymorphicCallCopyWithWorker
    implements $PolymorphicCallBaseCopyWithWorker {
  @override
  PolymorphicCall call({int? abc, int? def});
}

class _$PolymorphicCallCopyWithWorkerImpl
    implements $PolymorphicCallCopyWithWorker {
  _$PolymorphicCallCopyWithWorkerImpl(this.that);

  @override
  PolymorphicCall call({dynamic abc, dynamic def}) {
    return PolymorphicCall(
        abc: abc as int? ?? that.abc, def: def as int? ?? that.def);
  }

  final PolymorphicCall that;
}

extension $PolymorphicCallCopyWith on PolymorphicCall {
  $PolymorphicCallCopyWithWorker get copyWith => _$copyWith;
  $PolymorphicCallCopyWithWorker get _$copyWith =>
      _$PolymorphicCallCopyWithWorkerImpl(this);
}
""");
      return _buildTest(src, expected);
    });

    test("deep copy field", () async {
      final src = _genSrc("""
@genCopyWith
class DeepCopyField {
  const DeepCopyField({required this.abc});

  @deepCopy
  final List<int> abc;
}
""");
      final expected = _genExpected(r"""
abstract class $DeepCopyFieldCopyWithWorker {
  DeepCopyField call({List<int>? abc});
}

class _$DeepCopyFieldCopyWithWorkerImpl
    implements $DeepCopyFieldCopyWithWorker {
  _$DeepCopyFieldCopyWithWorkerImpl(this.that);

  @override
  DeepCopyField call({dynamic abc}) {
    return DeepCopyField(abc: abc as List<int>? ?? List.of(that.abc));
  }

  final DeepCopyField that;
}

extension $DeepCopyFieldCopyWith on DeepCopyField {
  $DeepCopyFieldCopyWithWorker get copyWith => _$copyWith;
  $DeepCopyFieldCopyWithWorker get _$copyWith =>
      _$DeepCopyFieldCopyWithWorkerImpl(this);
}
""");
      return _buildTest(src, expected);
    });

    test("prefixed type field", () async {
      final src = """
import 'package:copy_with/copy_with.dart';
import 'type.dart' as type;
part 'test.g.dart';

@genCopyWith
class PrefixedTypeField {
  const PrefixedTypeField({required this.abc});

  final type.MyType abc;
}
""";
      final expected = _genExpected(r"""
abstract class $PrefixedTypeFieldCopyWithWorker {
  PrefixedTypeField call({type.MyType? abc});
}

class _$PrefixedTypeFieldCopyWithWorkerImpl
    implements $PrefixedTypeFieldCopyWithWorker {
  _$PrefixedTypeFieldCopyWithWorkerImpl(this.that);

  @override
  PrefixedTypeField call({dynamic abc}) {
    return PrefixedTypeField(abc: abc as type.MyType? ?? that.abc);
  }

  final PrefixedTypeField that;
}

extension $PrefixedTypeFieldCopyWith on PrefixedTypeField {
  $PrefixedTypeFieldCopyWithWorker get copyWith => _$copyWith;
  $PrefixedTypeFieldCopyWithWorker get _$copyWith =>
      _$PrefixedTypeFieldCopyWithWorkerImpl(this);
}
""");
      return testBuilder(
        PartBuilder([CopyWithGenerator()], ".g.dart"),
        {
          "$_pkgName|lib/test.dart": src,
          "$_pkgName|lib/type.dart": "class MyType {}",
        },
        generateFor: {'$_pkgName|lib/test.dart'},
        outputs: {"$_pkgName|lib/test.g.dart": decodedMatches(expected)},
      );
    });
  });
}

String _genSrc(String src) {
  return """
import 'package:copy_with/copy_with.dart';
part 'test.g.dart';
$src
""";
}

String _genExpected(String src) {
  return """// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

$src""";
}

Future _buildTest(String src, String expected) {
  return testBuilder(
    PartBuilder([CopyWithGenerator()], ".g.dart"),
    {"$_pkgName|lib/test.dart": src},
    generateFor: {'$_pkgName|lib/test.dart'},
    outputs: {"$_pkgName|lib/test.g.dart": decodedMatches(expected)},
  );
}

// Taken from source_gen_test, unclear why this is needed...
Future<void> _resolveCompilationUnit(String filePath) async {
  final assetId = AssetId.parse('a|lib/${p.basename(filePath)}');
  final files =
      Directory(p.dirname(filePath)).listSync().whereType<File>().toList();

  final fileMap = Map<String, String>.fromEntries(files.map(
      (f) => MapEntry('a|lib/${p.basename(f.path)}', f.readAsStringSync())));

  await resolveSources(fileMap, (item) async {
    return await item.libraryFor(assetId);
  }, resolverFor: 'a|lib/${p.basename(filePath)}');
}

String get _pkgName => 'pkg$_pkgCacheCount';
int _pkgCacheCount = 1;
