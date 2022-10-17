// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todo_list/app/core/notifier/default_notifier.dart';
import 'package:todo_list/app/core/ui/messages.dart';

class DefaultListernerNotifier {
  final DefaultNotifier changeNotifier;

  DefaultListernerNotifier({required this.changeNotifier});

  void listener({
    required BuildContext context,
    required SuccessVoidCallBack successCallBack,
    EverVoidCallBack? everCallBack,
  }) {
    changeNotifier.addListener(() {
      if (everCallBack != null) {
        everCallBack(changeNotifier, this);
      }
      //ouvir loading
      changeNotifier.loading ? Loader.show(context) : Loader.hide();
      //
      if (changeNotifier.hashError) {
        Messages.of(context).showError(changeNotifier.error ?? "Error");
      } else if (changeNotifier.isSuccess) {
        successCallBack(changeNotifier, this);
      }
    });
  }

  void dispose() {
    changeNotifier.removeListener(() {});
  }
}

typedef SuccessVoidCallBack = void Function(
    DefaultNotifier notifier, DefaultListernerNotifier listernerInstance);

typedef EverVoidCallBack = void Function(
    DefaultNotifier notifier, DefaultListernerNotifier listernerInstance);
