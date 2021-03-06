import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
//import 'package:flutter_blue/flutter_blue.dart';

class BluetoothFunctionality{

  static FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  // the actual device
  // if this is null, then there is no device
  static BluetoothDevice _device;

  String _deviceNameString = "aaa";
  static String _sensorReadString = "bbb";

  // constructor
 BluetoothFunctionality(){
   connect();
 }


  static void connect(){
    // future_bluetooth_serial library predefined type of mapped List
    Future<List> _devices = _bluetooth.getBondedDevices();

    _devices.then((element){
      _device = element.first;
      print(_device.name + " is the name");
      _actualConnect();
      return;
    });
  }


  // connects _bluetooth to the bluetooth _device
  static void _actualConnect(){
    print("trying to connect");

    if(_device != null){
      print("_device.connect not null");

      _bluetooth.isConnected.then((isConnected) {
        if(!isConnected){
          _bluetooth.connect(_device);
          print("connected");
        }else{
          _bluetooth.disconnect();
          _bluetooth.connect(_device);
          print("already connected connected");
        }
      });
    }else{
      print("_device.connect null");
    }
  }


  // send messages via _bluetooth
  void sendMessageViaBluetooth(String message){
    _bluetooth.isConnected.then((isConnected){
      if(isConnected){
        _bluetooth.write(message[0]);
        print("sent " + message);
      }
    });
  }


  // read message from _bluetooth
  static String readMessageFromBluetooth(){
    _bluetooth.isConnected.then((isConnected){
      if(isConnected){
        _bluetooth.onRead().listen((msg){
          _sensorReadString = msg;
        });
      }
    });

    //print("aux = " +  _sensorReadString);
    return _sensorReadString;
  }


  // returns bluetooth device name or "none"
  // used to display the name in the interface
  String getBluetoothDeviceName(){
    if(_device == null){
      _deviceNameString = "none";
    }else{
      _bluetooth.isAvailable.then((isConnected) {
        if(isConnected){
          _deviceNameString = _device.name;
        }else{
          _deviceNameString =  "not connected";
        }

        return _deviceNameString;
      });
    }

    //print("s is " + s);
    return _deviceNameString;
  }

}