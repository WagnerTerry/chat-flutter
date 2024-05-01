import 'package:chat/constants.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/firebase_options.dart';
import 'package:chat/pages/auth_page.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  Future<void> init(BuildContext context) async {
    WidgetsFlutterBinding
        .ensureInitialized(); // serve para garantir que os widgets estejam inicializados antes de executar o restante do código

    // Executar o app com as configuações do firebase ( storage )
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Configuração com o Authenticator
    //
    // await Firebase.initializeApp(
    //     options: const FirebaseOptions(
    //   apiKey: Constants.apiKey, // Chave de API da Web
    //   appId: Constants.appId, // ID do aplicativo
    //   messagingSenderId:
    //       Constants.messagingSenderId, // ID do remetente (aba Cloud Messaging)
    //   projectId: Constants.projectId, // Código do projeto
    // ));

    // Configurando o App Check
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      androidProvider: AndroidProvider.debug,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else {
          return StreamBuilder<ChatUser?>(
            stream: AuthService().userChanges,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingPage();
              } else {
                return snapshot.hasData ? const ChatPage() : const AuthPage();
              }
            },
          );
        }
      },
    );
  }
}
