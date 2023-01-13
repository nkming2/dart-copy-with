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

const genCopyWith = CopyWith();
const ignore = Ignore();
const keep = Keep();
