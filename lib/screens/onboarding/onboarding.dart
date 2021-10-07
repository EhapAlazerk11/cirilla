import 'package:cirilla/constants/app.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

double heightPagination = 112;

class OnBoardingScreen extends StatefulWidget {
  static const routeName = '/onBoarding';

  final SettingStore? store;

  OnBoardingScreen({
    Key? key,
    this.store,
  }) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnBoardingScreen> with Utility, NavigationMixin, GeneralMixin {
  final SwiperController _controller = SwiperController();

  Future<void> clickGetStart(BuildContext context) async {
    await widget.store!.closeGetStart();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    String themeModeKey = widget.store?.themeModeKey ?? 'value';
    String language = widget.store?.locale ?? defaultLanguage;
    String languageKey = widget.store?.languageKey ?? 'text';

    return buildScreen(
      dataScreen: widget.store!.data!,
      theme: theme,
      themeModeKey: themeModeKey,
      language: language,
      languageKey: languageKey,
      translate: translate,
    );
  }

  Widget buildScreen({
    required DataScreen dataScreen,
    String? themeModeKey,
    String? language,
    String? languageKey,
    ThemeData? theme,
    TranslateType? translate,
  }) {
    // Configs
    Data? data = dataScreen.screens != null && dataScreen.screens!['onBoarding'] != null
        ? dataScreen.screens!['onBoarding']
        : null;
    WidgetConfig? widgetConfig = data != null ? data.widgets!['onBoardingPage'] : null;

    if (widgetConfig == null) {
      return Scaffold();
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String layout = widgetConfig.layout ?? 'default';
    Map<String, dynamic> styles = widgetConfig.styles ?? {};
    Map<String, dynamic> fields = widgetConfig.fields ?? {};

    Color backgroundColor =
        ConvertData.fromRGBA(get(styles, ['backgroundItem', themeModeKey], {}), theme!.scaffoldBackgroundColor);
    Color skipColor =
        ConvertData.fromRGBA(get(styles, ['skipColor', themeModeKey], {}), theme.textTheme.caption!.color);
    Color indicatorColor = ConvertData.fromRGBA(get(styles, ['indicatorColor', themeModeKey], {}), theme.dividerColor);
    Color indicatorActiveColor =
        ConvertData.fromRGBA(get(styles, ['indicatorActiveColor', themeModeKey], {}), theme.textTheme.caption!.color);

    bool? enablePagination = get(fields, ['enablePagination'], true);
    List items = get(fields, ['items'], []);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: items.length > 0
          ? SizedBox(
              width: width,
              height: height,
              child: Swiper(
                physics: ClampingScrollPhysics(),
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  dynamic item = items.elementAt(index) is Map ? get(items.elementAt(index), ['data'], {}) : null;
                  if (item is Map && item.isNotEmpty) {
                    return buildItem(
                      context,
                      layout: layout,
                      item: item,
                      styles: styles,
                      width: width,
                      height: height,
                      language: language,
                      languageKey: languageKey,
                      themeModeKey: themeModeKey,
                      theme: theme,
                    );
                  }
                  return Container();
                },
                itemCount: items.length,
                itemWidth: width,
                itemHeight: height,
                loop: false,
                pagination: SwiperCustomPagination(
                  builder: (_, SwiperPluginConfig? config) {
                    int activeIndex = config?.activeIndex ?? 0;
                    String textButton = activeIndex == items.length - 1
                        ? translate!('on_boarding_get_start')!
                        : translate!('on_boarding_next')!;

                    return Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Container(
                        height: heightPagination,
                        padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                        alignment: AlignmentDirectional.topStart,
                        child: Row(
                          children: [
                            Expanded(
                              child: enablePagination!
                                  ? Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: List.generate(items.length, (index) {
                                        double sizeDot = index == activeIndex ? 10 : 6;
                                        Color colorDot = index == activeIndex ? indicatorActiveColor : indicatorColor;
                                        return Container(
                                          width: sizeDot,
                                          height: sizeDot,
                                          decoration: BoxDecoration(color: colorDot, shape: BoxShape.circle),
                                        );
                                      }),
                                    )
                                  : Container(),
                            ),
                            TextButton(
                              onPressed: () => clickGetStart(context),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text(translate('on_boarding_skip')!),
                              ),
                              style: TextButton.styleFrom(
                                primary: skipColor,
                                textStyle: theme.textTheme.caption,
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 48),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (activeIndex == items.length - 1) {
                                  clickGetStart(context);
                                } else {
                                  _controller.next(animation: true);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: [
                                    Text(textButton),
                                    SizedBox(width: 8),
                                    Icon(FeatherIcons.arrowRight, size: 16),
                                  ],
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                textStyle: theme.textTheme.subtitle2,
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 48),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : null,
    );
  }

  Widget buildItem(
    BuildContext context, {
    Map? item,
    String? layout,
    Map<String, dynamic>? styles,
    double? width,
    double? height,
    String? language,
    String? languageKey,
    String? themeModeKey,
    required ThemeData theme,
  }) {
    String? image = ConvertData.imageFromConfigs(get(item, ['image'], ''), language);
    String? title = get(item, ['title', languageKey], '');
    String? subTitle = get(item, ['subTitle', languageKey], '');

    Color titleColor =
        ConvertData.fromRGBA(get(styles, ['titleColor', themeModeKey], {}), theme.textTheme.headline5!.color);
    Color subtitleColor =
        ConvertData.fromRGBA(get(styles, ['subtitleColor', themeModeKey], {}), theme.textTheme.bodyText2!.color);
    double? titleSize = ConvertData.stringToDouble(get(styles, ['titleSize'], 28));
    double? subtitleSize = ConvertData.stringToDouble(get(styles, ['subtitleSize'], 14));

    switch (layout) {
      case 'overlay':
        double opacity = ConvertData.stringToDouble(get(styles, ['opacity'], 0.9));
        Color gradientFrom = ConvertData.fromRGBA(get(styles, ['gradientFrom', themeModeKey], {}), Colors.transparent);
        Color gradientTo = ConvertData.fromRGBA(get(styles, ['gradientTo', themeModeKey], {}), Color(0xFF210B01));
        Color dividerColor =
            ConvertData.fromRGBA(get(styles, ['dividerColor', themeModeKey], {}), Color.fromRGBO(255, 255, 255, 0.2));

        Gradient gradient = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[gradientFrom, gradientTo],
        );

        return Stack(
          children: [
            CirillaCacheImage(image, width: width, height: height),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: gradient,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 0,
              bottom: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: theme.textTheme.headline5!
                        .copyWith(color: titleColor, fontSize: titleSize, fontWeight: FontWeight.w700),
                  ),
                  Container(
                    width: 50,
                    height: 2,
                    color: dividerColor,
                    margin: EdgeInsets.symmetric(vertical: 16),
                  ),
                  Text(
                    subTitle!,
                    style: theme.textTheme.bodyText2!.copyWith(color: subtitleColor, fontSize: subtitleSize),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        double? widthImage = width;
        double heightImage = (height! * 400) / 812;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CirillaCacheImage(image, width: widthImage, height: heightImage),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20, 48, 20, 0),
                physics: ClampingScrollPhysics(),
                children: [
                  Text(
                    title!,
                    style: theme.textTheme.headline5!
                        .copyWith(color: titleColor, fontSize: titleSize, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    subTitle!,
                    style: theme.textTheme.bodyText2!.copyWith(color: subtitleColor, fontSize: subtitleSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: heightPagination),
          ],
        );
    }
  }
}
