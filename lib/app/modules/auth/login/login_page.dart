import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/database/sqlite_connection_factory.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: ((context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Image.asset(
                    "assets/logo.png",
                    height: 200,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    child: Form(
                        child: Column(
                      children: [
                        TextField(),
                        const SizedBox(height: 20),
                        TextFormField(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                                onPressed: (() {}),
                                child: const Text("Esqueceu a senha?")),
                            ElevatedButton(
                              onPressed: (() {
                                context.read<SqliteConnectionFactory>().openConnection();
                              }),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Login"),
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            )
                          ],
                        )
                      ],
                    )),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffDFE9ED),
                        border: Border(
                          top: BorderSide(
                            width: 2,
                            color: Colors.grey.withAlpha(50),
                          ),
                        ),
                      ),
                      child: Column(children: [
                        const SizedBox(
                          height: 30,
                        ),
                        SignInButton(
                          Buttons.Google,
                          text: "Continue com o Google",
                          padding: const EdgeInsets.all(5),
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none),
                          onPressed: () {},
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Não tem conta?"),
                            TextButton(
                                onPressed: (() {}), child: Text("Cadastre-se"))
                          ],
                        )
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      })),
    );
  }
}
