import 'package:iw_app/utils/common.dart';

enum Mode {
  Lite,
  Pro,
}

class Config {
  Mode? mode;
  int? bonusWalletExpiration;

  Config({
    this.mode,
    this.bonusWalletExpiration,
  });

  Config.fromJson(Map<String, dynamic> json)
      : mode = CommonUtils.stringToEnum(json['mode'], Mode.values),
        bonusWalletExpiration = json['bonusWalletExpiration'];

  Map<String, dynamic> toJson() => {
        'mode': mode?.name,
      };
}
