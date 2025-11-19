import 'dart:developer';

enum Flavor { dev, prod }

class EnvConfig {
  static late final Flavor _flavor;

  Future<void> init() async {
    const String appFlavor = String.fromEnvironment('FLAVOR');
    log("APP_FLAVOR: $appFlavor");
    switch (appFlavor) {
      case 'dev':
        _flavor = Flavor.dev;
        break;
      default:
        _flavor = Flavor.prod;
        break;
    }
  }

  static const Map<String, dynamic> dev = {
    'urlGvMarket': 'https://dev.amoeba.site:9000/avenue/gvmarket?lang=',
    'urlAmoebaBill': 'https://bill.amoeba.site?lang=',
  };

  static const Map<String, dynamic> prod = {
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
