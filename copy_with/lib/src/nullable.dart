/// To hold optional arguments that themselves could be null
class Nullable<T> {
  const Nullable(this.obj);

  final T? obj;
}
