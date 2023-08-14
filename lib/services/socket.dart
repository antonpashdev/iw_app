import 'package:iw_app/models/account_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:fluttertoast/fluttertoast.dart';

// const String SOCKET_URL = 'http://localhost:3000';
const String SOCKET_URL =
    'https://ew-notification-service-c5765138475c.herokuapp.com';

class SocketService {
  static late IO.Socket socket;

  SocketService getInstance() {
    return SocketService();
  }

  connectSocket({String? token, Account? account}) async {
    if (token == null) {
      _showErrorToast('Socket Connection Error');
      return;
    }

    socket = IO.io(
      SOCKET_URL,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setQuery({'token': token, 'wallet': account?.wallet ?? ''})
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      _showSuccessToast('Socket Connected');
      print('Connection established');
    });
    socket.onDisconnect(
      (_) {
        _showErrorToast('Socket Disconnected');
        print('Disconnected');
      },
    );
    socket.onConnectError((err) {
      _showErrorToast('Socket Connection Error $err');
      print('Connection Error');
    });
    socket.onError((err) {
      _showErrorToast('Socket Error $err');
      print('Error');
    });
    socket.onReconnectFailed((data) {
      _showErrorToast('Socket Reconnect Failed $data');
      print('Reconnect Failed');
    });

    // --- listen to events ---
    listenToBalanceChange((data) {
      _showInfoToast('Balance Updated: ${data['balance']}');
      print('Balance Updated');
    });
  }

  disconnectSocket() {
    socket.disconnect();
  }

  listenToBalanceChange(Function callback) {
    socket.on('balance-updated', (data) {
      callback(data);
    });
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      webBgColor: 'green',
      webPosition: 'center',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: COLOR_GREEN,
      textColor: COLOR_WHITE,
      fontSize: 16.0,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      webBgColor: 'red',
      webPosition: 'center',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: COLOR_RED,
      textColor: COLOR_WHITE,
      fontSize: 16.0,
    );
  }

  void _showInfoToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      webBgColor: 'blue',
      webPosition: 'center',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: COLOR_BLUE,
      textColor: COLOR_WHITE,
      fontSize: 16.0,
    );
  }
}
