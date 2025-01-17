import 'package:flutter/material.dart';
import 'package:todo_app/UI/utils/app_colors.dart';

class ScaffoldCustom extends StatelessWidget {
  const ScaffoldCustom({super.key, this.body, this.bottomNavigationBar, this.appBar, this.floatingActionButton, this.floatingActionButtonLocation});
  final Widget? body;
  final Widget? bottomNavigationBar;
final PreferredSizeWidget? appBar;
final Widget? floatingActionButton;
final FloatingActionButtonLocation? floatingActionButtonLocation;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          AppColors.primaryColor,
          Theme.of(context).scaffoldBackgroundColor
        ], stops: const [
          .3,
          .3
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body:body ,
        bottomNavigationBar:bottomNavigationBar ,
        appBar:appBar ,
        floatingActionButton:floatingActionButton ,
        floatingActionButtonLocation:floatingActionButtonLocation ,

      ),
    );
  }
}
