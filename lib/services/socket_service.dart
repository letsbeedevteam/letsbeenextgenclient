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

  
    this.socket..disconnect()..connect();

    // this.socket.on("connect", (_) => print('Connected'));
    // this.socket.on("connecting", (_) => print('Connecting'));
    // this.socket.on("reconnecting", (_) => print('Reconnecting'));
    // this.socket.on("disconnect", (_) => print('Disconnected: $_'));
    // this.socket.on("connect_error", (_) => print('Connect error: $_'));
    // this.socket.on("connect_timeout", (_) => print('Connect timeout: $_'));
    // this.socket.on("error", (_) => print('Error: $_'));
  }

  void reconnectSocket(String token) {
    if (this.socket != null) {
      this.socket.io.options['extraHeaders'] = {'x-auth-token': token};
      this.socket..disconnect()..connect();
    }
  }

  void disconnectSocket() {
    if(this.socket != null) {
      this.socket.disconnect();
      this.socket.on("disconnect", (_) => print('Disconnected: $_'));
      this.socket.dispose();
      this.socket = null;
    }
  }
}