// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Options extends _Options {
  Options({this.limit, this.sort});

  @override
  int limit;

  @override
  String sort;

  Options copyWith({int limit, String sort}) {
    return Options(limit: limit ?? this.limit, sort: sort ?? this.sort);
  }

  bool operator ==(other) {
    return other is _Options && other.limit == limit && other.sort == sort;
  }

  @override
  int get hashCode {
    return hashObjects([limit, sort]);
  }

  @override
  String toString() {
    return "Options(limit=$limit, sort=$sort)";
  }

  Map<String, dynamic> toJson() {
    return OptionsSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const OptionsSerializer optionsSerializer = OptionsSerializer();

class OptionsEncoder extends Converter<Options, Map> {
  const OptionsEncoder();

  @override
  Map convert(Options model) => OptionsSerializer.toMap(model);
}

class OptionsDecoder extends Converter<Map, Options> {
  const OptionsDecoder();

  @override
  Options convert(Map map) => OptionsSerializer.fromMap(map);
}

class OptionsSerializer extends Codec<Options, Map> {
  const OptionsSerializer();

  @override
  get encoder => const OptionsEncoder();
  @override
  get decoder => const OptionsDecoder();
  static Options fromMap(Map map) {
    return Options(limit: map['limit'] as int, sort: map['sort'] as String);
  }

  static Map<String, dynamic> toMap(_Options model) {
    if (model == null) {
      return null;
    }
    return {'limit': model.limit, 'sort': model.sort};
  }
}

abstract class OptionsFields {
  static const List<String> allFields = <String>[limit, sort];

  static const String limit = 'limit';

  static const String sort = 'sort';
}
