# copy-with
Generate copyWith() for classes

## Usage

```dart
@copyWith
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
