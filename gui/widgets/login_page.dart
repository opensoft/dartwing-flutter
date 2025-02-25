import 'dart:async';
import 'dart:io';

import '../../core/custom_exceptions.dart';
import '../../core/globals.dart';
import '../../gui/notification.dart';
import '../../gui/widgets/base_scaffold.dart';
import '../../network/paper_trail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:upgrader/upgrader.dart';

import '../../network/dart_wing/data/company.dart';
import '../../network/network_clients.dart';
import '../base_apps_routers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  bool _loadingOverlayEnabled = false;

  //String _redirectUrl = "http://localhost:3000";
  String _redirectUrl = "https://app-dev.ledgerlinc.com";

  Future<bool> _logout() {
    if (kIsWeb) {
      return Future.value(false); // TODO: ADDWEB
    }
    return Globals.keycloakWrapper.logout().then((success) {
      Globals.keycloakWrapper.tokenResponse = null;
      return success;
    });
  }

  Future<bool> _login() {
    if (kIsWeb) {
      // TODO: ADDWEB
    }
    setState(() {
      _loadingOverlayEnabled = true;
    });
    if (!Globals.keycloakWrapper.isInitialized) {
      Globals.keycloakWrapper.initialize();
    }
    return Globals.keycloakWrapper.login().then((success) {
      if (!success) {
        setState(() {
          _loadingOverlayEnabled = false;
        });
      }
      return success;
    });
  }

  void _chooseCompanyAndGoHomePage() {
    /*
    Company foundedCompany = Globals.user.companies.firstWhere((comp) {
      return comp.id == Globals.applicationInfo.defaultLocation;
    }, orElse: () => Company());

    if (foundedCompany.id.isEmpty) {
      Navigator.of(context)
          .pushNamed(LedgerLincAppsRouters.chooseCompanyPage, arguments: true)
          .then((company) {
        if (company != null && company is Company) {
          debugPrint(company.name);
          NetworkClients.init(location: company.id).then((_) {
            return Globals.keycloakWrapper.updateToken();
          }).catchError((e) {
            setState(() {
              _loadingOverlayEnabled = false;
            });
            showWarningNotification(context, e.toString());
          });
        } else {
          _logout();
        }
      });
    } else {
      _goToHomePage(foundedCompany);
    }

     */
  }

  void _goToHomePage(Company company) {
    /*
    Navigator.of(context)
        .pushNamed(BaseAppsRouters.homePage, arguments: company.name)
        .then((value) {
      return _logout();
    }).then((_) {
      setState(() {
        _loadingOverlayEnabled = false;
      });
    }).catchError((e) {
      setState(() {
        _loadingOverlayEnabled = false;
      });
      showWarningNotification(context, e.toString());
    });

     */
  }

  void _autologinIfPossible() {
    if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      return;
    }
    Future<bool> future = Future<bool>.value(false);
    if (kIsWeb) {
    } else {
      future = Future.value(Globals.keycloakWrapper.accessToken == null
          ? false
          : Globals.keycloakWrapper.accessToken!.isNotEmpty);
    }
    future.then((valid) {
      if (valid) {
        _updateTokenAndUserInfo();
      }
    });
  }

  Future<void> _updateTokenAndUserInfo() {
    setState(() {
      _loadingOverlayEnabled = true;
    });
    return Globals.keycloakWrapper.getUserInfo().then((userInfo) {
      Globals.applicationInfo.username =
          userInfo != null && userInfo.containsKey('name')
              ? userInfo['name']
              : '';
      Globals.applicationInfo.userEmail =
          userInfo != null && userInfo.containsKey('email')
              ? userInfo['email']
              : '';

      String userId = Globals.applicationInfo.userEmail;
      if (userId.isEmpty && Globals.applicationInfo.username.isNotEmpty) {
        userId =
            Globals.applicationInfo.username.replaceAll(' ', '.').toLowerCase();
      }
      Globals.applicationInfo.deviceId =
          "${kIsWeb ? "web" : Platform.operatingSystem.toLowerCase()}-$userId";
    }).then((_) {
      return NetworkClients.init(token: Globals.keycloakWrapper.accessToken);
    }).then((_) {
      PaperTrailClient.sendInfoMessageToPaperTrail(
          "Token ${Globals.keycloakWrapper.accessToken.toString()}");
      PaperTrailClient.sendInfoMessageToPaperTrail(
          "New Token expires in ${DateTime.fromMillisecondsSinceEpoch(Globals.keycloakWrapper.tokenResponse!.accessTokenExpirationDateTime!.millisecondsSinceEpoch)}");
      return NetworkClients.dartWingApi.fetchMyUserInfo();
    }).then((user) {
      setState(() {
        _loadingOverlayEnabled = false;
      });
      Globals.user = user;
    }).then((_) {
      setState(() {
        _loadingOverlayEnabled = false;
      });
      if (ModalRoute.of(context)!.isCurrent) {
        _chooseCompanyAndGoHomePage();
      }
    }).catchError((e) {
      //_logout();
      setState(() {
        _loadingOverlayEnabled = false;
      });
      if ((e is! CancelLoginException) && (e is! PlatformException)) {
        showWarningNotification(context, e.toString());
      }
      if (ModalRoute.of(context)!.isCurrent) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    if (!Globals.keycloakWrapper.isInitialized) {
      Globals.keycloakWrapper.initialize();
    }
    NetworkClients.init(token: Globals.keycloakWrapper.accessToken);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //_autologinIfPossible();
    });

    Globals.keycloakWrapper.authenticationStream.listen((success) {
      if (!success ||
          Globals.keycloakWrapper.accessToken == null ||
          Globals.keycloakWrapper.accessToken!.isEmpty) {
        return;
      }
      _updateTokenAndUserInfo();
    });
    Globals.keycloakWrapper.onError = (message, error, stackTrace) {
      PaperTrailClient.sendWarningMessageToPaperTrail(message);
      setState(() {
        _loadingOverlayEnabled = false;
      });
    };
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //_autologinIfPossible();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: BaseScaffold(
        loadingOverlayEnabled: _loadingOverlayEnabled,
        body: Column(
          children: [
            Visibility(
              visible: Globals.qaModeEnabled,
              child: const SizedBox(
                  child: Text(
                'QA',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.red,
                ),
              )),
            ),
            Expanded(child: Container()),
            Center(
              child: Image.asset(
                'lib/dart_wing/images/dartwing_logo.png',
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(160, 50)),
                  onPressed: () {
                    _login();
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    Globals.applicationInfo.version,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
