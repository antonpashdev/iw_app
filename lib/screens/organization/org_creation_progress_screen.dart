import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/account_model.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/components/app_progress_bar.dart';
import 'package:iw_app/widgets/state/config.dart';
import 'package:url_launcher/url_launcher.dart';

class OrgCreationProgressScreen extends StatefulWidget {
  final Organization organization;
  final OrganizationMember member;

  const OrgCreationProgressScreen({
    Key? key,
    required this.organization,
    required this.member,
  }) : super(key: key);

  @override
  State<OrgCreationProgressScreen> createState() =>
      _OrgCreationProgressScreenState();
}

class _OrgCreationProgressScreenState extends State<OrgCreationProgressScreen> {
  late Organization organization;
  late Future<Account> futureAccount;
  double progress = 0.9;
  double animationProgress = 0.0;
  bool isCreated = false;
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    organization = widget.organization;
    futureAccount = fetchAccount();
    WidgetsBinding.instance.addPostFrameCallback((_) => createOrg(context));
  }

  Future<Account> fetchAccount() =>
      authApi.getMe().then((response) => Account.fromJson(response.data));

  navigateToHome() {
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  startPolling() async {
    try {
      final response = await orgsApi.getOrgById(organization.id!);
      final org = Organization.fromJson(response.data);
      if (org.mintStatus == 'success') {
        setState(() {
          organization = org;
          isCreated = true;
          progress = 1.0;
        });
      } else if (org.mintStatus == 'error') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(org.mintError!),
              duration: const Duration(milliseconds: 3000),
              backgroundColor: COLOR_RED,
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        await Future.delayed(const Duration(seconds: 5));
        startPolling();
      }
    } on DioError catch (err) {
      print(err);
      final message = err.response!.data['message'];
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(milliseconds: 3000),
            backgroundColor: COLOR_RED,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (err) {
      print(err);
    }
  }

  createOrg(BuildContext context) async {
    Config config = ConfigState.of(context).config;
    try {
      final response = await orgsApi.createOrg(
        organization,
        widget.member,
        config.mode == Mode.Lite,
      );
      setState(() {
        organization = Organization.fromJson(response.data);
      });
      startPolling();
    } on DioError catch (err) {
      print(err);
      if (err.response!.statusCode == HttpStatus.conflict) {
        navigateToHome();
      } else {
        final message = err.response!.data['message'];
        if (message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(milliseconds: 3000),
              backgroundColor: COLOR_RED,
            ),
          );
        }
        Navigator.of(context).pop();
      }
    } catch (err) {
      print(err);
      Navigator.of(context).pop();
    }
  }

  buildProgress() {
    return Center(
      child: SizedBox(
        width: 220,
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AppProgressBar(
                  size: 220,
                  progress: progress,
                  onStatusUpdate: (status) {
                    if (status == AnimationStatus.completed && isCreated) {
                      setState(() {
                        isDone = true;
                      });
                    }
                  },
                  onUpdate: (value) {
                    setState(() {
                      animationProgress = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Text(
                animationProgress <= 0.5
                    ? 'Project is being created on blockchain.'
                    : '100% equity of a project is being linked to your account.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildDone(BuildContext context, Account account) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(30),
            children: [
              const Icon(
                Icons.check_circle_outline_outlined,
                color: COLOR_GREEN,
                size: 110,
              ),
              const SizedBox(height: 30),
              Text(
                'Project was successfully created on blockchain!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 40),
              Text(
                'Check ${organization.name} token on blockchain',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: COLOR_GRAY,
                    ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  final url = Uri.parse(
                    'https://explorer.solana.com/address/${organization.mint}',
                  );
                  if (!(await launchUrl(url))) {
                    throw Exception('Could not launch $url');
                  }
                },
                child: Text(
                  'https://explorer.solana.com/address/${organization.mint}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: COLOR_BLUE,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              Text(
                'Check that your wallet owns 100% of ${organization.name} token',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: COLOR_GRAY,
                    ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  final url = Uri.parse(
                    'https://explorer.solana.com/address/${account.wallet}/tokens',
                  );
                  if (!(await launchUrl(url))) {
                    throw Exception('Could not launch $url');
                  }
                },
                child: Text(
                  'https://explorer.solana.com/address/${account.wallet}/tokens',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: COLOR_BLUE,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: SizedBox(
            width: 220,
            child: ElevatedButton(
              onPressed: () {
                navigateToHome();
              },
              child: const Text('Done'),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: futureAccount,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return !isDone ? buildProgress() : buildDone(context, snapshot.data!);
        },
      ),
    );
  }
}
