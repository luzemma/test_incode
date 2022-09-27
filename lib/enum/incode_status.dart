enum IncodeSdkStatus {
  initializing,
  initialized,
  started,
  success,
  failure,
}

extension IncodeSdkStatusExtension on IncodeSdkStatus {
  String get displayMessageOnboarding {
    switch (this) {
      case IncodeSdkStatus.initializing: 
        return 'Initializing Incode service';
      case IncodeSdkStatus.initialized:
      case IncodeSdkStatus.started:
        return 'Incode service started';
      case IncodeSdkStatus.failure:
        return 'There was an error, try again later';
      case IncodeSdkStatus.success:
        return 'Successful registration';
    }
  }
}
