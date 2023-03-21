import 'package:flutter/material.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/contribution_model.dart';
import 'package:iw_app/screens/contribution/contribution_details_screen.dart';
import 'package:iw_app/theme/app_theme.dart';

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
            child: Image.memory(widget.contribution.org.logo),
          ),
        ),
        const SizedBox(width: 15),
        Column(
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
      ],
    );
  }

  buildMainSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              WidgetSpan(child: SizedBox(width: 50)),
              TextSpan(text: 'Your future is created'),
              TextSpan(text: '\nby what you do today'),
              WidgetSpan(child: SizedBox(width: 50)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Image.asset(
            'assets/images/contribution_img.png',
            width: MediaQuery.of(context).size.width * 0.7,
          ),
        ),
      ],
    );
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
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) =>
                  ContributionDetailsScreen(contribution: stoppedContribution),
            ),
            (route) => false);
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        appBar: AppBar(
          title: const Text('Contribution'),
        ),
        body: Padding(
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
