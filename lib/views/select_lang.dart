import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tandrustito/core/shared/halpers.dart';
import 'package:tandrustito/core/shared/theme_lang_notifier.dart';
import 'package:tandrustito/localization/translate_keys.dart';
import 'package:tandrustito/views/home.dart';
import 'package:tandrustito/views/languages_widget.dart';

showSetting() async {
  showModalBottomSheet(
    context: Halper.i.context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
    builder: (BuildContext context) {
      return const NewWidget();
    },
  );
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<ThemeLangNotifier>(builder: (context, myType, child) {
                  return SwitchListTile(
                      isThreeLine: false,
                      activeColor: primaryColor,
                      title: Text(Trans.darkTheme.trans(),
                          style: const TextStyle(fontSize: 17)),
                      value: myType.themeMode,
                      onChanged: (value) {
                        myType.changeTheme(!myType.themeMode);
                      });
                }),
                const SizedBox(height: 20),
                if(ThemeLangNotifier.instance.showInfo)
                const LanguagesFlags(),
                if(ThemeLangNotifier.instance.showInfo)
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
