// import 'package:alerta_uaz/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class FirebaseService {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

//   // Inicializa Firebase y registra los handlers de notificaciones
//   static Future<void> initializeApp() async {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );

//     await requestPermission();

//     // Registrar handlers para las notificaciones
//     FirebaseMessaging.onMessage.listen(_handlerMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(_handlerMessage);

//     // Registrar el handler de segundo plano
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Obtener el token de FCM
//     await getToken();
//   }

//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     print('Mensaje recibido en segundo plano: ${message.messageId}');
//     // Aquí puedes manejar el mensaje de segundo plano
//   }

//   // Handler de mensajes en primer plano o cuando la app está abierta desde una notificación
//   static Future<void> _handlerMessage(RemoteMessage message) async {
//     print('Llego un mensaje en primer plano o app abierta');
//     print(
//         'Título: ${message.notification?.title}, Cuerpo: ${message.notification?.body}');
//   }

//   // Solicitar permisos de notificaciones
//   static Future<void> requestPermission() async {
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('Permisos concedidos para recibir notificaciones');
//     } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
//       print('Permisos de notificaciones no concedidos');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('Permisos provisionales otorgados');
//     }
//   }

//   // Obtener y mostrar el token de FCM
//   static Future<void> getToken() async {
//     final String? token = await _messaging.getToken();
//     if (token != null) {
//       print('Token FCM: $token');
//     }
//   }
// }

import 'dart:async';
import 'package:alerta_uaz/domain/model/notification_model.dart';
import 'package:alerta_uaz/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  FirebaseService._internal();

  factory FirebaseService() => _instance;

  late FirebaseMessaging _firebaseMessaging;

  late StreamController<NotificationModel> _messageController;

  Stream<NotificationModel> get messageController => _messageController.stream;

  Future<void> initializeApp() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      _firebaseMessaging = FirebaseMessaging.instance;

      await requestPermission();
    } catch (e) {
      throw Exception('Error al inicializar Firebase: $e');
    }
  }

  Future<bool> requestPermission() async {
    try {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        // throw Exception('Permisos de notificación denegados');
        return false;
      }
      return true;
    } catch (e) {
      throw Exception('Error al solicitar permisos de notificación: $e');
    }
  }

  Future<void> setUpMessages() async {
    _messageController = StreamController<NotificationModel>.broadcast();

    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // RemoteMessage? initialMessage =
    //     await _firebaseMessaging.getInitialMessage();
    // if (initialMessage != null) {
    //   _handleMessage(initialMessage);
    //}
  }

  void _handleMessage(RemoteMessage message) {
    NotificationModel notificationModel = NotificationModel(
        notification: message.notification, data: message.data);
    _messageController.add(notificationModel);
  }

  Future<String?> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }
      return token;
    } catch (e) {
      throw Exception('Error al obtener el token: $e');
    }
  }

  void deleteToken() async {
    _firebaseMessaging.deleteToken();
    _messageController.close();
  }

  void dispose() {
    _messageController.close();
  }
}


// import 'dart:async';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:alerta_uaz/firebase_options.dart';

// class FirebaseMessagingService {
//   // Singleton de la clase
//   static final FirebaseMessagingService _instance =
//       FirebaseMessagingService._internal();
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   FirebaseMessagingService._internal();

//   factory FirebaseMessagingService() {
//     return _instance;
//   }

//   Future<void> initialize() async {
//     try {
//       print("Solicitando permisos de notificaciones...");
//       await _requestPermission();
//       print(
//           "Permisos de notificaciones concedidos, configurando Firebase Messaging...");
//       await _configureFirebase();
//       print("Configuración de Firebase Messaging completada.");
//     } catch (e) {
//       throw Exception('Error al inicializar Firebase Messaging: $e');
//     }
//   }

//   Future<void> _requestPermission() async {
//     try {
//       NotificationSettings settings =
//           await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );

//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         print('Permisos de notificación concedidos.');
//       } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
//         throw Exception('Permisos de notificación denegados.');
//       } else if (settings.authorizationStatus ==
//           AuthorizationStatus.provisional) {
//         print('Permisos provisionales concedidos.');
//       }
//     } catch (e) {
//       throw Exception('Error al solicitar permisos de notificación: $e');
//     }
//   }

//   // Esta función debe ser una función top-level o estática
//   Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     print('Mensaje recibido en segundo plano: ${message.notification?.title}');
//     // Puedes agregar más lógica aquí
//   }

//   Future<void> _configureFirebase() async {
//     try {
//       print("Configurando Firebase Messaging...");

//       // Listener para mensajes en primer plano
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         print(
//             'Mensaje recibido en primer plano: ${message.notification?.title}');
//         // Aquí puedes manejar los datos del mensaje si es necesario
//       });

//       // Registrar el manejador para mensajes en segundo plano
//       FirebaseMessaging.onBackgroundMessage(
//           _firebaseMessagingBackgroundHandler);

//       // Listener para cuando la app se abre desde una notificación
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         print('Notificación abierta: ${message.notification?.title}');
//         // Aquí puedes manejar los datos del mensaje si es necesario
//       });

//       // Revisa si la app fue abierta por una notificación
//       RemoteMessage? initialMessage =
//           await _firebaseMessaging.getInitialMessage();
//       if (initialMessage != null) {
//         print(
//             'Mensaje recibido al abrir la app: ${initialMessage.notification?.title}');
//       }

//       print("Firebase Messaging configurado correctamente.");
//     } catch (e) {
//       print('Error al configurar Firebase Messaging: $e');
//       throw Exception('Error al configurar Firebase Messaging: $e');
//     }
//   }

//   Future<String?> getToken() async {
//     try {
//       final String? token = await _firebaseMessaging.getToken();
//       if (token != null) {
//         print('Token de Firebase obtenido: $token');
//       } else {
//         print('El token no está disponible.');
//       }
//       return token;
//     } catch (e) {
//       throw Exception('Error al obtener el token de Firebase: $e');
//     }
//   }

//   Future<void> deleteToken() async {
//     try {
//       await _firebaseMessaging.deleteToken();
//       print('Token eliminado correctamente.');
//     } catch (e) {
//       throw Exception('Error al eliminar el token de Firebase: $e');
//     }
//   }
// }


// import 'dart:async';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:alerta_uaz/firebase_options.dart';

// class FirebaseMessagingService {
//   // Instancia del singleton
//   static final FirebaseMessagingService _instance =
//       FirebaseMessagingService._internal();

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   // Constructor privado
//   FirebaseMessagingService._internal();

//   // Factory constructor para devolver siempre la misma instancia
//   factory FirebaseMessagingService() {
//     return _instance;
//   }

//   Future<void> initialize() async {
//     try {
//       await _requestPermission();
//       await _configureFirebase();
//     } catch (e) {
//       throw Exception('Error al inicializar firebase: $e');
//     }
//   }

//   Future<void> _requestPermission() async {
//     try {
//       NotificationSettings settings =
//           await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );

//       if (settings.authorizationStatus != AuthorizationStatus.authorized) {
//         throw Exception('Permisos de notificación no concedidos');
//       }
//     } on FirebaseException {
//       throw Exception('Error al solicitar permisos');
//     } catch (_) {
//       throw Exception('Error inesperado al solicitar permisos');
//     }
//   }

//   Future<void> _configureFirebase() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _onMessage.add(message);
//     });

//     FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
//       _onBackgroundMessage.add(message);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _onBackgroundMessage.add(message);
//     });

//     RemoteMessage? initialMessage =
//         await _firebaseMessaging.getInitialMessage();
//     if (initialMessage != null) {
//       _onMessage.add(initialMessage);
//     }
//   }

//   Future<String?> getToken() async {
//     try {
//       final String? token = await _firebaseMessaging.getToken();
//       if (token == null) {
//         throw Exception('Token no disponible');
//       }
//       return token;
//     } catch (e) {
//       throw Exception('Error al obtener el token: $e');
//     }
//   }

//   Future<void> deleteToken() async {
//     try {
//       await _firebaseMessaging.deleteToken();
//     } on FirebaseException {
//       throw Exception('Error al eliminar el token');
//     } catch (_) {
//       throw Exception('Error inesperado al eliminar el token');
//     }
//   }

//   final StreamController<RemoteMessage> _onMessage =
//       StreamController.broadcast();

//   final StreamController<RemoteMessage> _onBackgroundMessage =
//       StreamController.broadcast();

//   Stream<RemoteMessage> get onMessage => _onMessage.stream;

//   Stream<RemoteMessage> get onBackgroundMessage => _onBackgroundMessage.stream;
// }

// class FirebaseMessagingService {
//   // Instancia del singleton
//   static final FirebaseMessagingService _instance =
//       FirebaseMessagingService._internal();

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   FirebaseMessagingService._internal() {
//     _configureFirebase();
//   }

//   // Factory constructor para devolver siempre la misma instancia
//   factory FirebaseMessagingService() {
//     return _instance;
//   }

//   void _configureFirebase() async {
//     // Maneja notificaciones en segundo plano
//     FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

//     // Maneja notificaciones en primer plano
//     FirebaseMessaging.onMessage.listen(_handleMessage);

//     // Maneja notificaciones cuando se abre la app desde la notificación (en segundo plano)
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

//     // Maneja mensajes si la app se abre desde estado cerrado
//     RemoteMessage? initialMessage =
//         await _firebaseMessaging.getInitialMessage();
//     if (initialMessage != null) {
//       _handleMessage(initialMessage);
//     }
//   }

//   Future<void> initialize() async {
//     await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform);
//   }

//   Future<bool> requestPermission() async {
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     return settings.authorizationStatus == AuthorizationStatus.authorized;
//   }

//   Future<String?> getDeviceToken() async {
//     return await _firebaseMessaging.getToken();
//   }

//   Future<void> deleteDeviceToken() async {
//     await _firebaseMessaging.deleteToken();
//   }

//   Stream<RemoteMessage> get notificationStream => FirebaseMessaging.onMessage;

//   Future<void> _handleBackgroundMessage(RemoteMessage message) async {
//     print('Mensaje recibido en segundo plano: ${message.notification?.title}');
//   }

//   Future<void> _handleMessage(RemoteMessage message) async {
//     print('Mensaje recibido: ${message.notification?.title}');
//   }
// }
