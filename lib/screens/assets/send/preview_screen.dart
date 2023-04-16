import 'package:flutter/material.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/assets/send/success_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:transparent_image/transparent_image.dart';

const LAMPORTS_IN_SOL = 1000000000;

class PreviewScreen extends StatefulWidget {
  final User receiver;
  final Organization organization;
  final OrganizationMember member;
  final double tokens;

  const PreviewScreen(
      {super.key,
      required this.organization,
      required this.member,
      required this.tokens,
      required this.receiver});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _isLoading = false;

  _buildDetails(double imageSize, double imageRaduis, String? imageUrl,
      Widget title, Widget description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            color: COLOR_GRAY,
            borderRadius: BorderRadius.circular(imageRaduis),
          ),
          clipBehavior: Clip.antiAlias,
          child: FittedBox(
            fit: BoxFit.cover,
            child: imageUrl != null
                ? NetworkImageAuth(
                    imageUrl: '${orgsApi.baseUrl}$imageUrl',
                  )
                : Image(
                    image: MemoryImage(kTransparentImage),
                  ),
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
            widget.receiver.avatar,
            Row(
              children: [
                const Text('To',
                    style: TextStyle(
                        color: COLOR_BLUE, fontWeight: FontWeight.w600)),
                const SizedBox(width: 3),
                Text(
                  widget.receiver.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
            Text(
              '@${widget.receiver.nickname}',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: COLOR_GRAY,
                    fontWeight: FontWeight.w500,
                  ),
            )),
      ),
    );
  }

  buildInfoCard(BuildContext context) {
    final equity = ((widget.tokens * LAMPORTS_IN_SOL) /
            widget.organization.lamportsMinted! *
            100)
        .toStringAsFixed(1);
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
                )),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Number of Impact Shares',
                  style: TextStyle(
                      color: COLOR_ALMOST_BLACK,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Text(
                  widget.tokens.toString(),
                  style: const TextStyle(
                      color: COLOR_ALMOST_BLACK, fontWeight: FontWeight.w700),
                )
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Equity to Date',
                  style: TextStyle(
                      color: COLOR_ALMOST_BLACK,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Text(
                  '$equity%',
                  style: const TextStyle(
                      color: COLOR_GREEN, fontWeight: FontWeight.w700),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  sendAssets(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await usersApi.sendAssets(
        widget.member.org.id,
        widget.receiver.id!,
        widget.tokens,
      );
      if (context.mounted) {
        navigateToSuccessScreen(context);
      }
    } catch (ex) {
      print('error happened');
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
                  receiverNickName: widget.receiver.nickname,
                )),
        (route) => false);
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
                        : const Text('Send Impact Shares'),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
