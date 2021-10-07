import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';

class Language {
  /// the country code (IT,AF..)
  String? code;

  /// the locale (en, es, da)
  String? locale;

  /// the full name of language (English, Danish..)
  String? language;

  /// map of keys used based on industry type (service worker, route etc)
  Map<String, String>? dictionary;

  Language({this.code, this.locale, this.language, this.dictionary});
}

@JsonLiteral('data.json')
Map get getLanguages => _$getLanguagesJsonLiteral;
