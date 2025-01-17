import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/UI/Widgets/scaffold_custom.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/UI/utils/app_colors.dart';
import 'package:todo_app/provider/language_provider.dart';
import 'package:todo_app/provider/theme_provider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  late String selectedValue;
  late String selectedAppThemeMode;
  late ThemeProvider themeProvider;
  late LanguageProvider languageProvider;

  @override
  void initState() {
    super.initState();
     themeProvider = Provider.of<ThemeProvider>(context, listen: false);
     languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    selectedValue = languageProvider.selectedLanguage;
    selectedAppThemeMode = themeProvider.appThemeMode.toString();
  }

  @override
  Widget build(BuildContext context) {
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
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
            padding: const EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Theme.of(context).colorScheme.onPrimary,
                value: selectedValue,
                isExpanded: true,
                items:const  [
                    DropdownMenuItem<String>(
                    value: 'en',
                    child: Text(
                      'English',
                      style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
                    ),
                  ),
                    DropdownMenuItem<String>(
                    value: 'ar',
                    child: Text(
                      'العربية',
                      style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
                    ),
                  ),
                ],
                onChanged: (valueKey) {
              setState(() {
                selectedValue = valueKey!;
              });
              selectedValue == "en"
                  ? languageProvider.changeSelectedLanguage("en")
                  : languageProvider.changeSelectedLanguage("ar");
                  setState(() {
                    
                  });
            },
              ),
            ),
          ),
          const SizedBox(height: 70),

          // Mode Dropdown
          Text(
            AppLocalizations.of(context)!.mode,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
            padding: const EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Theme.of(context).colorScheme.onPrimary,
                value: selectedAppThemeMode,
                isExpanded: true,
                items:const  [
                   DropdownMenuItem<String>(
                    value: "ThemeMode.light",
                    child: Text(
                      'Light Mode',
                      style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
                    ),
                  ),
                   DropdownMenuItem<String>(
                    value: "ThemeMode.dark",
                    child: Text(
                      'Dark Mode',
                      style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
                    ),
                  ),
                ],
               onChanged: (valueKey) {
              setState(() {
                selectedAppThemeMode = valueKey!;
              });

              selectedAppThemeMode == "ThemeMode.light"
                  ? themeProvider.changeAppThemeMode(ThemeMode.light)
                  : themeProvider.changeAppThemeMode(ThemeMode.dark);
            },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
