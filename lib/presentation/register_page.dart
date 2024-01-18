import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jwt_auth/core/logger.dart';
import 'package:jwt_auth/core/svg_path.dart';
import 'package:jwt_auth/infrastructure/jwt_client.dart';
import 'package:jwt_auth/presentation/home_page.dart';

/// 新規登録画面
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  // GlobalKey<FormState>();は、Formの状態を管理するためのキー
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  // ページが閉じれるときに、コントローラーを破棄する
  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ViewとJWT認証のロジックを切り分けてコードをできるだけ短くした。
  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      // JWT認証のロジックを持っているJwtRepositoryImplをプロバイダーから取得する
      final loginService = ref.read(jwtRepositoryImplProvider);
      // JWT認証のロジックを持っているJwtRepositoryImplのjwtRegisterメソッドを呼び出す
      final result = await loginService.jwtRegister(
          nameController.text, passwordController.text);
      // 新規登録時に成功時は、HomePageに遷移する
      if (result == 'success') {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
        logger.d('新規登録🍅');
      } else {
        if (mounted) {
          // 新規登録🍅失敗時は、エラーダイアログを表示する。error messageは、Go言語のサーバー側で設定している
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          // 青のグラデーション
          colors: [
            // グラデーションの色を設定.
            Colors.blue, // 上の色.
            Colors.blue, // 真ん中の色.
            Colors.black, // 下の色
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text('新規登録')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            // Formは、入力フォームをグループ化するためのWidget。validatorで入力チェックを行う
            child: Form(
              key: _formKey, // key
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    SvgPicture.asset(
                      width: 240,
                      height: 240,
                      svgPath,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ユーザー名が入力されていません';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'パスワードが入力されていません';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: register,
                      child: const Text('新規登録'),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
