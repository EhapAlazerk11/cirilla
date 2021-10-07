/// Parser video url
///
class VideoParserUrl {
  static const String vimeoRegexUrl = r'(?:https?:\/\/)?(?:www\.)?vimeo\.com\/(?:(?:[a-z0-9]*\/)*\/?)?([0-9]+)';

  /// Is video Youtube ID
  static bool isValidYoutubeId(String id) => RegExp(r'^[_\-a-zA-Z0-9]{11}$').hasMatch(id);

  /// Valid full Youtube Url
  static bool isValidFullYoutubeUrl(String url) {
    final Uri uri = Uri.parse(url);

    if (['youtube.com', 'www.youtube.com', 'm.youtube.com'].contains(uri.host) &&
        uri.pathSegments.first == 'watch' &&
        uri.queryParameters.containsKey('v')) {
      return true;
    }

    return false;
  }

  /// Valid sort Youtube Url
  static bool isValidSortYoutubeUrl(String url) {
    final Uri uri = Uri.parse(url);

    if (['youtu.be'].contains(uri.host)) {
      return true;
    }

    return false;
  }

  /// Parser Youtube URL
  static String? getYoutubeId(String? url) {
    if (url == null) return null;

    final Uri uri;

    // Parser URL
    try {
      uri = Uri.parse(url);
    } catch (e) {
      return null;
    }

    // Return if url not contain protocol
    if (!['https', 'http'].contains(uri.scheme)) {
      return null;
    }

    // Return if url not include path segments
    if (uri.pathSegments.isEmpty) {
      return null;
    }

    // Link format https://www.youtube.com/watch?v=xxxxxxxxxxx
    if (isValidFullYoutubeUrl(url)) {
      final videoId = uri.queryParameters['v']!;
      return isValidYoutubeId(videoId) ? videoId : null;
    }

    // Link format https://www.youtube.com/xxxxxxxxxxx
    if (isValidSortYoutubeUrl(url)) {
      final videoId = uri.pathSegments.first;
      return isValidYoutubeId(videoId) ? videoId : null;
    }

    // Return null not validate youtube link
    return null;
  }

  /// Is Vimeo validate URL
  static bool isValidVimeoUrl(String url) {
    final regex = RegExp(vimeoRegexUrl, caseSensitive: false, multiLine: false);
    return regex.hasMatch(url);
  }

  /// Parser Vimeo URL
  static String? getVimeoId(String? url) {
    if (url == null) return null;
    final regex = RegExp(vimeoRegexUrl, caseSensitive: false, multiLine: false);
    return isValidVimeoUrl(url) ? regex.firstMatch(url)?.group(1) : null;
  }
}
