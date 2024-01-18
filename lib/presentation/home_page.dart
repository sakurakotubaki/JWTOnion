import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_auth/infrastructure/jwt_client.dart';
import 'package:jwt_auth/presentation/login_page.dart';

// ログイン後のページ
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  // ログアウトをするメソッド
  Future<void> logOut() async {
    // accessTokenを削除して、ログイン画面に戻る
    await ref.read(jwtRepositoryImplProvider).logOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logOut(),
          ),
        ],
      ),
      body: const Center(
        child: Text('You are logged in!'),
      ),
    );
  }
}
