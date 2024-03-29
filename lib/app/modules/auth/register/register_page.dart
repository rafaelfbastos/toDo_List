import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/notifier/default_listerner_notifier.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/core/widgets/todo_list_field.dart';
import 'package:todo_list/app/core/widgets/todo_list_logo.dart';
import 'package:todo_list/app/modules/auth/register/register_controller.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _passwordConfirmEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailEC.dispose();
    _passwordConfirmEC.dispose();
  }

  @override
  void initState() {
    super.initState();
    final defaultListener = DefaultListernerNotifier(
        changeNotifier: context.read<RegisterController>());
    defaultListener.listener(
      context: context,
      successCallBack: (notifier, listernerInstance) {
        listernerInstance.dispose();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (() => Navigator.pop(context)),
          icon: ClipOval(
              child: Container(
            padding: const EdgeInsets.all(8),
            color: context.primaryColor.withAlpha(10),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: context.primaryColor,
            ),
          )),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ToDo List",
              style: TextStyle(fontSize: 10, color: context.primaryColor),
            ),
            Text(
              "Cadastro",
              style: TextStyle(fontSize: 15, color: context.primaryColor),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * .5,
            child: const FittedBox(
              fit: BoxFit.fitHeight,
              child: TodoListLogo(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TodoListField(
                    label: "E-mail",
                    controller: _emailEC,
                    validator: Validatorless.multiple([
                      Validatorless.required("E-mail obrigatório"),
                      Validatorless.email("E-mail inválido")
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TodoListField(
                    label: "Senha",
                    controller: _passwordEC,
                    obscureText: true,
                    validator: Validatorless.multiple([
                      Validatorless.required("Senha obrigatória"),
                      Validatorless.min(6, "Senha muito curta")
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TodoListField(
                      label: "Confirme a senha",
                      controller: _passwordConfirmEC,
                      obscureText: true,
                      validator: Validatorless.multiple([
                        Validatorless.required(
                            "Confirmação de senha obrigatória"),
                        Validatorless.compare(_passwordEC, "Senha não confere"),
                      ])),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: (() {
                      final formValid =
                          _formKey.currentState?.validate() ?? false;
                      if (formValid) {
                        final email = _emailEC.text;
                        final password = _passwordEC.text;

                        context
                            .read<RegisterController>()
                            .registerUser(email, password);
                      }
                    }),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Cadastar"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
