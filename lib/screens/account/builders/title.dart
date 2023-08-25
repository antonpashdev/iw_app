import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/account_model.dart';
import 'package:iw_app/theme/app_theme.dart';

buildTitle(Account account) {
  return [
    Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: FittedBox(
        fit: BoxFit.cover,
        child: account.image != null
            ? FutureBuilder(
                future: usersApi.getAvatar(account.image!),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return Image.memory(snapshot.data!);
                },
              )
            : const Icon(
                Icons.person,
                color: Color(0xFFBDBDBD),
              ),
      ),
    ),
    const SizedBox(width: 10),
    Text(
      account.username!,
      style: const TextStyle(fontWeight: FontWeight.normal),
    ),
  ];
}
