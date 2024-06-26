import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';

final heightscr = StateProvider<double>((ref) {
  return 0;
});

final widthscr = StateProvider<double>((ref) {
  return 0;
});

final loadingSmall = Provider<Widget>((ref) {
  return LoadingAnimationWidget.prograssiveDots(
    color: ref.watch(primaryColor),
    size: ref.read(heightscr)*0.05
  );
});