class CopyWith {
  const CopyWith({
    this.parent,
  });

  final String? parent;
}

/// Ignore this field.
///
/// Usage:
/// ```dart
/// class Foo {
///   @ignore
///   int bar;
/// }
/// ```
///
/// In this case, the generated copyWith will be equivalent to something like:
/// ```dart
/// Foo copyWith() {
///   return Foo();
/// }
/// ```
class Ignore {
  const Ignore();
}

/// Always keep the value from this.
///
/// Usage:
/// ```dart
/// class Foo {
///   @keep
///   int bar;
/// }
/// ```
///
/// In this case, the generated copyWith will be equivalent to something like:
/// ```dart
/// Foo copyWith() {
///   return Foo(bar: this.bar);
/// }
/// ```
class Keep {
  const Keep();
}

/// Create a new instance of a container and copy its content over instead of
/// copying the container itself.
///
/// Usage:
/// ```dart
/// class Foo {
///   @keep
///   List<int> bar;
/// }
/// ```
///
/// In this case, the generated copyWith will be equivalent to something like:
/// ```dart
/// Foo copyWith({List<int>? bar}) {
///   return Foo(bar: bar ?? List.of(this.bar));
/// }
/// ```
///
/// Only support [List], [Map] or [Set].
class DeepCopy {
  const DeepCopy();
}

const genCopyWith = CopyWith();
const ignore = Ignore();
const keep = Keep();
const deepCopy = DeepCopy();
