import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/vendor/vendor.dart';
import 'package:cirilla/widgets/cirilla_button_social.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutWidget extends StatelessWidget with Utility {
  final Vendor? vendor;

  AboutWidget({
    Key? key,
    this.vendor,
  }) : super(key: key);

  void share(String url, String? linkSocial) {
    bool checkUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    String link = checkUrl
        ? checkUrl as String
        : linkSocial != null
            ? '$linkSocial$url'
            : '';
    if (link is String && link != '') {
      launch(link);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ThemeData theme = Theme.of(context);

    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        // double widthMap = constraints.maxWidth;
        // double heightMap = (widthMap * 210) / 335;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'Our Website can contain links to and from the websites of our partner boutiques, advertisers,and affiliates, amongst others. If you follow a link to any of these websites, please note that this.',
            //   style: theme.textTheme.bodyText2,
            // ),
            // SizedBox(height: 24),
            // Container(
            //   width: widthMap,
            //   height: heightMap,
            //   decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(8)),
            //   alignment: Alignment.center,
            //   child: Text('Map'),
            // ),
            // SizedBox(height: 48),
            buildAddress(context),
            SizedBox(height: 16),
            buildSocial(context),
          ],
        );
      },
    );
  }

  Widget buildItemAddress(BuildContext context, {IconData? icon, required String title}) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16),
        SizedBox(width: 16),
        Expanded(child: Text(title, style: theme.textTheme.bodyText2))
      ],
    );
  }

  Widget buildAddress(BuildContext context) {
    return Column(
      children: [
        buildItemAddress(context, icon: FeatherIcons.phoneForwarded, title: vendor!.phone ?? ''),
        if (vendor!.showEmail! && vendor!.email is String && vendor!.email!.isNotEmpty) ...[
          SizedBox(height: 8),
          buildItemAddress(context, icon: FeatherIcons.mail, title: vendor!.email!),
        ],
        SizedBox(height: 8),
        buildItemAddress(context, icon: FeatherIcons.mapPin, title: vendor!.vendorAddress ?? ''),
      ],
    );
  }

  Widget buildSocial(BuildContext context) {
    String? linkFacebook = vendor!.social is Map ? get(vendor!.social, ['fb'], '') : '';
    String? linkGplus = vendor!.social is Map ? get(vendor!.social, ['gplus'], '') : '';
    String? linkTwitter = vendor!.social is Map ? get(vendor!.social, ['twitter'], '') : '';
    String? linkInstagram = vendor!.social is Map ? get(vendor!.social, ['instagram'], '') : '';
    String? linkYoutube = vendor!.social is Map ? get(vendor!.social, ['youtube'], '') : '';
    String? linkLinkedin = vendor!.social is Map ? get(vendor!.social, ['linkedin'], '') : '';
    String? linkSnapchat = vendor!.social is Map ? get(vendor!.social, ['snapchat'], '') : '';
    String? linkPinterest = vendor!.social is Map ? get(vendor!.social, ['pinterest'], '') : '';
    if (linkFacebook == '' &&
        linkGplus == '' &&
        linkTwitter == '' &&
        linkInstagram == '' &&
        linkYoutube == '' &&
        linkLinkedin == '' &&
        linkSnapchat == '' &&
        linkPinterest == '') {
      return Container();
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (linkFacebook != '')
          CirillaButtonSocial.facebook(
            size: 34,
            sizeIcon: 14,
            boxFit: SocialBoxFit.outline,
            type: SocialType.square,
            onPressed: () => share(linkFacebook!, 'https://www.facebook.com/'),
          ),
        if (linkGplus != '')
          CirillaButtonSocial.google(
            size: 34,
            sizeIcon: 14,
            boxFit: SocialBoxFit.outline,
            type: SocialType.square,
            onPressed: () => share(linkGplus!, null),
          ),
        if (linkTwitter != '')
          CirillaButtonSocial.twitter(
            size: 34,
            sizeIcon: 14,
            boxFit: SocialBoxFit.outline,
            type: SocialType.square,
            onPressed: () => share(linkTwitter!, 'https://twitter.com/'),
          ),
        if (linkInstagram != '')
          CirillaButtonSocial.instagram(
            size: 34,
            sizeIcon: 14,
            boxFit: SocialBoxFit.outline,
            type: SocialType.square,
            onPressed: () => share(linkInstagram!, 'https://www.instagram.com/'),
          ),
        if (linkYoutube != '')
          CirillaButtonSocial.youtube(
            size: 34,
            sizeIcon: 14,
            boxFit: SocialBoxFit.outline,
            type: SocialType.square,
            onPressed: () => share(linkYoutube!, 'https://www.youtube.com/'),
          ),
        if (linkLinkedin != '')
          CirillaButtonSocial.linkedIn(
            size: 34,
            sizeIcon: 14,
            boxFit: SocialBoxFit.outline,
            type: SocialType.square,
            onPressed: () => share(linkLinkedin!, 'https://www.linkedin.com/'),
          ),
        if (linkSnapchat != '')
          CirillaButtonSocial.snapchat(
            size: 34,
            sizeIcon: 14,
            boxFit: SocialBoxFit.outline,
            type: SocialType.square,
            onPressed: () => share(linkSnapchat!, 'https://www.snapchat.com/'),
          ),
        if (linkPinterest != '')
          CirillaButtonSocial.pinterest(
            size: 34,
            sizeIcon: 14,
            boxFit: SocialBoxFit.outline,
            type: SocialType.square,
            onPressed: () => share(linkPinterest!, 'https://www.pinterest.com/'),
          ),
      ],
    );
  }
}
