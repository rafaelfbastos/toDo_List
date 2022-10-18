import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/auth/auth_provider.dart';
import 'package:todo_list/app/core/ui/messages.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/services/user/user_service.dart';

class HomeDrawer extends StatelessWidget {
  final nameVN = ValueNotifier<String>("");
  HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: context.primaryColor.withAlpha(20)),
            child: Row(
              children: [
                Selector<AuthProvider, String>(
                  selector: ((context, authProvider) {
                    return authProvider.user?.photoURL ??
                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png';
                  }),
                  builder: ((__, value, _) => CircleAvatar(
                        backgroundImage: NetworkImage(value),
                        radius: 30,
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Selector<AuthProvider, String>(
                      selector: ((context, authProvider) {
                        return authProvider.user?.displayName ?? "Usuário";
                      }),
                      builder: ((__, value, _) => Text(
                            value,
                            style: context.textTheme.subtitle2,
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            title: const Text("Alterar nome"),
            onTap: (() => showDialog(
                context: context,
                builder: ((context) => AlertDialog(
                      title: Text("Alterar Nome"),
                      content: TextField(
                        onChanged: ((value) => nameVN.value = value),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                            onPressed: (() async {
                              if (nameVN.value.isNotEmpty) {
                                final name = nameVN.value;
                                Loader.show(context);
                                await context
                                    .read<UserService>()
                                    .updateDisplayName(name);
                                Loader.hide();
                                Navigator.of(context).pop();
                              }
                            }),
                            child: Text("Alterar"))
                      ],
                    )))),
          ),
          ListTile(
            title: const Text("Sair"),
            onTap: (() => context.read<AuthProvider>().logout()),
          )
        ],
      ),
    );
  }
}
