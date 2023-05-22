import 'package:iw_app/utils/common.dart';

enum Mode {
  Lite,
  Pro,
}

class Config {
  Mode? mode;

  Config({
    this.mode,
  });

  Config.fromJson(Map<String, dynamic> json)
      : mode = CommonUtils.stringToEnum(json['mode'], Mode.values);

  Map<String, dynamic> toJson() => {
        'mode': mode?.name,
      };
}
