import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/app_home.dart';
import 'package:iw_app/models/contribution_model.dart';
import 'package:iw_app/screens/contribution/contribution_details_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';

class ContributionScreen extends StatefulWidget {
  final Contribution contribution;
  final bool showSnackBar;

  const ContributionScreen({
    Key? key,
    required this.contribution,
    this.showSnackBar = false,
  }) : super(key: key);

  @override
  State<ContributionScreen> createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> {
  bool isLoading = false;

  @override
  initState() {
    super.initState();
    if (widget.showSnackBar) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => callSnackBar(context));
    }
  }

  callSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 70,
          left: 20,
          right: 20,
        ),
        content: const Text(
          'Time you started contributing was recorded',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: const Duration(milliseconds: 1000),
        backgroundColor: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: COLOR_GRAY,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: FittedBox(
            fit: BoxFit.cover,
            child: NetworkImageAuth(
              imageUrl: '${orgsApi.baseUrl}${widget.contribution.org.logo}',
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'to',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: COLOR_GRAY),
              ),
              Text(
                widget.contribution.org.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '@${widget.contribution.org.username}',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: COLOR_GRAY,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildMainSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(color: COLOR_ALMOST_BLACK),
            children: [
              WidgetSpan(child: SizedBox(width: 50)),
              TextSpan(text: 'Your future is created'),
              TextSpan(text: '\nby what you do today'),
              WidgetSpan(child: SizedBox(width: 50)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Transform.rotate(
            angle: -math.pi / 50,
            child: Image.asset(
              'assets/images/contribution_gif.gif',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
        ),
      ],
    );
  }

  navigateToDetails(Contribution contribution) {
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => ContributionDetailsScreen(contribution: contribution),
        ),
        (route) => false,
      );
    }
  }

  handleStopContributionPressed(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await orgsApi.stopContribution(
        widget.contribution.org.id,
        widget.contribution.id!,
      );
      final stoppedContribution = Contribution.fromJson(response.data);
      navigateToDetails(stoppedContribution);
    } on DioError catch (error) {
      print(error);
      if (error.response!.statusCode == HttpStatus.forbidden) {
        final stoppedContribution =
            Contribution.fromJson(error.response!.data['contribution']);
        navigateToDetails(stoppedContribution);
      } else {
        final message = error.response!.data['message'];
        if (message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(milliseconds: 3000),
              backgroundColor: COLOR_RED,
            ),
          );
        }
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: APP_BODY_BG,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text('Contribution'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              buildHeader(context),
              Expanded(
                child: Center(
                  child: buildMainSection(context),
                ),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => handleStopContributionPressed(context),
                style: ElevatedButton.styleFrom(backgroundColor: COLOR_RED),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    const Text('Stop Contributing'),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
