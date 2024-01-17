import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_auth/core/logger.dart';
import 'package:jwt_auth/infrastructure/jwt_client.dart';
import 'package:jwt_auth/presentation/home_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // GlobalKey<FormState>();は、Formの状態を管理するためのキー
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> jwtLogin() async {
    if (_formKey.currentState!.validate()) {
      final loginService = ref.read(jwtRepositoryImplProvider);
      final result = await loginService.jwtLogin(nameController.text, passwordController.text);
      if (result == 'success') {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
        logger.d('Login Success🦁');
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(result!),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('閉じる'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          // Formは、入力フォームをグループ化するためのWidget。validatorで入力チェックを行う
          child: Form(
            key: _formKey,// key
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ユーザー名が入力されていません';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'パスワードが入力されていません';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: jwtLogin,
                  child: const Text('ログイン'),
                ),
              ],
            ),
          ),
        ));
  }
}
