import 'package:flutter/material.dart';

import '../view/shared/widgets/overlay_loading_progress.dart';

extension ContextExtension on BuildContext {
  push(MaterialPageRoute<dynamic> route) {
    return Navigator.of(this).push(route);
  }

  pushWidget(Widget page) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
  }

  pushReplacementWidget(Widget page) {
    return Navigator.of(this)
        .pushReplacement(MaterialPageRoute(builder: (_) => page));
  }

  pushNamed(String routeName, {dynamic arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  pushReplacementNamed(String routeName, {dynamic arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  pushNamedAndRemoveUntil(route, bool popToInitial) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(route, (route) => popToInitial);
  }

  pushNamedAndRemoveUntilRouteName(route, routeName) {
    return Navigator.of(this).pushNamedAndRemoveUntil(
        route, (route) => route.settings.name == routeName);
  }

  pop({dynamic arguments, bool? rootNavigator}) {
    return Navigator.of(this, rootNavigator: rootNavigator ?? false)
        .pop(arguments);
  }

  popUntil(String routeName) {
    return Navigator.of(this)
        .popUntil((route) => route.settings.name == routeName);
  }

  goBack() {
    return pop();
  }

  popTwice({dynamic arguments}) {
    pop();
    return pop(arguments: arguments);
  }

  // styles extension
  TextStyle? bodyXSmall() {
    return Theme.of(this).textTheme.bodySmall?.copyWith(fontSize: 10);
  }

  TextStyle? bodySmall() {
    return Theme.of(this).textTheme.bodySmall;
  }

  TextStyle? bodyMedium() {
    return Theme.of(this).textTheme.bodyMedium;
  }

  TextStyle? bodyLarge() {
    return Theme.of(this).textTheme.bodyLarge;
  }

  TextStyle? titleSmall() {
    return Theme.of(this).textTheme.titleSmall;
  }

  TextStyle? titleMedium() {
    return Theme.of(this).textTheme.titleMedium;
  }

  TextStyle? titleLarge() {
    return Theme.of(this).textTheme.titleLarge;
  }
}

extension ProgressIndicator on BuildContext {
  Widget progressIndicator({double? height, double? width, Color? bgColor}) {
    return Container(
      width: width,
      height: height,
      color: bgColor,
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 1,
        color: Theme.of(this).primaryColor,
      ),
    );
  }

  Widget progressIndicatorWithText(
      {double? height, double? width, String loadingText = 'Loading'}) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12,
        children: [
          CircularProgressIndicator(
            strokeWidth: 1,
            color: Theme.of(this).primaryColor,
          ),
          Text(
            loadingText,
            style: bodyMedium(),
          )
        ],
      ),
    );
  }
}

extension SnackBarExt on BuildContext {
  snackBar({required String message}) {
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        content: Text(
          message,
          style: bodyMedium()?.textColor(Colors.white),
        ),
        duration: const Duration(seconds: 2),
        //backgroundColor: themeColorLight,
      ));
    });
  }

  snackBarWithAction({required String message}) {
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        content: Text(
          message,
          style: bodyMedium()?.textColor(Colors.white),
        ),
        duration: const Duration(seconds: 20),
        //backgroundColor: themeColorLight,
        action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              ScaffoldMessenger.of(this).hideCurrentSnackBar();
            }),
      ));
    });
  }

  showLoader({Widget? widget}) {
    OverlayLoadingProgress.start(this, widget: widget);
  }

  hideLoader() {
    OverlayLoadingProgress.stop();
  }
}

extension ThemeExt on BuildContext {
  ThemeData theme() {
    return Theme.of(this);
  }

  Brightness brightness() {
    return Theme.of(this).brightness;
  }

  // Color themeTextColor() {
  //   return brightness() == Brightness.light ? textColorLight : textColorDark;
  // }

  // Color dividerColor() {
  //   return brightness() == Brightness.light ? themeColorLight : Colors.white70;
  // }

  // Color scaffoldColor() {
  //   return brightness() == Brightness.light
  //       ? scaffoldColorLight
  //       : scaffoldColorDark;
  // }
}

extension TextStyleExtension on TextStyle {
  TextStyle bold({FontWeight? fontWeight}) {
    return copyWith(fontWeight: fontWeight ?? FontWeight.bold);
  }

  TextStyle size(double fontSize) {
    return copyWith(fontSize: fontSize);
  }

  TextStyle textColor(Color? color) {
    return copyWith(color: color);
  }
}

extension WidgetExtension on Widget {
  Widget container(
      {double? width,
      double? height,
      Decoration? decoration,
      Color? color,
      Alignment? alignment,
      EdgeInsets? padding}) {
    return Container(
      width: width,
      height: height,
      color: color,
      decoration: decoration,
      padding: padding,
      alignment: alignment,
      child: this,
    );
  }

  Widget circularBgFilled(
      {double? width,
      double? height,
      Color? color,
      Alignment? alignment,
      EdgeInsets? padding}) {
    return container(
        width: width,
        height: height,
        padding: padding,
        alignment: alignment,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200), color: color));
  }

  Widget circularBgOutlined(
      {double? width,
      double? height,
      required color,
      Alignment? alignment,
      EdgeInsets? padding}) {
    return container(
        width: width,
        height: height,
        padding: padding,
        alignment: alignment,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200),
            border: Border.all(color: color)));
  }

  Widget centre() {
    return Center(
      child: this,
    );
  }

  Widget size({double? width, double? height}) {
    return SizedBox(
      height: height,
      width: width,
      child: this,
    );
  }

  Widget expanded({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  Widget flexible({int flex = 1}) {
    return Flexible(
      flex: flex,
      child: this,
    );
  }

  Widget align(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  Widget scrollable(
      {Axis scrollDirection = Axis.vertical, ScrollPhysics? physics}) {
    return SingleChildScrollView(
      physics: physics ?? const BouncingScrollPhysics(),
      scrollDirection: scrollDirection,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: this,
    );
  }

  Widget padding(EdgeInsets insets) {
    return Padding(
      padding: insets,
      child: this,
    );
  }

  Widget showBoundary({Color color = Colors.red}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: color, // Color of the border
          width: 2.0, // Width of the border
        ),
      ),
      child: this, // Replace with your widget
    );
  }

  Widget iconWidget({IconData? icon}) {
    return Icon(
      icon,
      size: 25,
    );
  }
}

extension DividerExt on int {
  Widget width() {
    return SizedBox(
      width: toDouble(),
    );
  }

  Widget height() {
    return SizedBox(
      height: toDouble(),
    );
  }
}

extension MapExt on Map<String, dynamic> {
  String getString(String key, {String? alternateKey}) {
    return this[key] ?? this[alternateKey] ?? '';
  }

  int getInt(String key) {
    return this[key] ?? 0;
  }

  double getDoule(String key) {
    return this[key] ?? 0.0;
  }

  bool getBool(String key) {
    return this[key] ?? false;
  }
}

extension StringBase64 on String {
  String getBase64FileExtension() {
    switch (characters.first) {
      case '/':
        return '.jpeg';
      case 'i':
        return '.png';
      case 'R':
        return '.gif';
      case 'U':
        return '.webp';
      case 'J':
        return '.pdf';
      default:
        return '.unknown';
    }
  }
}
