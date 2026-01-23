import 'package:flutter/cupertino.dart';

import 'callback_navigation_observer.dart';
import 'detail_route.dart';
import 'master_route.dart';

class MasterDetailChangeObserver extends CallbackNavigationObserver {
  MasterDetailChangeObserver({
    required ValueChanged<TransitionRoute<dynamic>> onDetailsPop,
    required ValueChanged<TransitionRoute<dynamic>> onDetailsPushed,
  }) : super(
         onPush: (route, previousRoute) {
           final previousIsMaster = MasterRoute.isPageRoute(previousRoute);
           final currentIsDetail = DetailRoute.isPageRoute(route);

           if (!previousIsMaster || !currentIsDetail) return;

           onDetailsPushed(route as TransitionRoute);
         },
         onPop: (route, previousRoute) {
           final currentIsDetail = DetailRoute.isPageRoute(route);
           final previousIsMaster = MasterRoute.isPageRoute(previousRoute);

           if (!previousIsMaster || !currentIsDetail) return;

           onDetailsPop(route as TransitionRoute);
         },
       );
}
