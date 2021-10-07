import 'package:flutter/material.dart';

class PolicesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Polices',
          style: theme.textTheme.headline6,
        ),
        SizedBox(height: 16),
        Text(
          'Our Website can contain links to and from the websites of our partner boutiques, advertisers, and affiliates, amongst others. If you follow a link to any of these websites, please note that this. \nPrivacy Policy does not apply to those websites. We are not responsible or liable for the privacy policies or practices of those websites, so please check their policies before you submit any personal data to those websites.',
          style: theme.textTheme.bodyText2,
        )
      ],
    );
  }
}
