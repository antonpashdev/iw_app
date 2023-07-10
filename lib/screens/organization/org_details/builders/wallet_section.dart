import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/theme/app_theme.dart';

buildWalletSection(BuildContext context, Organization org) {
  return Column(
    children: [
      Center(
        child: TextButton.icon(
          onPressed: () => _handleCopyPressed(context, org.wallet!),
          style: const ButtonStyle(
            visualDensity: VisualDensity(vertical: 1),
          ),
          icon: SvgPicture.asset(
            'assets/icons/wallet.svg',
            width: 30,
          ),
          label: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Solana Address',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: COLOR_GRAY, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    org.wallet!.replaceRange(8, 36, '...'),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.copy,
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

_handleCopyPressed(BuildContext ctx, String text) async {
  Clipboard.setData(ClipboardData(text: text));
  _callSnackBar(ctx);
}

_callSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 70,
        left: 20,
        right: 20,
      ),
      content: const Text(
        'Copied to clipboard',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 300),
      backgroundColor: Colors.black.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
