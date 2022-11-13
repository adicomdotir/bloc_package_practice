import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_practice/apis/login_api.dart';
import 'package:testingbloc_practice/apis/notes_api.dart';
import 'package:testingbloc_practice/bloc/actions.dart';
import 'package:testingbloc_practice/bloc/app_bloc.dart';
import 'package:testingbloc_practice/bloc/app_state.dart';
import 'package:testingbloc_practice/dialogs/generic_dialog.dart';
import 'package:testingbloc_practice/dialogs/loading_screen.dart';
import 'package:testingbloc_practice/models.dart';
import 'package:testingbloc_practice/strings.dart';
import 'package:testingbloc_practice/views/iterable_list_view.dart';
import 'package:testingbloc_practice/views/login_view.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HomePage'),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }

            final loginError = state.loginError;
            if (loginError != null) {
              showGenericDialog<bool>(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionsBuilder: () => {ok: true},
              );
            }

            if (state.isLoading == false &&
                state.loginError == null &&
                state.loginHandle == LoginHandle.fooBar() &&
                state.fetchedNotes == null) {
              context.read<AppBloc>().add(
                    LoadNotesAction(),
                  );
            }
          },
          builder: (context, state) {
            final notes = state.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
