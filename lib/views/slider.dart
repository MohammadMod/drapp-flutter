import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tandrustito/core/shared/imports.dart';
import 'package:tandrustito/features/specialiests/precentation/controller/specialiests_controller.dart';
import 'package:tandrustito/localization/translate_keys.dart';
import 'package:tandrustito/model/slider_model.dart';
import 'package:tandrustito/views/doctor_info.dart';
import 'package:tandrustito/views/home.dart';
import 'package:tandrustito/views/net_image.dart';

class DoctorsPageView extends StatefulWidget {
  const DoctorsPageView({
    Key? key,
    required this.lists,
  }) : super(key: key);
  final List<SliderModel> lists;
  @override
  State<DoctorsPageView> createState() => _DoctorsPageViewState();
}

class _DoctorsPageViewState extends State<DoctorsPageView> {
  final PageController _pageController = PageController();

  int current = 0;

  Timer? timer;
  @override
  void initState() {
    start();
    super.initState();
  }

  @override
  void dispose() {
    log("disposedisposedispose");
    try {
      timer?.cancel();
    } catch (e) {
      log(e.toString());
    }
    super.dispose();
  }

  start() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_pageController.hasClients) {
        return;
      }
      final condition =
          (_pageController.page?.toInt() ?? 0) < widget.lists.length - 1;
      if (condition) {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      } else {
        _pageController.animateToPage(0,
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      }
    });
  }

  Debouncer debouncer = Debouncer(milliseconds: 20000);
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AspectRatio(
          aspectRatio: 2.5,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Listener(
                onPointerMove: (moveEvent) {
                  timer?.cancel();
                  debouncer.timer?.cancel();
                  debouncer.run(() {
                    start();
                  });
                },
                child: PageView.builder(
                    onPageChanged: (value) {
                      current = value;
                      setState(() {});
                    },
                    controller: _pageController,
                    itemCount: widget.lists.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: SpecialistTile(
                          hasSlider: false,
                          index: index,
                          model: widget.lists[index],
                        ),
                      );
                    }),
              ),
              Positioned(
                bottom: 8,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.lists.length, ((entry) {
                      return GestureDetector(
                          onTap: () => _pageController.animateToPage(entry,
                              curve: Curves.ease,
                              duration: const Duration(milliseconds: 100)),
                          child: SizedBox(
                              height: 12.0 + 10,
                              child: Center(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.ease,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 3),
                                  width: current == entry ? 10.0 : 8,
                                  height: current == entry ? 110.0 : 8,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: current == entry
                                          ? Colors.white
                                          : Colors.black26),
                                ),
                              )));
                    })).toList()),
              )
            ],
          )),
    );
  }
}

class SpecialistTile extends StatelessWidget {
  final SliderModel model;
  final bool hasSlider;
  const SpecialistTile({
    Key? key,
    required this.model,
    required this.hasSlider,
    required this.index,
  }) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      decoration: BoxDecoration(
          color: primaryColor, borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.only(right: 15, top: 15, bottom: 15, left: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              width: 100.w,
              height: 200.w,
              child: ImageChecker(
                  radius: 20,
                  linkImage: model.generalModel.image,
                  width: 100.w,
                  height: 200.w,
                  fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  getNames(model.generalModel.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                      height: 1.1, color: Colors.white, fontSize: 20.sp),
                ),
                const SizedBox(height: 6),
                Text(
                  getNames(CategoriesNotifer
                      .instance.map[model.generalModel.specialiestId]?.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                      height: 1.1, color: Colors.white, fontSize: 15.sp),
                ),
                const SizedBox(height: 6),
                Text(
                  getNames(model.generalModel.address),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                      height: 1.1, color: Colors.white, fontSize: 15.sp),
                ),
                const SizedBox(height: 6),
                Text(
                  model.generalModel.phone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                      height: 1.1, color: Colors.white, fontSize: 15.sp),
                ),
              ],
            ),
          )
        ],
      ),
    );
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DoctorsInfo(
                      elementType: model.elementType,
                      model: model.generalModel,
                      index: "${index}0")));
        },
        child: Padding(
            padding:
                const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: !hasSlider
                ? child
                : Slidable(
                    key: ValueKey(index),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        const SizedBox(width: 10),
                        SlidableAction(
                          flex: 1,
                          onPressed: (_) {},
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          icon: Icons.delete,
                          label: Trans.delete.trans(),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    child: child)));
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
