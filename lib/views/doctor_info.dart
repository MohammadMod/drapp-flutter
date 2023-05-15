import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tandrustito/core/alert/confirm_alert.dart';
import 'package:tandrustito/core/shared/imports.dart';
import 'package:tandrustito/core/shared/theme_lang_notifier.dart';
import 'package:tandrustito/features/doctors/presentation/controllers/favs_controller.dart';
import 'package:tandrustito/features/doctors/presentation/view/create_edit_general.dart';
import 'package:tandrustito/features/specialiests/precentation/controller/specialiests_controller.dart';
import 'package:tandrustito/gen/assets.gen.dart';
import 'package:tandrustito/localization/translate_keys.dart';
import 'package:tandrustito/model/general_model.dart';
import 'package:tandrustito/views/home.dart';
import 'package:tandrustito/views/map_luncher.dart';
import 'package:tandrustito/views/net_image.dart';

class DoctorsInfo extends StatefulWidget {
  const DoctorsInfo(
      {super.key,
      required this.model,
      required this.elementType,
      required this.index});
  final String index;
  final ElementType elementType;
  final GeneralModel model;
  @override
  _DoctorsInfoState createState() => _DoctorsInfoState();
}

class _DoctorsInfoState extends State<DoctorsInfo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ThemeLangNotifier>(
          builder: (context, themeLangNotifier, child) {
        return Scaffold(
          floatingActionButton:
              Consumer<FavsNotifier>(builder: (context, myType, child) {
            bool isFaved = myType.isFaved(widget.model.id, widget.elementType);

            return GestureDetector(
              onTap: () {
                if (!isFaved) {
                  myType.add(widget.elementType, widget.model);
                } else {
                  myType.delete(widget.model.id, widget.elementType);
                }
              },
              child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: openColor),
                  child: Icon(
                    isFaved ? Icons.favorite : Icons.favorite_border,
                    size: 30,
                  )),
            );
          }),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: openColor, shape: BoxShape.circle),
                      child: const BackButton(color: primaryColor),
                    ),
                    const Spacer(),
                    if (canEdit)
                      PopupMenuButton<PopUpActions>(
                        tooltip: Trans.moreOptions.trans(context: context),
                        onSelected: (value) async {
                          logger(value);

                          if (value == PopUpActions.delete) {
                            final res = await getConfirm(
                                desc: Trans.areYouSureToDeleteThisData.trans(
                                    args: [widget.elementType.name.trans()]));
                            if (res == true) {
                              getGeneralNotifier(widget.elementType)
                                  ?.delete(widget.model.id, 1);
                            }
                          } else if (value == PopUpActions.edit) {
                            context.to(CreateEditDoctor(
                              model: widget.model,
                              elementType: widget.elementType,
                            ));
                          } else if (value == PopUpActions.addToReklame) {
                            getGeneralNotifier(widget.elementType)?.edit(
                                widget.model.copyWith(isAdd: true),
                                0,
                                widget.elementType);
                          } else if (value == PopUpActions.removeToReklame) {
                            getGeneralNotifier(widget.elementType)?.edit(
                                widget.model.copyWith(isAdd: false),
                                0,
                                widget.elementType);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: PopUpActions.delete,
                              child:
                                  Text(Trans.delete.trans(context: context))),
                          PopupMenuItem(
                              value: PopUpActions.edit,
                              child: Text(Trans.edit.trans(context: context))),
                          if (widget.model.isAdd == false)
                            PopupMenuItem(
                                value: PopUpActions.addToReklame,
                                child: Text(Trans.addToReklams
                                    .trans(context: context))),
                          if (widget.model.isAdd == true)
                            PopupMenuItem(
                                value: PopUpActions.removeToReklame,
                                child: Text(Trans.removeToReklame
                                    .trans(context: context))),
                        ],
                      ),
                  ],
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          // floating: true,
                          // pinned: true,
                          // primary: true,
                          leading: const SizedBox(),
                          expandedHeight:
                              MediaQuery.of(context).size.width - 50,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          shadowColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          foregroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          flexibleSpace: FlexibleSpaceBar(
                              background: Hero(
                            tag: widget.index,
                            child: ImageChecker(
                                linkImage: widget.model.image,
                                width: MediaQuery.of(context).size.width - 50,
                                fit: BoxFit.contain),
                          )),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 26),
                                Text(getNames(widget.model.name),
                                    style: const TextStyle(fontSize: 25)),
                                Text(
                                    getNames(CategoriesNotifer.instance
                                        .map[widget.model.specialiestId]?.name),
                                    style: const TextStyle(
                                        fontSize: 19, color: Colors.grey)),
                                const SizedBox(height: 26),
                                Text(
                                  Trans.about.trans(context: context),
                                  style: const TextStyle(
                                      height: 1.1, fontSize: 22),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  getNames(widget.model.about),
                                  style: const TextStyle(
                                      height: 1.1,
                                      color: Colors.grey,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 24),
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    showOpenWithMapBottomSheet(
                                        context: context,
                                        title: getNames(widget.model.name),
                                        lat: widget.model.latitude,
                                        long: widget.model.longitude);
                                  },
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Container(
                                          width: 45.w,
                                          decoration: BoxDecoration(
                                              color: openColor,
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: const Icon(Icons.map,
                                              color: primaryColor, size: 28),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${Trans.address.trans(context: context)}: ',
                                                style: const TextStyle(
                                                    height: 1, fontSize: 20),
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                widget.model.city?.trans() ??
                                                    "",
                                                maxLines: 4,
                                                softWrap: true,
                                                style: const TextStyle(
                                                    height: 1,
                                                    color: Colors.grey),
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                getNames(widget.model.address),
                                                maxLines: 4,
                                                softWrap: true,
                                                style: const TextStyle(
                                                    height: 1,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Transform.rotate(
                                            angle: 0,
                                            child: const Icon(
                                                Icons.arrow_back_ios_new))
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Container(
                                        width: 45,
                                        decoration: BoxDecoration(
                                            color: openColor,
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        child: const Icon(Icons.date_range,
                                            color: primaryColor, size: 28),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '${Trans.practiceDays.trans(context: context)}:',
                                              style: const TextStyle(
                                                  height: 1, fontSize: 20),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                                getDayClass(
                                                    widget.model.availableDays),
                                                style: const TextStyle(
                                                    height: 1,
                                                    color: Colors.grey)),
                                            const SizedBox(height: 5),
                                            Text(
                                                formatWorkTime(
                                                    widget.model.workingHours),
                                                style: const TextStyle(
                                                    height: 1,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...[
                                  const SizedBox(height: 20),
                                  Text(
                                      '${Trans.contactInformations.trans(context: context)}: ',
                                      style: const TextStyle(fontSize: 20)),
                                  const SizedBox(height: 20),
                                  IconTile(
                                      backColor: const Color(0xffFEF2F0),
                                      phoneNumber: widget.model.phone,
                                      imgAssetPath: Assets.images.call.path),
                                  const SizedBox(height: 10),
                                  IconTile(
                                      backColor: const Color(0xffFEF2F0),
                                      phoneNumber: widget.model.mobile,
                                      imgAssetPath: Assets.images.call.path),
                                  const SizedBox(height: 10),
                                  IconTile(
                                      backColor: const Color(0xffFEF2F0),
                                      phoneNumber: widget.model.email,
                                      imgAssetPath: Assets.images.email.path),
                                ],
                                const SizedBox(height: 10),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          Trans.location
                                              .trans(context: context),
                                          style: const TextStyle(fontSize: 20))
                                    ]),
                                const SizedBox(height: 15),
                                MapWidget(
                                    isEditable: false,
                                    latitude: widget.model.latitude,
                                    longitude: widget.model.longitude,
                                    getLocation: (p0) {},
                                    title: Trans.location.trans())
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class IconTile extends StatelessWidget {
  final String imgAssetPath;
  final String phoneNumber;
  final Color backColor;

  const IconTile(
      {super.key,
      required this.imgAssetPath,
      required this.phoneNumber,
      required this.backColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 35.sp,
          width: 35.sp,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: openColor, borderRadius: BorderRadius.circular(7)),
          child: Image.asset(
            imgAssetPath,
            color: primaryColor,
            width: 18.sp,
            height: 18.sp,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          phoneNumber,
          style: TextStyle(height: 1.1, color: primaryColor, fontSize: 18.sp),
        )
      ],
    );
  }
}

enum PopUpActions { edit, delete, addToReklame, removeToReklame }
