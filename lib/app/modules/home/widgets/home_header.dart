import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/auth/auth_provider.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ben vindo,",
          style: context.titleStyle.copyWith(fontSize: 15),
        ),
        Selector<AuthProvider, String>(
          selector: ((context, authProvider) =>
              context.read<AuthProvider>().user?.displayName ?? "Usuário"),
          builder: (__, value, _) {
            return Text(
              value,
              style: context.textTheme.headline5
                  ?.copyWith(fontWeight: FontWeight.bold),
            );
          },
        )
      ],
    );
  }
}
