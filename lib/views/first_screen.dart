import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:tandrustito/core/login_screen.dart';
import 'package:tandrustito/core/shared/imports.dart';
import 'package:tandrustito/core/shared/theme_lang_notifier.dart';
import 'package:tandrustito/features/account/controller.dart';
import 'package:tandrustito/features/doctors/presentation/controllers/doctors_controller.dart';
import 'package:tandrustito/features/specialiests/precentation/controller/specialiests_controller.dart';
import 'package:tandrustito/features/specialiests/precentation/view/specilatest_screen.dart';
import 'package:tandrustito/gen/assets.gen.dart';
import 'package:tandrustito/localization/translate_keys.dart';
import 'package:tandrustito/views/admin/login_screen.dart';
import 'package:tandrustito/views/favs_view.dart';
import 'package:tandrustito/views/forms_widget/top_slider.dart';
import 'package:tandrustito/views/genera_button.dart';
import 'package:tandrustito/views/home.dart';
import 'package:tandrustito/views/select_lang.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      CategoriesNotifer.instance.getData();
      DoctorsNotifer.instance.getData();
      LabsNotifer.instance.getData();
      PharmaciesNotifer.instance.getData();
    });
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    Responsive.init(context, designSize: const Size(414, 896));
    return SafeArea(
      child: Consumer<ThemeLangNotifier>(builder: (context, myType, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
                alwaysIncludeSemantics: true, opacity: animation, child: child);
          },
          child: Scaffold(
            key: ValueKey<String>(myType.lang),
            appBar: AppBar(
                leading: (!isLogin)
                    ? null
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () async {
                              AccountNotifer.instance.setAccountModel(null);
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const FirstScreen()),
                                  (route) => false);
                            },
                            child: const Icon(Icons.logout)),
                      ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                        onTap: () {
                          showSetting();
                        },
                        child: const Icon(Icons.settings)),
                  ),
                  const SizedBox(width: 8)
                ]),
            body: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            count = 5;
                            setState(() {});
                          },
                          child: Container(
                            height: 90,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Trans.allMedicalCemtersYouLockForInIraqIsHere
                                  .trans(context: context)
                                  .toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  height: 1.5,
                                  color: primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Wrap(
                            spacing: 25,
                            runSpacing: 25,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.center,
                            alignment: WrapAlignment.center,
                            children: [
                              FirstWidget(
                                  onDoubleTap: () {
                                    if (count == 5) {
                                      count = 4;
                                    }
                                    setState(() {});
                                  },
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (_) => const HomePage(
                                                  index: 0,
                                                )));
                                  },
                                  title: Trans.doctors.trans(context: context),
                                  image: Assets.images.doctors.path),
                              FirstWidget(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (_) =>
                                                const HomePage(index: 1)));
                                  },
                                  title:
                                      Trans.pharmacies.trans(context: context),
                                  image:
                                      Assets.images.pharmacyRemovebgCopy.path),
                              FirstWidget(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (_) => const FavScreen()));
                                  },
                                  title:
                                      Trans.favorites.trans(context: context),
                                  image: Assets.images.favoriteIcon14.path),
                              FirstWidget(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (_) =>
                                                const HomePage(index: 2)));
                                  },
                                  title: Trans.laboratories
                                      .trans(context: context),
                                  image: Assets.images.laboratoryRemovebg.path),
                              if (canEdit)
                                FirstWidget(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (_) =>
                                                  const SpecilatestScreen()));
                                    },
                                    title: Trans.specialist
                                        .trans(context: context),
                                    image: Assets.images.ttt.path),
                              if (canEdit)
                                FirstWidget(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (_) =>
                                                  const TopSlider()));
                                    },
                                    title:
                                        Trans.reklams.trans(context: context),
                                    image:
                                        Assets.images.advertisingRemovebg.path),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: isLogin
                ? null
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: count != 4
                        ? GeneralButton(
                            onTap: () async {
                              context.to(const LoginScreen());
                              // count = 0;
                              // setState(() {});
                            },
                            text: Trans.login.trans(context: context),
                          )
                        : GeneralButton(
                            onTap: () async {
                              await loginForm();
                              // count = 0;
                              // setState(() {});
                            },
                            text: Trans.login.trans(context: context),
                          ),
                  ),
          ),
        );
      }),
    );
  }
}

class FirstWidget extends StatelessWidget {
  const FirstWidget(
      {Key? key,
      required this.title,
      required this.image,
      this.onDoubleTap,
      required this.onTap})
      : super(key: key);
  final String title;
  final Function() onTap;
  final Function()? onDoubleTap;
  final String image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        width: context.width / 2.5,
        height: context.width / 2.5,
        decoration: BoxDecoration(
            color: openColor, borderRadius: BorderRadius.circular(30)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image, width: 100.w, height: 100.w, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(title,
                style: TextStyle(
                    color: primaryColor,
                    height: 1.5,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
