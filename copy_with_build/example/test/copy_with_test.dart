import 'package:copy_with_example/copy_with.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group("BasicUsage", () {
    test("set value", () {
      final src = Basic(abc: 1, def: 2);
      final dst = src.copyWith(abc: 3);
      expect(dst.abc, 3);
      expect(dst.def, 2);
    });

    test("set null", () {
      final src = Basic(abc: 1, def: 2);
      final dst = src.copyWith(def: null);
      expect(dst.abc, 1);
      expect(dst.def, null);
    });
  });

  group("Polymorphism", () {
    test("call from base", () {
      final inst = Polymorphism(abc: 1, def: 2);
      final BaseClass base = inst;
      final result = base.copyWith(abc: 3);
      expect(result.runtimeType, Polymorphism);
      expect(result.abc, 3);
      expect((result as Polymorphism).def, 2);
    });
  });
}
