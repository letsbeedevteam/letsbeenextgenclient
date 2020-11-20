import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {

  IO.Socket socket;

  createSocketConnection() async {

    this.socket = IO.io(Config.BASE_URL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    this.socket.connect();

    this.socket.on("connect", (_) {
      print('Connected');
      this.socket.on('chatMessage', (data) => print('Fetched: ${data.toString()}'));
    });
    
    this.socket.on("connecting", (_) => print('Connecting'));
    this.socket.on("disconnect", (_) => print('Disconnected: $_'));
    this.socket.on("connect_error", (_) => print('Connect error: $_'));
    this.socket.on("connect_timeout", (_) => print('Connect timeout: $_'));
    this.socket.on("error", (_) => print('Error: $_'));
  }

  void disconnectSocket() => this.socket.disconnect();

  void sendData() => this.socket.emit('chatMessage', 'hey');
}