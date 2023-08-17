import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool permissionGranted = false;

  _checkPushPermission() async {
    html.Notification.requestPermission().then(
      (permission) => {
        if (permission == 'granted')
          {
            setState(() {
              permissionGranted = true;
            })
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Notifications',
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('All notifications'),
                CupertinoButton(
                  child: const Text('send notification'),
                  onPressed: () {
                    html.Notification(
                      'title',
                      body: 'body',
                      icon: 'icon.png',
                      tag: 'tag',
                    );
                  },
                ),
                CupertinoSwitch(
                  value: permissionGranted,
                  onChanged: (value) async {
                    if (!permissionGranted) {
                      _checkPushPermission().then(
                        (value) => setState(
                          () {
                            permissionGranted = value ?? false;
                          },
                        ),
                      );
                    }
                  },
                )
              ],
            )
          ],
        ));
  }
}
