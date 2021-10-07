import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/models/post/post.dart';
import 'package:flutter/material.dart';

import 'layout/layout_default.dart';
import 'layout/layout_curve_top.dart';
import 'layout/layout_curve_bottom.dart';
import 'layout/layout_overlay.dart';
import 'layout/layout_gradient.dart';
import 'layout/layout_stack.dart';
import 'layout/layout_layer.dart';

List<dynamic> initRows = [
  {
    'data': {
      'mainAxisAlignment': 'start',
      'crossAxisAlignment': 'start',
      'divider': false,
      'columns': [
        {
          'value': {'type': 'Category', 'enableFlex': true, 'flex': '1'}
        }
      ]
    },
  },
  {
    'data': {
      'mainAxisAlignment': 'start',
      'crossAxisAlignment': 'start',
      'divider': false,
      'columns': [
        {
          'value': {'type': 'Name', 'enableFlex': true, 'flex': '1'}
        }
      ]
    },
  },
  {
    'data': {
      'mainAxisAlignment': 'start',
      'crossAxisAlignment': 'start',
      'divider': false,
      'columns': [
        {
          'value': {'type': 'Author', 'enableFlex': false, 'flex': '1'}
        },
        {
          'value': {'type': 'CountComment', 'enableFlex': false, 'flex': '1'}
        },
        {
          'value': {'type': 'Date', 'enableFlex': false, 'flex': '1'}
        }
      ]
    },
  },
  {
    'data': {
      'mainAxisAlignment': 'start',
      'crossAxisAlignment': 'start',
      'divider': false,
      'columns': [
        {
          'value': {'type': 'FeatureImage', 'enableFlex': true, 'flex': '1'}
        }
      ]
    },
  },
  {
    'data': {
      'mainAxisAlignment': 'start',
      'crossAxisAlignment': 'start',
      'divider': false,
      'columns': [
        {
          'value': {'type': 'Content', 'enableFlex': true, 'flex': '1'}
        }
      ]
    },
  },
  {
    'data': {
      'mainAxisAlignment': 'start',
      'crossAxisAlignment': 'start',
      'divider': false,
      'columns': [
        {
          'value': {'type': 'Tag', 'enableFlex': true, 'flex': '1'}
        }
      ]
    },
  },
  {
    'data': {
      'mainAxisAlignment': 'start',
      'crossAxisAlignment': 'start',
      'divider': false,
      'columns': [
        {
          'value': {'type': 'Comments', 'enableFlex': true, 'flex': '1'}
        }
      ]
    },
  },
];

class PostHtml extends StatelessWidget {
  final Post? post;
  final String? layout;
  final Map<String, dynamic>? styles;
  final Map<String, dynamic>? configs;
  final List<dynamic>? rows;

  const PostHtml({
    Key? key,
    required this.post,
    this.layout = Strings.postDetailLayoutDefault,
    this.styles,
    this.configs,
    this.rows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List dataRows = rows ?? initRows;
    switch (layout) {
      case Strings.postDetailLayoutCurveTop:
        return LayoutCurveTop(post: post, styles: styles, configs: configs, rows: dataRows);
      case Strings.postDetailLayoutCurveBottom:
        return LayoutCurveBottom(post: post, styles: styles, configs: configs, rows: dataRows);
      case Strings.postDetailLayoutOverlay:
        return LayoutOverlay(
          post: post,
          styles: styles,
          configs: configs,
          rows: dataRows,
        );
      case Strings.postDetailLayoutGradient:
        return LayoutGradient(post: post, styles: styles, configs: configs, rows: dataRows);
      case Strings.postDetailLayoutStack:
        return LayoutStack(
          post: post,
          styles: styles,
          configs: configs,
          rows: dataRows,
        );
      case Strings.postDetailLayoutLayer:
        return LayoutLayer(
          post: post,
          styles: styles,
          configs: configs,
          rows: dataRows,
        );
      default:
        return LayoutDefault(post: post, styles: styles, configs: configs, rows: dataRows);
    }
  }
}
