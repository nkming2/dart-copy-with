/// Used internally as a placeholder for a nullable field
class NullArg {
  const NullArg();

  @override
  bool operator ==(Object other) => other is NullArg;

  @override
  int get hashCode => 0;
}

const copyWithNull = NullArg();
