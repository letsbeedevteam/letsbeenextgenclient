import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {

  final IO.Socket _socket = Get.find();

  createSocketConnection() async {

    this._socket.connect();

    this._socket.on("connect", (_) {
      print('Connected');
      this._socket.on('chatMessage', (data) => print('Fetched: ${data.toString()}'));
    });
    
    this._socket.on("connecting", (_) => print('Connecting'));
    this._socket.on("reconnecting", (_) => print('Reconnecting'));
    this._socket.on("disconnect", (_) => print('Disconnected: $_'));
    this._socket.on("connect_error", (_) => print('Connect error: $_'));
    this._socket.on("connect_timeout", (_) => print('Connect timeout: $_'));
    this._socket.on("error", (_) => print('Error: $_'));
  }

  void disconnectSocket() => this._socket.disconnect();

  void sendData() => this._socket.emit('chatMessage', 'hey');
}