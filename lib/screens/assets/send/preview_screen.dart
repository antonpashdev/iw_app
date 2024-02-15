import 'package:flutter/material.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/constants/send_asset_type.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/assets/send/success_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/widgets/state/config.dart';

const LAMPORTS_IN_SOL = 1000000000;

class PreviewScreen extends StatefulWidget {
  final User? receiver;
  final Organization? receiverOrg;
  final String? receiverAddress;
  final Organization organization;
  final OrganizationMember member;
  final double tokens;
  final SendAssetType sendAssetType;

  const PreviewScreen({
    super.key,
    required this.organization,
    required this.member,
    required this.tokens,
    this.receiver,
    this.receiverOrg,
    this.receiverAddress,
    required this.sendAssetType,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _isLoading = false;

  Config get config {
    return ConfigState.of(context).config;
  }

  get equity {
    return config.mode == Mode.Pro
        ? ((widget.tokens * LAMPORTS_IN_SOL) /
            widget.organization.lamportsMinted! *
            100)
        : widget.tokens.toStringAsFixed(1);
  }

  _buildDetails(
    double imageSize,
    double imageRaduis,
    String? imageUrl,
    Widget title,
    Widget description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(imageRaduis),
          ),
          clipBehavior: Clip.antiAlias,
          child: FittedBox(
            fit: BoxFit.cover,
            child: imageUrl != null
                ? NetworkImageAuth(
                    imageUrl: '${orgsApi.baseUrl}$imageUrl',
                  )
                : Image.asset('assets/images/solana.png'),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title,
              description,
            ],
          ),
        ),
      ],
    );
  }

  buildHeader(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: COLOR_LIGHT_GRAY,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _buildDetails(
          40.0,
          15,
          widget.sendAssetType == SendAssetType.ToUser
              ? widget.receiver!.avatar
              : widget.sendAssetType == SendAssetType.ToOrg
                  ? widget.receiverOrg!.logo
                  : null,
          Row(
            children: [
              const Text(
                'To',
                style: TextStyle(
                  color: COLOR_BLUE,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                widget.sendAssetType == SendAssetType.ToUser
                    ? widget.receiver!.name!
                    : widget.sendAssetType == SendAssetType.ToOrg
                        ? widget.receiverOrg!.name!
                        : widget.receiverAddress!.replaceRange(4, 40, '...'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            widget.sendAssetType == SendAssetType.ToUser
                ? '@${widget.receiver!.nickname}'
                : widget.sendAssetType == SendAssetType.ToOrg
                    ? '@${widget.receiverOrg!.username}'
                    : 'Solana Wallet Address',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: COLOR_GRAY,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }

  buildInfoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: COLOR_LIGHT_GRAY,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDetails(
              60,
              20,
              widget.member.org.logo!,
              Text(
                widget.member.org.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '@${widget.member.org.username}',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: COLOR_GRAY,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            if (config.mode == Mode.Pro)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Number of Impact Shares'),
                      Text(
                        widget.tokens.toString(),
                        style: const TextStyle(
                          color: COLOR_ALMOST_BLACK,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(config.mode == Mode.Pro ? 'Equity to Date' : 'Equity'),
                Text(
                  '$equity%',
                  style: const TextStyle(
                    color: COLOR_GREEN,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  sendAssets(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    Config config = ConfigState.of(context).config;
    try {
      await usersApi.sendAssets(
        widget.member.org.id,
        widget.tokens,
        config.mode == Mode.Lite,
        recipientId: widget.receiver?.id!,
        recipientOrgId: widget.receiverOrg?.id!,
        recipientAddress: widget.receiverAddress,
      );
      if (context.mounted) {
        navigateToSuccessScreen(context);
      }
    } catch (ex) {
      print(ex);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  navigateToSuccessScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(
          sharesSent: widget.tokens,
          orgName: widget.member.org.name,
          receiverUsername:
              widget.receiver?.nickname ?? widget.receiverOrg?.username,
          receiverAddress: widget.receiverAddress,
          sendAssetType: widget.sendAssetType,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Preview',
      child: Stack(
        children: [
          Positioned.fill(
            child: KeyboardDismissableListView(
              children: <Widget>[
                buildHeader(context),
                const SizedBox(height: 5),
                buildInfoCard(context),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 290,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => sendAssets(context),
                  child: _isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(
                          config.mode == Mode.Pro
                              ? 'Send Impact Shares'
                              : 'Send $equity% Equity',
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
