import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:build/build.dart';
import 'package:copy_with/copy_with.dart';
import 'package:source_gen/source_gen.dart';

class CopyWithGenerator extends GeneratorForAnnotation<CopyWith> {
  const CopyWithGenerator();

  @override
  dynamic generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      print("Not a class");
      return null;
    }
    final copyWith = CopyWith();
    final clazz = element;
    final fields = _getFields(clazz, copyWith);
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
      return """
extension \$${clazz.name}CopyWith on ${clazz.name} {
  ${clazz.name} copyWith({${_buildParameterBody(fields)}}) => _\$copyWith(${_buildDelegateBody(fields)});

  ${clazz.name} _\$copyWith({${_buildParameterBody(fields)}}) {
    return ${clazz.name}(${_buildConstructorBody(fields)});
  }
}
""";
    }
  }

  String _buildParameterBody(List<_FieldMeta> fields) {
    return fields
        .where((f) => !f.isKeep)
        .map((f) =>
            (f.isNullable ? "Nullable<${f.typeStr}>? " : "${f.typeStr}? ") +
            f.name)
        .join(",");
  }

  String _buildDelegateBody(List<_FieldMeta> fields) {
    return fields
        .where((f) => !f.isKeep)
        .map((f) => "${f.name}: ${f.name}")
        .join(",");
  }

  String _buildConstructorBody(List<_FieldMeta> fields) {
    return fields.map((f) {
      if (f.isKeep) {
        return "${f.name}: ${f.name}";
      } else if (f.isNullable) {
        return "${f.name}: ${f.name} != null ? ${f.name}.obj : this.${f.name}";
      } else {
        return "${f.name}: ${f.name} ?? this.${f.name}";
      }
    }).join(",");
  }

  List<_FieldMeta> _getFields(ClassElement clazz, CopyWith copyWith) {
    final data = <_FieldMeta>[];
    if (clazz.supertype?.isDartCoreObject == false) {
      final parent = clazz.supertype!.element2;
      data.addAll(_getFields(parent as ClassElement, copyWith));
    }
    for (final f
        in clazz.fields.where((f) => _shouldIncludeField(f, copyWith))) {
      final meta = _FieldMetaBuilder().build(f);
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
    required this.typeStr,
    required this.isNullable,
    required this.isKeep,
  });

  final String name;
  final String typeStr;
  final bool isNullable;
  final bool isKeep;
}

class _FieldMetaBuilder {
  _FieldMeta build(FieldElement field) {
    _parseNullable(field);
    final typeStr = _parseTypeString(field);
    return _FieldMeta(
      name: field.name,
      typeStr: typeStr,
      isNullable: _isNullable,
      isKeep: _getKeepAnnotation(field) != null,
    );
  }

  void _parseNullable(FieldElement field) {
    _isNullable = field.type.nullabilitySuffix == NullabilitySuffix.question;
  }

  String _parseTypeString(FieldElement field) {
    if (field.type.alias != null) {
      return field.type.alias!.element.name;
    } else {
      return field.type.getDisplayString(withNullability: false);
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
