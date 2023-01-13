# copy-with
Generate copyWith() for classes

## Usage

```dart
@genCopyWith
class MyClass {
  const MyClass({
    required this.a,
    required this.b,
  });

  final int a;
  final int b;
}
// MyClass().copyWith(a: 1)
```

Derived class is supported:
```dart
class Base {
  const Base({
    required this.a,
  });

  final int a;
}

@genCopyWith
class Derived {
  const Derived({
    required this.b,
  });

  final int b;
}
// Derived().copyWith(a: 1)
```

If polymorphism is needed,
```dart
@genCopyWith
class Base {
  const Base({
    required this.a,
  });

  $BaseCopyWithWorker get copyWith => _$copyWith;

  final int a;
}

@CopyWith(parent: "Base")
class Derived {
  const Derived({
    required this.b,
  });

  @override
  $BaseCopyWithWorker get copyWith => _$copyWith;

  final int b;
}
// final obj = Base().copyWith(a: 1); // type of obj is Derived
```

