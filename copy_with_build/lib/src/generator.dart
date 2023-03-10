import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:copy_with/copy_with.dart';
import 'package:source_gen/source_gen.dart';

import 'util.dart';

class CopyWithLintRuleGenerator extends Generator {
  @override
  String? generate(LibraryReader library, BuildStep buildStep) {
    if (library.annotatedWith(TypeChecker.fromRuntime(CopyWith)).isNotEmpty) {
      return "// ignore_for_file: library_private_types_in_public_api, duplicate_ignore";
    } else {
      return null;
    }
  }
}

class CopyWithGenerator extends GeneratorForAnnotation<CopyWith> {
  const CopyWithGenerator();

  @override
  Future<String?> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      print("Not a class");
      return null;
    }
    final copyWith = CopyWith(
      parent: annotation.read("parent").stringValueOrNull,
    );
    final clazz = element;
    final fields = await _getFields(buildStep.resolver, clazz, copyWith);
    if (fields.isEmpty) {
      return """
extension \$${clazz.name}CopyWith on ${clazz.name} {
  ${clazz.name} copyWith() => _\$copyWith();

  ${clazz.name} _\$copyWith() {
    return ${clazz.name}();
  }
}
""";
    } else {
      String workerClassDef;
      String workerClassOverrideTag;
      if (copyWith.parent?.isNotEmpty == true) {
        workerClassDef =
            "abstract class \$${clazz.name}CopyWithWorker implements \$${copyWith.parent}CopyWithWorker";
        workerClassOverrideTag = "@override\n  ";
      } else {
        workerClassDef = "abstract class \$${clazz.name}CopyWithWorker";
        workerClassOverrideTag = "";
      }
      return """
$workerClassDef {
  $workerClassOverrideTag${clazz.name} call({${_buildParameterBody(fields)}});
}

class _\$${clazz.name}CopyWithWorkerImpl implements \$${clazz.name}CopyWithWorker {
  _\$${clazz.name}CopyWithWorkerImpl(this.that);

  @override
  ${clazz.name} call({${_buildImplParameterBody(fields)}}) {
    return ${clazz.name}(${_buildConstructorBody(fields)});
  }

  final ${clazz.name} that;
}

extension \$${clazz.name}CopyWith on ${clazz.name} {
  \$${clazz.name}CopyWithWorker get copyWith => _\$copyWith;
  \$${clazz.name}CopyWithWorker get _\$copyWith => _\$${clazz.name}CopyWithWorkerImpl(this);
}
""";
    }
  }

  String _buildParameterBody(List<_FieldMeta> fields) {
    return fields
        .where((f) => !f.isKeep)
        .map((f) => "${f.typeStr}? ${f.name}")
        .join(",");
  }

  String _buildImplParameterBody(List<_FieldMeta> fields) {
    return fields
        .where((f) => !f.isKeep)
        .map((f) => "dynamic ${f.name}${f.isNullable ? " = copyWithNull" : ""}")
        .join(",");
  }

  String _buildConstructorBody(List<_FieldMeta> fields) {
    return fields.map((f) {
      if (f.isKeep) {
        return "${f.name}: ${_buildCopyOf(f, "that")}";
      } else if (f.isNullable) {
        return "${f.name}: ${f.name} == copyWithNull ? ${_buildCopyOf(f, "that")} : ${f.name} as ${f.typeStr}?";
      } else {
        return "${f.name}: ${f.name} as ${f.typeStr}? ?? ${_buildCopyOf(f, "that")}";
      }
    }).join(",");
  }

  String _buildCopyOf(_FieldMeta field, String inst) {
    if (field.isDeepCopy) {
      if (TypeChecker.fromRuntime(List).isExactlyType(field.type)) {
        return "List.of($inst.${field.name})";
      } else if (TypeChecker.fromRuntime(Map).isExactlyType(field.type)) {
        return "Map.of($inst.${field.name})";
      } else if (TypeChecker.fromRuntime(Set).isExactlyType(field.type)) {
        return "Set.of($inst.${field.name})";
      }
    }
    return "$inst.${field.name}";
  }

  Future<List<_FieldMeta>> _getFields(
      Resolver resolver, ClassElement clazz, CopyWith copyWith) async {
    final data = <_FieldMeta>[];
    if (clazz.supertype?.isDartCoreObject == false) {
      final parent = clazz.supertype!.element2;
      data.addAll(await _getFields(resolver, parent as ClassElement, copyWith));
    }
    for (final f
        in clazz.fields.where((f) => _shouldIncludeField(f, copyWith))) {
      final meta = await _FieldMetaBuilder().build(resolver, f);
      data.add(meta);
    }
    return data;
  }

  bool _shouldIncludeField(FieldElement field, CopyWith copyWith) {
    if (field.isStatic) {
      // ignore static fields
      return false;
    }
    final ignore = _getIgnoreAnnotation(field);
    if (ignore != null) {
      // ignore fields annotated by [Ignore]
      return false;
    }
    if (field.isPrivate) {
      // ignore private fields
      return false;
    }
    if (field.isSynthetic) {
      // skip getters
      return false;
    }
    return true;
  }
}

class _FieldMeta {
  const _FieldMeta({
    required this.name,
    required this.type,
    required this.typeStr,
    required this.isNullable,
    required this.isKeep,
    required this.isDeepCopy,
  });

  final String name;
  final DartType type;
  final String typeStr;
  final bool isNullable;
  final bool isKeep;
  final bool isDeepCopy;
}

class _FieldMetaBuilder {
  Future<_FieldMeta> build(Resolver resolver, FieldElement field) async {
    _parseNullable(field);
    final typeStr = await _parseTypeString(resolver, field);
    return _FieldMeta(
      name: field.name,
      type: field.type,
      typeStr: typeStr,
      isNullable: _isNullable,
      isKeep: _getKeepAnnotation(field) != null,
      isDeepCopy: _getDeepCopyAnnotation(field) != null,
    );
  }

  void _parseNullable(FieldElement field) {
    _isNullable = field.type.nullabilitySuffix == NullabilitySuffix.question;
  }

  Future<String> _parseTypeString(Resolver resolver, FieldElement field) async {
    if (field.type.alias != null) {
      return field.type.alias!.element.name;
    } else {
      final astNode = await resolver.astNodeFor(field, resolve: true);
      final typeStr = astNode!.parent!.childEntities
          .firstWhere((e) => e is TypeAnnotation)
          .toString();
      if (typeStr.endsWith("?")) {
        return typeStr.substring(0, typeStr.length - 1);
      } else {
        return typeStr;
      }
    }
  }

  late bool _isNullable;
}

Ignore? _getIgnoreAnnotation(FieldElement field) {
  if (TypeChecker.fromRuntime(Ignore).hasAnnotationOf(field)) {
    return const Ignore();
  } else {
    return null;
  }
}

Keep? _getKeepAnnotation(FieldElement field) {
  if (TypeChecker.fromRuntime(Keep).hasAnnotationOf(field)) {
    return const Keep();
  } else {
    return null;
  }
}

DeepCopy? _getDeepCopyAnnotation(FieldElement field) {
  if (TypeChecker.fromRuntime(DeepCopy).hasAnnotationOf(field)) {
    return const DeepCopy();
  } else {
    return null;
  }
}
