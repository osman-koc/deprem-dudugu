import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:depremdudugu/constants/app_colors.dart';
import 'package:depremdudugu/extensions/app_lang.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreenPopup extends StatelessWidget {
  const AboutScreenPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var appVersion = snapshot.data!.version;
          return getAlertDialog(context, appVersion);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  AlertDialog getAlertDialog(BuildContext context, String appVersion) {
    return AlertDialog(
      title: Text(context.translate.aboutAppTitle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 25),
          Center(
            child: Text(
              context.translate.appName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 3),
          Center(
            child: Text(
              'v$appVersion',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: Text(
              '${context.translate.developedBy}: ',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              context.translate.appDeveloper,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: Text(
              '${context.translate.contact}: ',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: RichText(
              text: TextSpan(
                text: context.translate.appWebsite,
                style:
                    TextStyle(fontSize: 14, color: AppColors(context).appBlue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    var webUri =
                        Uri.parse("https://${context.translate.appWebsite}");
                    launchUrl(webUri);
                  },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: RichText(
              text: TextSpan(
                text: context.translate.appMail,
                style:
                    TextStyle(fontSize: 14, color: AppColors(context).appBlue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    var webUri =
                        Uri.parse("mailto:${context.translate.appMail}");
                    launchUrl(webUri);
                  },
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.translate.close),
        ),
      ],
    );
  }
}
