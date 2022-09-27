import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onboarding_flutter_wrapper/onboarding_flutter_wrapper.dart';
import 'package:test_incode/bloc/incode_onboarding/incode_onboarding_bloc.dart';
import 'package:test_incode/entities/dto_incode_data.dart';
import 'package:test_incode/enum/incode_section.dart';
import 'package:test_incode/enum/incode_status.dart';
import 'package:test_incode/enum/incode_theme.dart';

class OnboardingIncodeScreen extends StatefulWidget {
  const OnboardingIncodeScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingIncodeScreen> createState() => _OnboardingIncodeScreenState();
}

class _OnboardingIncodeScreenState extends State<OnboardingIncodeScreen> {
  late IncodeOnboardingBloc incodeOnboardingBloc;
  String? userScore;
  DtoIncodeData? incodeData;

  @override
  void initState() {
    super.initState();
    incodeOnboardingBloc = BlocProvider.of<IncodeOnboardingBloc>(context);

    final String apiUrl = dotenv.env["INCODE_API_URL"] ?? "";
    final String apiKey = dotenv.env["INCODE_API_KEY"] ?? "";

    IncodeOnboardingSdk.init(
        apiKey: apiKey,
        apiUrl: apiUrl,
        testMode: false,
        loggingEnabled: false,
        onSuccess: () {
          incodeOnboardingBloc.add(ChangeStatusIncodeOnboarding(
              status: IncodeSdkStatus.initialized));
        },
        onError: (String error) {
          incodeOnboardingBloc.add(OnErrorIncodeOnboardingSection(
              status: IncodeSdkStatus.failure, error: error));
        });
    IncodeOnboardingSdk.setTheme(theme: incodeThemeiOS);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
      ),
      body: SafeArea(
          child: BlocProvider.value(
              value: BlocProvider.of<IncodeOnboardingBloc>(context),
              child: BlocListener<IncodeOnboardingBloc, IncodeOnboardingState>(
                listener: (context, state) {
                  if (state.status == IncodeSdkStatus.initialized) {
                    _startOnboardingSession(context, state.interviewId);
                  }
                  if (state.status == IncodeSdkStatus.started) {
                    _setupIncodeOnboardingSectionByTag(state.completedSection);
                  }
                },
                child: BlocBuilder<IncodeOnboardingBloc, IncodeOnboardingState>(
                  builder: (context, state) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: (state.status == IncodeSdkStatus.failure)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // missed an image of error/warning
                                  Text(
                                    state.error ??
                                        state.status.displayMessageOnboarding,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.status.displayMessageOnboarding,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  (state.status == IncodeSdkStatus.success)
                                      ? const SizedBox.shrink()
                                      : const CircularProgressIndicator(),
                                  (state.status == IncodeSdkStatus.success)
                                      ? ElevatedButton(
                                          onPressed: () {
                                            debugPrint("open a new screen");
                                          },
                                          child: const Text("Continue"),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ))),
    );
  }

  void _startOnboardingSession(BuildContext context, String? interviewId) {
    final String flowId = dotenv.env['INCODE_FLOW_ID'] ?? '';
    OnboardingSessionConfiguration sessionConfig =
        OnboardingSessionConfiguration(
            configurationId: flowId,
            interviewId: interviewId,
            userRegion: "MX");

    IncodeOnboardingSdk.setupOnboardingSession(
        sessionConfig: sessionConfig,
        onSuccess: (OnboardingSessionResult result) {
          incodeOnboardingBloc.add(ChangeStatusIncodeOnboarding(
              status: IncodeSdkStatus.started,
              interviewId: result.interviewId));
        },
        onError: (String error) {
          incodeOnboardingBloc.add(OnErrorIncodeOnboardingSection(
              status: IncodeSdkStatus.failure, error: error));
        });
  }

  void _setupIncodeOnboardingSectionByTag(String? sectionTag) async {
    final IncodeSdkSection? section =
        IncodeHelper.getOnboardingSectionByTag(sectionTag);
    final IncodeSdkSection nextSection =
        section != null ? section.next : IncodeSdkSection.phone;

    if (nextSection == IncodeSdkSection.finished) {
      IncodeOnboardingSdk.finishFlow(onSuccess: () {
        incodeOnboardingBloc.add(FinishIncodeOnboarding(
            status: IncodeSdkStatus.success,
            userScore: userScore ?? "unknown",
            data: incodeData));
      }, onError: (error) {
        incodeOnboardingBloc.add(OnErrorIncodeOnboardingSection(
            status: IncodeSdkStatus.failure, error: error));
      });
      return;
    }

    final flowConfig = _getIncodeFlowConfiguration(nextSection);
    IncodeOnboardingSdk.startNewOnboardingSection(
      flowConfig: flowConfig,
      flowTag: nextSection.tag,
      onError: (String error) {
        incodeOnboardingBloc.add(OnErrorIncodeOnboardingSection(
            status: IncodeSdkStatus.failure, error: error));
      },
      // uncomment if you need to define a module validation and then add those validations
      onIdFrontCompleted: (result) => _validationIdScan(result),
      onIdBackCompleted: (result) => _validationIdScan(result),
      // onSelfieScanCompleted: (result) {
      //   if (result.spoofAttempt == null || result.spoofAttempt == true){
      //     incodeOnboardingBloc.add(OnErrorIncodeOnboardingSection(status: IncodeSdkStatus.failure, error: "Error validating selfie".hardcoded));
      //   }
      // },
      // onFaceMatchCompleted: (result) {
      //   if (result.faceMatched == false) {
      //     incodeOnboardingBloc.add(OnErrorIncodeOnboardingSection(status: IncodeSdkStatus.failure, error: "Error validating ID with selfie, not matched".hardcoded));
      //   }
      // },
      onUserScoreFetched: (result) {
        setState(() {
          userScore = result.overall?.status?.name ?? "unknown";
        });
      },
      onApproveCompleted: (result) {
        if (result.success &&
            result.customerToken != null &&
            result.uuid != null) {
          setState(() {
            incodeData = DtoIncodeData(
                customerId: result.uuid!, token: result.customerToken!);
          });
        }
      },
      onOnboardingSectionCompleted: (String flowTag) {
        incodeOnboardingBloc
            .add(CompleteIncodeOnboardingSection(completedSection: flowTag));
      },
      onUserCancelled: () {
        incodeOnboardingBloc.add(OnErrorIncodeOnboardingSection(
            status: IncodeSdkStatus.failure,
            error: "User cancelled ${nextSection.tag} process"));
      },
    );
  }

  OnboardingFlowConfiguration _getIncodeFlowConfiguration(
      IncodeSdkSection section) {
    final OnboardingFlowConfiguration flowConfig =
        OnboardingFlowConfiguration();
    switch (section) {
      case IncodeSdkSection.phone:
        flowConfig.addPhone();
        break;
      case IncodeSdkSection.fullIdScan:
        flowConfig.addIdScan(idType: IdType.id);
        break;
      case IncodeSdkSection.frontIdScan:
        flowConfig.addIdScan(scanStep: ScanStepType.front, idType: IdType.id);
        break;
      case IncodeSdkSection.backIdScan:
        flowConfig.addIdScan(scanStep: ScanStepType.back, idType: IdType.id);
        break;
      case IncodeSdkSection.processId:
        flowConfig.addProcessId();
        break;
      case IncodeSdkSection.selfieScan:
        flowConfig.addSelfieScan();
        break;
      case IncodeSdkSection.faceMatch:
        flowConfig.addFaceMatch();
        break;
      case IncodeSdkSection.userScore:
        flowConfig.addUserScore();
        break;
      case IncodeSdkSection.approval:
        flowConfig.addApproval();
        break;
      case IncodeSdkSection.finished:
        debugPrint("Just for not including default statement");
    }
    return flowConfig;
  }

  _validationIdScan(IdScanResult result) {
    debugPrint("result $result");
    final validatedId = result.classifiedIdType == "VoterIdentification";
    if (result.scanStatus != IdValidationStatus.ok || !validatedId) {
      final String error = "Error validating ID${(!validatedId)
              ? "\nInvalid ID, should be a Voter Identification (INE, IFE)"
              : ""}";
      incodeOnboardingBloc.add(OnErrorIncodeOnboardingSection(
          status: IncodeSdkStatus.failure, error: error));
    }
  }
}
