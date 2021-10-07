// This test video parser url
//

import 'package:flutter_test/flutter_test.dart';

import 'package:cirilla/utils/video_parser_url.dart';

void main() {
  /// Validate Youtube ID
  group('VideoParserUrl - isValidYoutubeId', () {
    test('ID should be validate 11 character', () {
      expect(VideoParserUrl.isValidYoutubeId('12345678910'), true);
    });
    test('ID should not validate special character', () {
      expect(VideoParserUrl.isValidYoutubeId('123!5678910'), false);
    });
    test('ID should not validate less 11 character', () {
      expect(VideoParserUrl.isValidYoutubeId('123456789'), false);
    });
    test('ID should not validate more 11 character', () {
      expect(VideoParserUrl.isValidYoutubeId('12345678910A'), false);
    });
  });

  /// Parser Youtube Video URL
  group('VideoParserUrl - getYoutubeId', () {
    test('It should be return ID in url format https://www.youtube.com/watch?v=S5aK3TIOnIw', () {
      expect(VideoParserUrl.getYoutubeId('https://www.youtube.com/watch?v=S5aK3TIOnIw'), 'S5aK3TIOnIw');
    });
    test('It should be return ID in url format https://youtu.be/S5aK3TIOnIw', () {
      expect(VideoParserUrl.getYoutubeId('https://youtu.be/S5aK3TIOnIw'), 'S5aK3TIOnIw');
    });
    test('It should be return null with not validate URL', () {
      expect(VideoParserUrl.getYoutubeId('youtube.com/watch?v/S5aK3TIOnIw'), null);
    });
    test('It should be return null with not validate URL', () {
      expect(VideoParserUrl.getYoutubeId('youtu.be/S5aK3TIOnIw'), null);
      expect(VideoParserUrl.getYoutubeId('https://youtu.be/S5aTIOnIw'), null);
    });
    test('It should be return null with not validate URL', () {
      expect(VideoParserUrl.getYoutubeId('https://youtu.be/1234'), null);
    });
  });

  /// Parser Vimeo Video URL
  group('VideoParserUrl - getVimeoId', () {
    const String validId = '6701902';

    List<String> allValidUrls = [
      'http://vimeo.com/$validId',
      'http://vimeo.com/$validId',
      'http://player.vimeo.com/video/$validId',
      'http://player.vimeo.com/video/$validId',
      'http://player.vimeo.com/video/$validId?title=0&byline=0&portrait=0',
      'http://player.vimeo.com/video/$validId?title=0&byline=0&portrait=0',
      'http://vimeo.com/channels/ngocdt/$validId',
      'http://vimeo.com/channels/newvide/$validId',
      'http://vimeo.com/channels/appcheap/$validId',
      'http://vimeo.com/$validId',
      'http://vimeo.com/channels/rnlab/$validId',
      'https://vimeo.com/cool/$validId?title=0&amp;byline=0&amp;portrait=0',
      'https://vimeo.com/showcase/7008490/video/$validId',
    ];

    for (final link in allValidUrls) {
      test('Should return ID: $link', () {
        expect(VideoParserUrl.getVimeoId(link), validId);
      });
    }

    List<String> allinValidUrls = [
      'http://vimeo.com/videoschool',
      'http://vimeo.com/videoschool/archive/behind_the_scenes',
      'http://vimeo.com/forums/screening_room',
      'http://vimeo.com/forums/screening_room/topic:42708',
    ];

    for (final link in allinValidUrls) {
      test('Should not valid: $link', () {
        expect(VideoParserUrl.getVimeoId(link), null);
      });
    }
  });
}
