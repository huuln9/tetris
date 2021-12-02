// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utils/src/blocs/authentication/authentication_bloc.dart';
import 'package:utils/src/blocs/configuration/configuration_bloc.dart';
import 'package:utils/src/login/view/login_page.dart';
import 'package:utils/src/models/models.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  AuthStatus authStatus = AuthStatus.unauthenticated;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        setState(() {
          authStatus = state.status.status;
        });
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "TienGiangS",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                    onPressed: () =>
                        Navigator.of(context).push(LoginPage.route()),
                    icon: const Icon(Icons.account_circle, size: 50),
                    label: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: authStatus == AuthStatus.authenticated
                          ? const Text(
                              "AUTHENTICATED",
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            )
                          : const Text(
                              "ĐĂNG NHẬP/ĐĂNG KÝ",
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                Align(
                  alignment: Alignment.topLeft,
                  child: BlocBuilder<ConfigurationBloc, ConfigurationState>(
                    builder: (context, state) {
                      List<dynamic> homeMenu = state.config['homeMenu'] != null
                          ? List.from(state.config['homeMenu'])
                          : [];

                      switch (state.status) {
                        case configStatus.failure:
                          return const Center(
                              child: Text('Failed to get menu config!'));
                        case configStatus.success:
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var i = 0; i < homeMenu.length; i++)
                                if (homeMenu[i]['enable'])
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextButton.icon(
                                      onPressed: () =>
                                          Navigator.of(context).pushNamed(
                                        homeMenu[i]['route'],
                                        arguments: [
                                          homeMenu[i]['name'] + "'s List",
                                          homeMenu[i]['tagId'],
                                        ],
                                      ),
                                      icon: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                          "assets/images/school.png",
                                          package: 'home',
                                        ),
                                      ),
                                      label: Text(
                                        "     " + homeMenu[i]['name'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          );
                        default:
                          return const Center(
                              child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
