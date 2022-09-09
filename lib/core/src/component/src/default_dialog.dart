import 'dart:async';

import 'package:flutter/material.dart';

class DefaultDialog<T> extends StatelessWidget {
  DefaultDialog(
      {Key? key,
      this.title,
      this.content,
      this.color,
      this.buttonLabel,
      this.icon,
      this.onPressed,
      this.autoCloseDuration})
      : super(key: key);
  String? title;
  String? content;
  String? buttonLabel;
  Color? color;
  IconData? icon;
  Duration? autoCloseDuration;
  void Function()? onPressed;
  Future<T?> show(BuildContext context) async {
    bool isClosed = false;
    if (autoCloseDuration != null) {
      Timer(
        autoCloseDuration!,
        () {
          if (!isClosed) {
            Navigator.pop(context);
          }
        },
      );
    }
    return await showDialog<T?>(
        context: context,
        builder: (_) {
          return DefaultDialog(
            icon: icon,
            title: title,
            content: content,
            buttonLabel: buttonLabel,
            color: color,
            onPressed: onPressed,
          );
        }).then((value) {
      isClosed = true;
      return value;
    });
  }

  Future<T?> showSuccess(BuildContext context) async {
    bool isClosed = false;
    if (autoCloseDuration != null) {
      Timer(
        autoCloseDuration!,
        () {
          if (!isClosed) {
            Navigator.pop(context);
          }
        },
      );
    }
    return await showDialog<T?>(
        context: context,
        builder: (_) {
          return DefaultDialog(
            icon: icon ?? Icons.check_circle,
            title: title,
            content: content,
            buttonLabel: buttonLabel,
            color: color,
            onPressed: onPressed,
          );
        }).then((value) {
      isClosed = true;
      return value;
    });
  }

  Future<T?> showError(BuildContext context) async {
    bool isClosed = false;
    if (autoCloseDuration != null) {
      Timer(
        autoCloseDuration!,
        () {
          if (!isClosed) {
            Navigator.pop(context);
          }
        },
      );
    }
    return await showDialog<T?>(
        context: context,
        builder: (_) {
          return DefaultDialog(
            icon: icon ?? Icons.error,
            title: title ?? "Error",
            content: content,
            buttonLabel: buttonLabel,
            color: color ?? Colors.red,
            onPressed: onPressed,
          );
        }).then((value) {
      isClosed = true;
      return value;
    });
  }

  Future<T?> showWarning(BuildContext context) async {
    bool isClosed = false;
    if (autoCloseDuration != null) {
      Timer(
        autoCloseDuration!,
        () {
          if (!isClosed) {
            Navigator.pop(context);
          }
        },
      );
    }
    return await showDialog<T?>(
        context: context,
        builder: (_) => DefaultDialog(
              icon: icon ?? Icons.warning,
              title: title,
              content: content,
              buttonLabel: buttonLabel,
              color: color ?? Colors.yellow,
              onPressed: onPressed,
            )).then((value) {
      isClosed = true;
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Card(
          elevation: 10,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close))),
                if (icon != null)
                  Icon(
                    icon,
                    color: color ?? Colors.green,
                    size: MediaQuery.of(context).size.width * 0.14,
                  ),
                if (icon != null)
                  const SizedBox(
                    height: 16,
                  ),
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                if (title != null)
                  const SizedBox(
                    height: 10,
                  ),
                if (content != null)
                  Text(
                    content!,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                if (content != null || title != null)
                  const SizedBox(
                    height: 16,
                  ),
                if (buttonLabel != null)
                  InkWell(
                    onTap: () => onPressed ?? () => Navigator.pop(context),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(buttonLabel!),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
