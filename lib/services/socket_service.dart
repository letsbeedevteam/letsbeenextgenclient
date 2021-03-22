import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {

  IO.Socket socket;

  void connectSocket(String token) {

    this.socket = IO.io(Config.BASE_URL + Config.CUSTOMER_NAMESPACE, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {'x-auth-token': token}
    });

    this.socket?.disconnect()?.connect();
  }

  void reconnectSocket(String token) {
    this.socket?.io?.options['extraHeaders'] = {'x-auth-token': token};
    this.socket?.disconnect()?.connect();
  }

  void disconnectSocket() {
    this.socket?.disconnect();
    this.socket?.on("disconnect", (_) => print('Disconnected: $_'));
    this.socket?.dispose();
    this.socket = null;
  }
}