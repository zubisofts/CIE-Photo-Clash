import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AppUtils {
  static String displayTimeAgoFromTimestamp(int millisecondsSinceEpoch,
      {bool numericDates = true}) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  static String getTimeFromTimestamp(int millisecondsSinceEpoch) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    String time = DateFormat.jm().format(date);
    return time;
  }

  static String getDateFromTimestamp(int millisecondsSinceEpoch) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    String time = DateFormat.yMMMMEEEEd().format(date);
    return time;
  }

  static Stream<String> getInvestmentCountDown(int startDate, int months) {
    return Stream.periodic(Duration(seconds: 1), (__) {
      var advanceDaysInMillis = (31 * months) * 8.64e+7;
      var advanceDate = startDate + advanceDaysInMillis;
      var d = advanceDate - (DateTime.now().millisecondsSinceEpoch);

      var difference = (d / 8.64e+7).round();
      return '$difference';
    });
  }

  static int getFutureInvestmentCountDown(int startDate, int months) {
    var advanceDaysInMillis = (31 * months) * 8.64e+7;
    var advanceDate = startDate + advanceDaysInMillis;
    var d = advanceDate - (DateTime.now().millisecondsSinceEpoch);
    var difference = (d / 8.64e+7).round();
    return difference;
  }

  static getInvestmentDueDate(int startDate, int months) {
    // var advanceDaysInMillis = ((months) * 2.628e+9);
    // var date = (startDate + advanceDaysInMillis).round();
    var d = DateTime.fromMillisecondsSinceEpoch(startDate)
        .add(Duration(days: months * 31))
        .millisecondsSinceEpoch;
    return getDateFromTimestamp(d);
  }

  static double getInvestmentProgress(int startDate, int months) {
    var difference =
        ((DateTime.now().millisecondsSinceEpoch - startDate) / 8.64e+7).round();

    var totalDays = (months * 31);

    var p = difference / totalDays;
    // print('Total:$difference/$totalDays');
    return p;
  }

  static String greet(DateTime time) {
    var hour = time.hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  static void showFundSuccessDialog(BuildContext context) {
    Navigator.of(context)..pop()..pop();
    AwesomeDialog(
        context: context,
        title: 'Success',
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        btnOk: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            ;
          },
          style: TextButton.styleFrom(
              padding: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              backgroundColor: Theme.of(context).colorScheme.secondary),
          child: Text('Dismiss'),
        )).show();
  }

  static void showFundFailureDialog(BuildContext context) {
    Navigator.of(context).pop();
    AwesomeDialog(
        context: context,
        title: 'Request was not completed',
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        btnOk: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            ;
          },
          style: TextButton.styleFrom(
              padding: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              backgroundColor: Theme.of(context).colorScheme.secondary),
          child: Text('Dismiss'),
        )).show();
  }

  static void showFundLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Theme.of(context).cardColor.withOpacity(0.3),
      builder: (context) => Center(
        child: SpinKitDualRing(
          color: Theme.of(context).colorScheme.secondary,
          lineWidth: 2,
          size: 32,
        ),
      ),
    );
  }
}
