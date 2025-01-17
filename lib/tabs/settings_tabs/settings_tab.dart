import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/UI/Widgets/drobdown_custom.dart';
import 'package:todo_app/UI/Widgets/scaffold_custom.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/provider/language_provider.dart';
import 'package:todo_app/provider/theme_provider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  String selectedValue = "en";
  String selectedAppThemeMode = "Light";

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of(context)!;
    LanguageProvider languageProvider = Provider.of(context)!;

    Locale currentLocale = Localizations.localeOf(context);

    return ScaffoldCustom(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text(
            AppLocalizations.of(context)!.settings,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Language Dropdown
          Text(
            AppLocalizations.of(context)!.language,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          DrobdownCustom(
            onChanged: (valueKey) {
              setState(() {
                selectedValue = valueKey!;
              });
              selectedValue == "en"
                  ? languageProvider.changeSelectedLanguage("en")
                  : languageProvider.changeSelectedLanguage("ar");
            },
            initialValue: selectedValue,
            value1: "English",
            value2: "Arabic",
            value1Key: "en",
            value2Key: "ar",
          ),
          const SizedBox(
            height: 70,
          ),
          // Mode Dropdown
          Text(
            AppLocalizations.of(context)!.mode,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          DrobdownCustom(
            onChanged: (valueKey) {
              setState(() {
                selectedAppThemeMode = valueKey!;
              });

              selectedAppThemeMode == "Light"
                  ? themeProvider.changeAppThemeMode(ThemeMode.light)
                  : themeProvider.changeAppThemeMode(ThemeMode.dark);
            },
            initialValue: selectedAppThemeMode,
            value1: "Light",
            value2: "Dark",
            value1Key: "Light",
            value2Key: "Dark",
          ),
        ],
      ),
    );
  }
}
