import 'acesso.dart';

class AcessoConsole implements Acesso {
  @override
  late bool acesso;

  late bool appAdd,
      appApk,
      appSee,
      deviceAdmin,
      deviceLicense,
      deviceLock,
      devicePin,
      devicePush,
      deviceSee,
      userAdmin,
      userSee;

  AcessoConsole({this.acesso = false,
    this.appAdd= false,
    this.appApk= false,
    this.appSee= false,
    this.deviceAdmin= false,
    this.deviceLicense= false,
    this.deviceLock= false,
    this.devicePin= false,
    this.devicePush= false,
    this.deviceSee= false,
     this.userAdmin= false,
     this.userSee= false
  });

  AcessoConsole.fromMap(Map<String, dynamic> map){
    this.acesso = map['acesso'] ?? false;
    this.appAdd = map['appAdd'] ?? false;
    this.appApk = map['appApk'] ?? false;
    this.appSee = map['appSee'] ?? false;
    this.deviceAdmin = map['deviceAdmin'] ?? false;
    this.deviceLicense = map['deviceLicense'] ?? false;
    this.deviceLock = map['deviceLock'] ?? false;
    this.devicePin = map['devicePin'] ?? false;
    this.devicePush = map['devicePush'] ?? false;
    this.deviceSee = map['deviceSee'] ?? false;
    this.userAdmin = map['userAdmin'] ?? false;
    this.userSee = map['userSee'] ?? false;
  }

  @override
  Map<String, dynamic> toMap() =>
      {
        'acesso': this.acesso,
        'appAdd': this.appAdd,
        'appApk': this.appApk,
        'appSee': this.appSee,
        'deviceAdmin': this.deviceAdmin,
        'deviceLicense': this.deviceLicense,
        'deviceLock': this.deviceLock,
        'devicePin': this.devicePin,
        'devicePush': this.devicePush,
        'deviceSee': this.deviceSee,
        'userAdmin': this.userAdmin,
        'userSee': this.userSee
      };
}
