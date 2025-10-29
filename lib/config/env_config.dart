import 'package:package_info_plus/package_info_plus.dart';

enum Flavor { dev, prod }

class EnvConfig {
  static late final Flavor _flavor;

  Future<void> init() async {
    final packageInfo = await PackageInfo.fromPlatform();
    switch (packageInfo.packageName.split('.').last) {
      case 'dev':
        _flavor = Flavor.dev;
        break;
      default:
        _flavor = Flavor.prod;
        break;
    }
  }

  static const Map<String, dynamic> dev = {
    'baseUrl': 'http://54.179.168.192/api/',
    'urlGvMarket': 'https://dev.amoeba.site:9000/avenue/gvmarket?lang=',
    'urlAmoebaBill': 'https://bill.amoeba.site?lang=',
  };

  static const Map<String, dynamic> prod = {
    'baseUrl': 'http://54.179.168.192/api/',
    'urlGvMarket': 'https://avenue.amoeba.site/gvmarket?lang=',
    'urlAmoebaBill': 'https://bill.amoeba.site?lang=',
  };

  static Map<String, dynamic> get current {
    switch (_flavor.name) {
      case 'dev':
        return dev;
      default:
        return prod;
    }
  }
}
