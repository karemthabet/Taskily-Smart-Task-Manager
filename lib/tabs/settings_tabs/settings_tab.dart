import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/UI/Widgets/scaffold_custom.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/UI/utils/app_colors.dart';
import 'package:todo_app/provider/language_provider.dart';
import 'package:todo_app/provider/tasks_provider.dart';
import 'package:todo_app/provider/theme_provider.dart';
import 'package:todo_app/remot/firebase_services.dart';
import 'package:todo_app/views/sign%20in_screen/sign_in.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return _buildDropdown(
                context: context,
                value: languageProvider.selectedLanguage,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'ar', child: Text('العربية')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    languageProvider.setSelectedLanguage(value);
                  }
                },
              );
            },
          ),
          const SizedBox(height: 70),

          // Theme Mode Dropdown
          Text(
            AppLocalizations.of(context)!.mode,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return _buildDropdown(
                context: context,
                value: themeProvider.appTheme.toString(),
                items: const [
                  DropdownMenuItem(value: "ThemeMode.light", child: Text('Light Mode')),
                  DropdownMenuItem(value: "ThemeMode.dark", child: Text('Dark Mode')),
                ],
                onChanged: (value) {
                  if (value == "ThemeMode.light") {
                    themeProvider.setAppTheme(ThemeMode.light);
                  } else {
                    themeProvider.setAppTheme(ThemeMode.dark);
                  }
                },
              );
            },
          ),
          const SizedBox(height: 50),

          // Logout Button
          ListTile(
            onTap: () {
              FirebaseServices.logout();
              Provider.of<TasksProvider>(context, listen: false).taskModels.clear();
              Navigator.of(context).popAndPushNamed(SignIn.routeName);
            },
            title: const Text(
              "Logout",
              style: TextStyle(color: AppColors.primaryColor, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.logout_outlined, size: 30, color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }

  // Helper method for creating dropdown widgets
  Widget _buildDropdown({
    required BuildContext context,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
      padding: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Theme.of(context).colorScheme.onPrimary,
          value: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
