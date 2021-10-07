/// Register more extension for String
extension StringParse on String {
  /// Remove special symbols in String
  String get removeSymbols {
    return this.replaceAll(new RegExp(r'[^\w\s]+'), '');
  }

  /// Remove special character
  String get normalize {
    String specialChar = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    String withoutSpecialChar = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';
    String str = this;
    for (int i = 0; i < specialChar.length; i++) {
      str = str.replaceAll(specialChar[i], withoutSpecialChar[i]);
    }
    return str;
  }
}

extension CapExtension on String {
  String get inCaps => this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';

  String get allInCaps => this.toUpperCase();

  String get capitalizeFirstofEach => this.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" ");
}
