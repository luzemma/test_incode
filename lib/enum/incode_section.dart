import 'dart:io' show Platform;

enum IncodeSdkSection {
  phone,
  fullIdScan,
  frontIdScan,
  backIdScan,
  processId,
  selfieScan,
  faceMatch,
  userScore,
  approval,
  finished,
}

extension IncodeSdkStatusExtension on IncodeSdkSection {
  String get tag {
    switch (this) {
      case IncodeSdkSection.phone:
        return "PHONE";
      case IncodeSdkSection.fullIdScan:
        return "FULL_ID_SCAN";
      case IncodeSdkSection.frontIdScan:
        return "FRONT_ID_SCAN";
      case IncodeSdkSection.backIdScan:
        return "BACK_ID_SCAN";
      case IncodeSdkSection.processId:
        return "PROCESS_ID";
      case IncodeSdkSection.selfieScan:
        return "SELFIE_SCAN";
      case IncodeSdkSection.faceMatch:
        return "FACE_MATCH";
      case IncodeSdkSection.userScore:
        return "USER_SCORE";
      case IncodeSdkSection.approval:
        return "APPROVAL";
      case IncodeSdkSection.finished:
        return "FINISHED";
    }
  }

  IncodeSdkSection get next {
    switch (this) {
      case IncodeSdkSection.phone:
        if (Platform.isAndroid) {
           return IncodeSdkSection.fullIdScan;
        }
        return IncodeSdkSection.frontIdScan;
      case IncodeSdkSection.fullIdScan:
        return IncodeSdkSection.selfieScan;
      case IncodeSdkSection.frontIdScan:
        return IncodeSdkSection.backIdScan;
      case IncodeSdkSection.backIdScan:
        return IncodeSdkSection.processId;
      case IncodeSdkSection.processId:
        return IncodeSdkSection.selfieScan;
      case IncodeSdkSection.selfieScan:
        return IncodeSdkSection.faceMatch;
      case IncodeSdkSection.faceMatch:
        return IncodeSdkSection.userScore;
      case IncodeSdkSection.userScore:
        return IncodeSdkSection.approval;
      case IncodeSdkSection.approval:
        return IncodeSdkSection.finished;
      default:
        return IncodeSdkSection.finished;
    }
  }
}

class IncodeHelper {
  static IncodeSdkSection? getOnboardingSectionByTag(String? tag) {
    if (tag == IncodeSdkSection.phone.tag) {
      return IncodeSdkSection.phone;
    } else if (tag == IncodeSdkSection.fullIdScan.tag) {
      return IncodeSdkSection.fullIdScan;
    } else if (tag == IncodeSdkSection.frontIdScan.tag) {
      return IncodeSdkSection.frontIdScan;
    } else if (tag == IncodeSdkSection.backIdScan.tag) {
      return IncodeSdkSection.backIdScan;
    } else if (tag == IncodeSdkSection.processId.tag) {
      return IncodeSdkSection.processId;
    } else if (tag == IncodeSdkSection.selfieScan.tag) {
      return IncodeSdkSection.selfieScan;
    } else if (tag == IncodeSdkSection.faceMatch.tag) {
      return IncodeSdkSection.faceMatch;
    } else if (tag == IncodeSdkSection.approval.tag) {
      return IncodeSdkSection.approval;
    } else if (tag == IncodeSdkSection.userScore.tag) {
      return IncodeSdkSection.userScore;
    } else if (tag == IncodeSdkSection.finished.tag) {
      return IncodeSdkSection.finished;
    } else {
      return null;
    }
  }
}