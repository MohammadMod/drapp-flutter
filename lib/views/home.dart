// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/healthicons.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/medical_icon.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tandrustito/core/alert/enter_name.dart';
import 'package:tandrustito/core/shared/close_keyboard.dart';
import 'package:tandrustito/core/shared/imports.dart';
import 'package:tandrustito/features/chats/data_source/remote_chat.dart';
import 'package:tandrustito/features/chats/view/chat_screen.dart';
import 'package:tandrustito/features/chats/view/clietns_screen.dart';
import 'package:tandrustito/features/doctors/presentation/controllers/doctors_controller.dart';
import 'package:tandrustito/features/doctors/presentation/controllers/doctors_controllercopy.dart';
import 'package:tandrustito/features/doctors/presentation/view/create_edit_general.dart';
import 'package:tandrustito/features/reklams/controller/reklam_notifier.dart';
import 'package:tandrustito/gen/assets.gen.dart';
import 'package:tandrustito/localization/translate_keys.dart';
import 'package:tandrustito/model/general_model.dart';
import 'package:tandrustito/views/city_picker.dart';
import 'package:tandrustito/views/doctor_widget.dart';
import 'package:tandrustito/views/forms_widget/text_filed.dart';
import 'package:tandrustito/views/slider.dart';
import 'package:tandrustito/views/status_widgets/failure_screen.dart';
import 'package:tandrustito/views/status_widgets/loading_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.index});
  final int index;

  @override
  _HomePageState createState() => _HomePageState();
}

const Color openColor = Color.fromARGB(60, 41, 146, 195);
const Color primaryColor = Color(0XFF2B91BF);

class _HomePageState extends State<HomePage> {
  int index = 0;
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      DoctorsNotifer.instance.getData();
      PharmaciesNotifer.instance.getData();
      LabsNotifer.instance.getData();
    });
    index = widget.index;
    super.initState();
  }

  Future<void> onRefresh() async {
    Future.wait([
      DoctorsNotifer.instance.refresh(),
      PharmaciesNotifer.instance.refresh(),
      LabsNotifer.instance.refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: !canEdit
              ? FloatingActionButton(
                  backgroundColor: primaryColor,
                  child: const Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    UserModel? userModel = SharedPrefsHalper.instance.user;
                    if (userModel == null) {
                      String? name = await enterNickname(desc: "");
                      if (name == null) {
                        return;
                      }
                      userModel = UserModel(name: name, uuid: generateUid());
                      RemoveCHatSource.instance.createUser(userModel);
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChatScreen(
                                  title: Trans.chat.trans(),
                                  userModel: userModel!,
                                  collectionId: userModel.uuid,
                                )));
                  })
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                        heroTag: "asgdfgnhjjgrfes",
                        backgroundColor: primaryColor,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CreateEditDoctor(
                                        elementType: ElementType.values[index],
                                      )));
                        }),
                    const SizedBox(height: 20),
                    FloatingActionButton(
                        heroTag: "aesgdrhfgj",
                        backgroundColor: primaryColor,
                        child: const Icon(
                          Icons.chat,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ClientsScreen()));
                        }),
                  ],
                ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(height: 5),
              const SizedBox(height: 1),
              SalomonBottomBar(
                currentIndex: index,
                selectedColorOpacity: .1,
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 2),
                onTap: (v) {
                  index = v;
                  setState(() {});
                },
                items: [
                  SalomonBottomBarItem(
                    unselectedColor: primaryColor,
                    icon: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Iconify(
                        Mdi.doctor,
                        size: 25,
                        color: index != 0 ? primaryColor : primaryColor,
                      ),
                    ),
                    title: Text(Trans.doctors.trans(context: context),
                        style: const TextStyle(height: 1)),
                    selectedColor: primaryColor,
                  ),
                  SalomonBottomBarItem(
                    unselectedColor: primaryColor,
                    icon: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Iconify(
                        Healthicons.pharmacy,
                        size: 25,
                        color: index != 1 ? primaryColor : primaryColor,
                      ),
                    ),
                    title: Text(Trans.pharmacies.trans(context: context),
                        style: const TextStyle(height: 1)),
                    selectedColor: primaryColor,
                  ),
                  SalomonBottomBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Iconify(
                        MedicalIcon.i_laboratory,
                        size: 25,
                        color: index != 2 ? primaryColor : primaryColor,
                      ),
                    ),
                    unselectedColor: primaryColor,
                    title: Text(Trans.laboratories.trans(context: context),
                        style: const TextStyle(height: 1)),
                    selectedColor: primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 1),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: onRefresh,
            backgroundColor: primaryColor,
            color: Colors.white,
            displacement: 50,
            child: CustomScrollView(scrollBehavior: MyBehavior(), slivers: <
                Widget>[
              SliverAppBar(
                leading: const SizedBox(),
                expandedHeight: 150.0,
                pinned: false,
                elevation: 0,
                snap: false,
                floating: true,
                foregroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Assets.images.whatsAppImage20221210At000012.image(
                          width: context.width,
                          fit: BoxFit.cover,
                          matchTextDirection: true),
                      Container(
                          margin: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                              color: primaryColor, shape: BoxShape.circle),
                          child: const BackButton(
                            color: Colors.white,
                          ))
                    ],
                  ),
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(
                      bottom: 20, left: 20, right: 20, top: 10),
                  title: Text(
                    <String>[
                      Trans.doctors.trans(context: context),
                      Trans.pharmacies.trans(context: context),
                      Trans.laboratories.trans(context: context)
                    ][index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SliverAppBar(
                floating: false,
                pinned: true,
                elevation: 0,
                expandedHeight: 10,
                leading: const SizedBox(),
                toolbarHeight: 90,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GeneralTextFiled(
                              viewBorder: false,
                              controller: [
                                DoctorsNotifer.instance,
                                PharmaciesNotifer.instance,
                                LabsNotifer.instance,
                              ][index]
                                  .textEditingController,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              raduis: 45,
                              readOnly: false,
                              onChange: (p0) {
                                logger("p0 $p0");
                                setState(() {});
                                setState(() {});
                                setState(() {});
                              },
                              onTap: () {},
                              hintText: Trans.search.trans(context: context),
                              subfixIcon: Container(
                                  margin: const EdgeInsets.all(3),
                                  child: const Icon(Icons.search)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                              onTap: () async {
                                closeKeyBoard(context);
                                final selected = [
                                  DoctorsNotifer.instance,
                                  PharmaciesNotifer.instance,
                                  LabsNotifer.instance,
                                ][index];
                                final res = await selectCity([
                                  ...selected.selectedCity,
                                ], selected.selectedCategory, index == 0);
                                if (res != null) {
                                  [
                                    DoctorsNotifer.instance,
                                    PharmaciesNotifer.instance,
                                    LabsNotifer.instance,
                                  ][index]
                                      .setSelectedCity(res);
                                }
                              },
                              child: const Icon(Icons.filter_alt_outlined)),
                        ],
                      ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width,
                      //   height: 40,
                      //   child: ListView.builder(
                      //       itemCount:
                      //           CategoriesNotifer.instance.categories.length +
                      //               1,
                      //       shrinkWrap: true,
                      //       scrollDirection: Axis.horizontal,
                      //       itemBuilder: (context, index) {
                      //         return CategoryWidget(
                      //           category: [
                      //             all,
                      //             ...CategoriesNotifer.instance.categories
                      //           ][index],
                      //           isSelected: selectedCategorie ==
                      //               [
                      //                 all,
                      //                 ...CategoriesNotifer.instance.categories
                      //               ][index],
                      //           onTap: (newOne) {
                      //             setState(() {
                      //               selectedCategorie = newOne;
                      //               [
                      //                 DoctorsNotifer.instance,
                      //                 PharmaciesNotifer.instance,
                      //                 LabsNotifer.instance,
                      //               ][index]
                      //                   .setSelectedCat(newOne.id);
                      //             });
                      //           },
                      //         );
                      //       }),
                      // )
                    ],
                  ),
                ),
              ),
              Consumer<ReklamNotifiers>(
                builder: (context, myType, child) {
                  return DoctorsPageView(lists: myType.list);
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              [
                DoctrosView(key: ValueKey(DateTime.now().toIso8601String())),
                PharamaciesView(
                    key: ValueKey(DateTime.now().toIso8601String())),
                LabsView(key: ValueKey(DateTime.now().toIso8601String())),
              ][index]
            ]),
          )),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class DoctrosView extends StatefulWidget {
  const DoctrosView({super.key});

  @override
  State<DoctrosView> createState() => _DoctrosViewState();
}

class _DoctrosViewState extends State<DoctrosView> {
  Future<void> onRefresh() async {
    return await DoctorsNotifer.instance.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorsNotifer>(
      builder: (context, myType, child) {
        if (myType.status.isLoadingOrInitial) {
          return const SliverToBoxAdapter(child: LoadingWidget());
        }
        if (myType.failure != null) {
          return SliverToBoxAdapter(
              child: FailureScreen(
                  failure: myType.failure!, onRefresh: onRefresh));
        }

        List<GeneralModel> list = filters(myType);

        return SliverList(
            delegate: SliverChildBuilderDelegate(childCount: list.length,
                (context, index) {
          return DoctorWidget(
              elementType: ElementType.doctor,
              index: index,
              model: list[index]);
        }));
      },
    );
  }
}

class LabsView extends StatefulWidget {
  const LabsView({super.key});

  @override
  State<LabsView> createState() => _LabsViewState();
}

class _LabsViewState extends State<LabsView> {
  Future<void> onRefresh() async {
    return await LabsNotifer.instance.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LabsNotifer>(
      builder: (context, myType, child) {
        if (myType.status.isLoadingOrInitial) {
          return const SliverToBoxAdapter(child: LoadingWidget());
        }
        if (myType.failure != null) {
          return SliverToBoxAdapter(
              child: FailureScreen(
                  failure: myType.failure!, onRefresh: onRefresh));
        }

        List<GeneralModel> list = filters(myType);

        return SliverList(
            delegate: SliverChildBuilderDelegate(childCount: list.length,
                (context, index) {
          return DoctorWidget(
              elementType: ElementType.laboratory,
              index: index,
              model: list[index]);
        }));
      },
    );
  }
}

class PharamaciesView extends StatefulWidget {
  const PharamaciesView({super.key});

  @override
  State<PharamaciesView> createState() => _PharamaciesViewState();
}

class _PharamaciesViewState extends State<PharamaciesView> {
  Future<void> onRefresh() async {
    return await PharmaciesNotifer.instance.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmaciesNotifer>(
      builder: (context, myType, child) {
        if (myType.status.isLoadingOrInitial) {
          return const SliverToBoxAdapter(child: LoadingWidget());
        }
        if (myType.failure != null) {
          return SliverToBoxAdapter(
              child: FailureScreen(
                  failure: myType.failure!, onRefresh: onRefresh));
        }

        List<GeneralModel> list = filters(myType);

        return SliverList(
            delegate: SliverChildBuilderDelegate(childCount: list.length,
                (context, index) {
          return DoctorWidget(
              elementType: ElementType.pharmacy,
              index: index,
              model: list[index]);
        }));
      },
    );
  }
}

List<GeneralModel> filters(GeneralNotifier generalNotifier) {
  var data = [...generalNotifier.data];
  var upperCasecities =
      generalNotifier.selectedCity.map((e) => e.toLowerCase()).toList();
  var selectedCategory = generalNotifier.selectedCategory;
  data = data
      .where((element) => upperCasecities.contains(element.city?.toLowerCase()))
      .toList();
  data = data
      .where((element) => element.toJson().toLowerCase().contains(
          generalNotifier.textEditingController.text.trim().toLowerCase()))
      .toList();
  if (selectedCategory != 0) {
    data = data
        .where((element) => element.specialiestId == selectedCategory)
        .toList();
  }
  return [...data];
}
