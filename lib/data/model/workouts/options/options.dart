import 'package:angel_serialize/angel_serialize.dart';

part 'options.g.dart';

@serializable
abstract class _Options {
  @SerializableField()
  int limit;

  @SerializableField()
  String sort;
}