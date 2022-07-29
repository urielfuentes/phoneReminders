import '../models/chore.dart';

String getFormattedDate(DateTime date) {
  String result = "";
  var now = DateTime.now();
  var yesterdayAtMidNight = DateTime(now.year, now.month, now.day, 0, 0);
  var midNightDate = DateTime(date.year, date.month, date.day, 0, 0);
  var timeRem = midNightDate.difference(yesterdayAtMidNight);
  result = getIfYears(timeRem);
  if (result.isEmpty) {
    result = getIfMonths(timeRem);
  }
  if (result.isEmpty) {
    result = getIfWeeks(timeRem);
  }
  if (result.isEmpty) {
    result = getDays(date, timeRem);
  }
  result += ".";
  return result;
}

String getIfYears(Duration duration) {
  String result = "";
  if (duration.inDays.abs() / 365 >= 1) {
    int remDays = duration.inDays.abs() % 365;
    result += "${(duration.inDays.abs() / 365).floor()} año";
    if (duration.inDays.abs() / 365 >= 2) {
      result += "s";
    }
    if (remDays / 30 >= 1) {
      result += ", ${(remDays / 30).floor()} mes";
      if (remDays / 30 >= 2) {
        result += "es";
      }
    } else if (remDays / 7 >= 1) {
      result += ", ${(remDays / 7).floor()} semana";
      if (remDays / 7 >= 2) {
        result += "s";
      }
    } else if (remDays > 0) {
      result += ", $remDays dia";
      if (remDays > 1) {
        result += "s";
      }
    }
  }
  return result;
}

String getIfMonths(Duration duration) {
  String result = "";
  if (duration.inDays.abs() / 30 >= 1) {
    int remDays = duration.inDays.abs() % 30;
    result += "${(duration.inDays.abs() / 30).floor()} mes";
    if (duration.inDays.abs() / 30 >= 2) {
      result += "es";
    }
    if (remDays / 7 >= 1) {
      result += ", ${(remDays / 7).floor()} semana";
      if (remDays / 7 >= 2) {
        result += "s";
      }
    } else if (remDays > 0) {
      result += ", $remDays dia";
      if (remDays > 1) {
        result += "s";
      }
    }
  }
  return result;
}

String getIfWeeks(Duration duration) {
  String result = "";
  if (duration.inDays.abs() / 7 >= 1) {
    int remDays = duration.inDays.abs() % 7;
    result += "${(duration.inDays.abs() / 7).floor()} semana";
    if (duration.inDays.abs() / 7 >= 2) {
      result += "s";
    }
    if (remDays > 0) {
      result += ", $remDays dia";
      if (remDays > 1) {
        result += "s";
      }
    }
  }
  return result;
}

String getDays(DateTime date, Duration duration) {
  String result = "";
  if (duration.inDays.abs() > 0) {
    result = "${duration.inDays.abs()} dia";
    if (duration.inDays.abs() > 1) {
      result += "s";
    }
  } else {
    result += "Hoy";
  }
  return result;
}

List<int> getScopeValues(DateTime date) {
  var now = DateTime.now();
  var scopesList = [0, 0, 0, 0];
  var yesterdayAtMidNight = DateTime(now.year, now.month, now.day, 0, 0);
  var midNightDate = DateTime(date.year, date.month, date.day, 0, 0);
  var timeRem = midNightDate.difference(yesterdayAtMidNight);
  var daysProcessed = timeRem.inDays;
  scopesList[3] = (daysProcessed / 365).floor();
  daysProcessed -= (daysProcessed / 365).floor() * 365;
  scopesList[2] = (daysProcessed / 30).floor();
  daysProcessed -= (daysProcessed / 30).floor() * 30;
  scopesList[1] = (daysProcessed / 7).floor();
  daysProcessed -= (daysProcessed / 7).floor() * 7;
  scopesList[0] = daysProcessed;
  return scopesList;
}

String getNotifMessage(Chore chore) {
  var dateMessage = getFormattedDate(chore.expiryDate);
  var notifMessage = StringBuffer("Recordatorio: ")..write(chore.name);

  if (dateMessage != "Hoy.") {
    notifMessage.write(". Venció hace: ");
  } else {
    notifMessage.write(". Vence: ");
  }
  notifMessage.write(dateMessage);

  return notifMessage.toString();
}
