class CopyWith {
  const CopyWith({
    this.parent,
  });

  final String? parent;
}

class Ignore {
  const Ignore();
}

class Keep {
  const Keep();
}

class DeepCopy {
  const DeepCopy();
}

const genCopyWith = CopyWith();
const ignore = Ignore();
const keep = Keep();
const deepCopy = DeepCopy();
