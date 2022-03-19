import 'package:flutter/material.dart';
import 'package:login/notification-model.dart';

import 'M.S.dart';
import 'lang.dart';



class NotificationsWidget extends StatelessWidget {
  const NotificationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NotificationModel>>(
      stream: FirebaseManager.shared.getMyNotifications(),
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          List<NotificationModel> items = [];

          for (var item in snapshot.data!) {
            if (!item.isRead) {
              items.add(item);
            }
          }

          return Padding(
              padding: const EdgeInsets.all(10),
              child: Stack(
                children: [
                  IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.blue,),
                      tooltip: AppLocalization.of(context)!.trans(
                          "Notifications"),
                      onPressed: () =>
                          Navigator.of(context).pushNamed("/Notification")),
                  Visibility(
                    visible: items.isNotEmpty,
                    child: Positioned(
                        top: -3,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(items.length.toString(), style: const TextStyle(fontSize: 12),),
                        )),
                  ),
                ],
              ),
            );
        } else {
          return const SizedBox();
        }

      }
    );
  }
}
