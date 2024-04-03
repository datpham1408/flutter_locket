
import 'package:flutter/material.dart';
import 'package:flutter_locket/locket_app/get_all_image.dart';
import 'package:flutter_locket/locket_app/locket_home_screen.dart';
import 'package:flutter_locket/locket_app/locket_screen.dart';
import 'package:flutter_locket/locket_app/message_screen.dart';
import 'package:flutter_locket/locket_app/phone_book_screen.dart';
import 'package:flutter_locket/router/route_constant.dart';
import 'package:go_router/go_router.dart';

final GoRouter routerMyApp = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LocketHomeScreen();
      },
    ),

    GoRoute(
      path: routerPathPhoneBook,
      name: routerNamePhoneBook,
      builder: (BuildContext context, GoRouterState state) {
        return const PhoneBookScreen();
      },
    ),
    GoRoute(
      path: routerPathMessage,
      name: routerNameMessage,
      builder: (BuildContext context, GoRouterState state) {
        return const MessageScreen();
      },
    ),
    GoRoute(
        path: routerPathGetImage,
        name: routerNameGetImage,
        builder: (BuildContext context, GoRouterState state){
          return const GetAllImagesScreen();
        }
    ),
    GoRoute(
      path: routerPathLocket,
      name: routerNameLocket,
      builder: (BuildContext context, GoRouterState state) {
        final image = (state.extra as Map<String, String>?)?['image'];
        return LocketScreen(
          image: image ?? '',
        );
      },
    ),
  ],
);
