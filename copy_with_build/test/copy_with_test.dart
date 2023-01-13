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
extension \$SingleFieldCopyWith on SingleField {
  SingleField copyWith({int? abc}) => _\$copyWith(abc: abc);

  SingleField _\$copyWith({int? abc}) {
    return SingleField(abc: abc ?? this.abc);
  }
}
"""));
    });

    test("multiple fields", () async {
      await expectGen("MultipleField", completion("""
extension \$MultipleFieldCopyWith on MultipleField {
  MultipleField copyWith({int? abc, int? def}) =>
      _\$copyWith(abc: abc, def: def);

  MultipleField _\$copyWith({int? abc, int? def}) {
    return MultipleField(abc: abc ?? this.abc, def: def ?? this.def);
  }
}
"""));
    });

    test("nullable field", () async {
      await expectGen("NullableField", completion("""
extension \$NullableFieldCopyWith on NullableField {
  NullableField copyWith({Nullable<int>? abc}) => _\$copyWith(abc: abc);

  NullableField _\$copyWith({Nullable<int>? abc}) {
    return NullableField(abc: abc != null ? abc.obj : this.abc);
  }
}
"""));
    });

    test("derived class", () async {
      await expectGen("DerivedClass", completion("""
extension \$DerivedClassCopyWith on DerivedClass {
  DerivedClass copyWith({int? abc, int? def}) => _\$copyWith(abc: abc, def: def);

  DerivedClass _\$copyWith({int? abc, int? def}) {
    return DerivedClass(abc: abc ?? this.abc, def: def ?? this.def);
  }
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
extension \$TemplateFieldCopyWith on TemplateField {
  TemplateField copyWith({List<int>? abc}) => _\$copyWith(abc: abc);

  TemplateField _\$copyWith({List<int>? abc}) {
    return TemplateField(abc: abc ?? this.abc);
  }
}
"""));
    });

    test("function field", () async {
      await expectGen("FunctionField", completion("""
extension \$FunctionFieldCopyWith on FunctionField {
  FunctionField copyWith({void Function()? abc}) => _\$copyWith(abc: abc);

  FunctionField _\$copyWith({void Function()? abc}) {
    return FunctionField(abc: abc ?? this.abc);
  }
}
"""));
    });

    test("alias field", () async {
      await expectGen("AliasField", completion("""
extension \$AliasFieldCopyWith on AliasField {
  AliasField copyWith({SuperType? abc}) => _\$copyWith(abc: abc);

  AliasField _\$copyWith({SuperType? abc}) {
    return AliasField(abc: abc ?? this.abc);
  }
}
"""));
    });

    test("ignore field", () async {
      await expectGen("IgnoreField", completion("""
extension \$IgnoreFieldCopyWith on IgnoreField {
  IgnoreField copyWith({int? def}) => _\$copyWith(def: def);

  IgnoreField _\$copyWith({int? def}) {
    return IgnoreField(def: def ?? this.def);
  }
}
"""));
    });

    test("keep field", () async {
      await expectGen("KeepField", completion("""
extension \$KeepFieldCopyWith on KeepField {
  KeepField copyWith({int? def}) => _\$copyWith(def: def);

  KeepField _\$copyWith({int? def}) {
    return KeepField(abc: abc, def: def ?? this.def);
  }
}
"""));
    });
  });
}
