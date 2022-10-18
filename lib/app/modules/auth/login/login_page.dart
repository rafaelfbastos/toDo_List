import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/notifier/default_listerner_notifier.dart';
import 'package:todo_list/app/core/ui/messages.dart';
import 'package:todo_list/app/core/widgets/todo_list_field.dart';
import 'package:todo_list/app/core/widgets/todo_list_logo.dart';
import 'package:todo_list/app/modules/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void initState() {
    final defaultListerner = DefaultListernerNotifier(
        changeNotifier: context.read<LoginController>());

    defaultListerner.listener(
        context: context,
        everCallBack: (notifier, listernerInstance) {
          if (notifier is LoginController) {
            if (notifier.hashInfo) {
              Messages.of(context).showInfo(notifier.infoMessage!);
            }
          }
        },
        successCallBack: ((notifier, listernerInstance) {
          listernerInstance.dispose();
        }));
    super.initState();
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

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
                  const SizedBox(
                    height: 80,
                  ),
                  const TodoListLogo(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 30),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TodoListField(
                              label: "E-mail",
                              focusNode: _emailFocus,
                              controller: _emailEC,
                              validator: Validatorless.multiple([
                                Validatorless.required("E-mail obrigatório"),
                                Validatorless.email("E-mail inválido")
                              ]),
                            ),
                            const SizedBox(height: 20),
                            TodoListField(
                              label: "Senha",
                              controller: _passwordEC,
                              validator: Validatorless.multiple([
                                Validatorless.required("Senha obrigatória")
                              ]),
                              obscureText: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                    onPressed: (() {
                                      if (_emailEC.text.isEmpty) {
                                        Messages.of(context)
                                            .showError("Informe o e-mail");
                                        _emailFocus.requestFocus();
                                      } else {
                                        context
                                            .read<LoginController>()
                                            .forgotPassword(_emailEC.text);
                                      }
                                    }),
                                    child: const Text("Esqueceu a senha?")),
                                ElevatedButton(
                                  onPressed: (() {
                                    final formValid =
                                        _formKey.currentState?.validate() ??
                                            false;

                                    if (formValid) {
                                      final email = _emailEC.text;
                                      final password = _passwordEC.text;
                                      context
                                          .read<LoginController>()
                                          .login(email, password);
                                    }
                                  }),
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text("Login"),
                                  ),
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
                          onPressed: () {
                            context.read<LoginController>().googleLogin();
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Não tem conta?"),
                            TextButton(
                                onPressed: (() {
                                  Navigator.of(context).pushNamed("/register");
                                }),
                                child: const Text("Cadastre-se"))
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
