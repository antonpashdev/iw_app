import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/contribution_model.dart';
import 'package:iw_app/screens/contribution/contribution_details_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class ContributionMemoScreen extends StatefulWidget {
  final Contribution contribution;

  const ContributionMemoScreen({
    Key? key,
    required this.contribution,
  }) : super(key: key);

  @override
  State<ContributionMemoScreen> createState() => _ContributionMemoScreenState();
}

class _ContributionMemoScreenState extends State<ContributionMemoScreen> {
  String? memo;
  bool isLoading = false;

  handleDonePressed() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await orgsApi.stopContribution(
        widget.contribution.org.id,
        widget.contribution.id!,
        memo,
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

  navigateToDetails(Contribution contribution) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => ContributionDetailsScreen(contribution: contribution),
      ),
      (route) => false,
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

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Contribution',
      child: Column(
        children: [
          Expanded(
            child: KeyboardDismissableListView(
              children: [
                const SizedBox(height: 10),
                buildHeader(context),
                const SizedBox(height: 40),
                Text(
                  'Tell what you have done!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 20),
                AppTextFormFieldBordered(
                  maxLines: 6,
                  minLines: 6,
                  labelText: 'Add some notes for members (optional)',
                  onChanged: (value) {
                    setState(() {
                      memo = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 290,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleDonePressed,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : const Text('Done'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
