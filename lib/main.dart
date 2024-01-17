import 'package:flutter/material.dart';
import 'package:jwt_auth/infrastructure/provider/token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_auth/presentation/component/indicator_component.dart';
import 'package:jwt_auth/presentation/home_page.dart';
import 'package:jwt_auth/presentation/login_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenAsyncValue = ref.watch(tokenProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: tokenAsyncValue.when(
        data: (token) => token == null ? const LoginPage() : const HomePage(),
        loading: () => const IndicatorComponent(),
        error: (e, stack) => Text('Error: $e'),
      ),
    );
  }
}
