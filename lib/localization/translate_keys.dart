import 'package:flutter/material.dart';
import 'package:tandrustito/core/shared/imports.dart';
import 'package:tandrustito/localization/app_local.dart';

class Trans {
  static String message = "message";
  static String users = "users";
  static String chat = "chat";
  static String darkTheme = "darkTheme";
  static String warning = "warning";
  static String favorites = "favorites";
  static String success = "success";
  static String no = "no";
  static String wrongUserNameOrPassword = "wrongUserNameOrPassword";
  static String filtering = "filtering";
  static String alAnbar = "alAnbar";
  static String alBasrah = "alBasrah";
  static String alMuthanna = "alMuthanna";
  static String alQadisiyah = "alQadisiyah";
  static String anNajaf = "anNajaf";
  static String arbil = "arbil";
  static String asSulaymaniyah = "asSulaymaniyah";
  static String atTamim = "atTamim";
  static String babil = "babil";
  static String baghdad = "baghdad";
  static String dahuk = "dahuk";
  static String dhiQar = "dhiQar";
  static String diyala = "diyala";
  static String karbala = "karbala";
  static String maysan = "maysan";
  static String ninawa = "ninawa";
  static String salahadDin = "salahadDin";
  static String wasit = "wasit";

  static String canNotGetTheCurrentLocationRetryAgain =
      "canNotGetTheCurrentLocationRetryAgain";
  static String selectCities = "selectCities";
  static String cities = "cities";
  static String removeToReklame = "removeToReklame";
  static String addToReklams = "addToReklams";
  static String pleaseEnableGpsToContinue = "pleaseEnableGpsToContinue";
  static String othersInformations = "othersInformations";
  static String ignore = "ignore";
  static String appHasNotAccessToFiles = "appHasNotAccessToFiles";
  static String appHasNotAccessToLocation = "appHasNotAccessToLocation";
  static String pleaseSelectLocationOnMap = "pleaseSelectLocationOnMap";
  static String mobile = "mobile";
  static String add = "add";
  static String description = "description";
  static String operationSuccess = "operationSuccess";
  static String tooShort = "tooShort";
  static String website = "website";
  static String required = "required";
  static String attention = "attention";
  static String areYouSureToDeleteThisData = "areYouSureToDeleteThisData";
  static String failedLoadData = "failedLoadData";
  static String noDataFound = "noDataFound";
  static String retry = "retry";
  static String youHaveNotPermissonToDoThat = "youHaveNotPermissonToDoThat";
  static String ok = "ok";
  static String elementsWastFound = "elementsWastFound";
  static String youAreNotAuthorizedReloginAndRetryAgain =
      "youAreNotAuthorizedReloginAndRetryAgain";
  static String successToGetAllData = "successToGetAllData";
  static String successToGetOne = "successToGetOne";
  static String successToDeleteOne = "successToDeleteOne";
  static String successToUpdateOne = "successToUpdateOne";
  static String successToAddOne = "successToAddOne";
  static String failedToGetAllData = "failedToGetAllData";
  static String failedToGetOne = "failedToGetOne";
  static String failedToDeleteOne = "failedToDeleteOne";
  static String failedToUpdateOne = "failedToUpdateOne";
  static String failedToAddOne = "failedToAddOne";
  static String successToAddAll = "successToAddAll";
  static String failedToAddAll = "failedToAddAll";

  static String unKnownErrorPleaseRetryLater = "type";
  static String type = "type";
  static String cropImage = "cropImage";
  static String reklams = "reklams";
  static String close = "close";
  static String selectImage = "selectImage";
  static String camera = "camera";
  static String gallery = "gallery";
  static String appHasNotAccessToAlbum = "appHasNotAccessToAlbum";
  static String appHasNotAccessToCamera = "appHasNotAccessToCamera";
  static String failed = "failed";

  static String selectLocation = "selectLocation";
  static String doctorName = "doctorName";
  static String placeName = "placeName";
  static String welcomeToLoginScreen = "welcomeToLoginScreen";
  static String username = "username";
  static String arabic = "arabic";
  static String kurdish = "kurdish";
  static String english = "english";
  static String password = "password";
  static String phone = "phone";
  static String save = "save";
  static String from = "from";
  static String to = "to";
  static String search = "search";
  static String moreOptions = "moreOptions";
  //
  static String doctors = "doctors";
  static String doctor = "doctor";
  static String pharmacies = "pharmacies";
  static String pharmacy = "pharmacy";
  static String laboratories = "laboratories";
  static String laboratory = "laboratory";
  static String specialist = "specialist";
  static String login = "login";
  static String about = "about";
  static String address = "address";
  static String practiceDays = "practiceDays";
  static String edit = "edit";
  static String delete = "delete";
  static String email = "email";
  static String contactInformations = "contactInformations";
  static String location = "location";
  static String view = "view";
  static String city = "city";
  static String allMedicalCemtersYouLockForInIraqIsHere =
      "allMedicalCemtersYouLockForInIraqIsHere";
  static String create = "create";
  static String internetConnectionError = "internetConnectionError";
  static String name = "name";

  static String pm = 'pm';
  static String sat = 'sat';
  static String sun = 'sun';
  static String mon = 'mon';
  static String tues = 'tues';
  static String wed = 'wed';
  static String thu = 'thu';
  static String fri = 'fri';
  static String all = 'all';
  static String open24 = 'open24';
  static String am = 'am';
  static String refresh = 'refresh';
  static String openTime = 'openTime';
  static String closeTime = 'closeTime';
  static String operationFalied = 'operationFalied';
  static String open = 'open';
  static String date = 'date';
  static String failedToLoad = 'failedToLoad';
  static String dataLoadedSuccessfully = 'dataLoadedSuccessfully';
  static String retryLater = 'retryLater';
  static String allow = 'allow';
  static String skip = 'skip';
  static String dashboard = 'dashboard';
}

String _translateFun(context, String str, bool? capital,
    {List<dynamic>? args = const []}) {
  final currentContext = context ?? Halper.i.navigatorKey.currentContext;
  if (checkIsNull(AppLocalizations.of(currentContext!)?.translate(str))) {
    //Split key by uppercase letter and rejoin them
    final beforeCapitalLetter = RegExp(r"(?=[A-Z])");
    var parts = str.split(beforeCapitalLetter);
    return parts.join(" ").toLowerCase().capitalize(capital);
  } else {
    args ??= [];
    String s = AppLocalizations.of(currentContext!)!
        .translate(str)
        .capitalize(capital);
    for (int i = 0; i < args.length; i++) {
      s = s.replaceFirst("_args", args[i]);
    }
    return s;
  }
}

extension StringExtension on String {
  String capitalize(bool? capital) {
    if (isEmpty || capital != true) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String trans({BuildContext? context, bool? capital, List<dynamic>? args}) {
    return _translateFun(context, this, capital ?? true, args: args);
  }
}
