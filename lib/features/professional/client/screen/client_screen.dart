import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/features/professional/client/client_bloc/clients_bloc.dart';
import 'package:ca_appoinment/features/user/widgets/user_profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  @override
  void initState() {
    super.initState();
    context.read<ClientsBloc>().add(ClientsFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          
          title: GestureDetector(
              onTap: () => context.read<ClientsBloc>().add(ClientsFetchEvent()),
              child: const Text(
                'All Clients',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              )),
        ),
        body: BlocBuilder<ClientsBloc, ClientsState>(
          builder: (context, state) {
            if (state is ClientsFailuerState) {
              return Center(child: Text(state.errorMsg));
            }
            if (state is ClientsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ClientsSuccesState) {
              if (state.clients.isEmpty) {
                return const Center(
                    child: Text(
                  "No Clients Found",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppPalates.black,
                      fontSize: 20),
                ));
              }
              return ListView.builder(
                itemCount: state.clients.length,
                itemBuilder: (context, index) {
                  var model = state.clients[index];
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.clientInfoScreen,arguments: model);
                    },
                    leading:
                        UserProfilePic(picRadius: 30, url: model.profilePic),
                    title: Text(model.name!),
                    subtitle: Text(model.email!),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ));
  }
}
