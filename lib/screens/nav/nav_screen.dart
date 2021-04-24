import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/enums/enums.dart';
import 'package:flutter_instagram/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:flutter_instagram/screens/nav/widgets/bottom_nav_bar.dart';
import 'package:flutter_instagram/screens/nav/widgets/tab_navigator.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = "/nav";

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, animation, secondaryAnimation) =>
          BlocProvider<BottomNavBarCubit>(
        create: (context) => BottomNavBarCubit(),
        child: NavScreen(),
      ),
    );
  }

  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.feed: GlobalKey<NavigatorState>(),
    BottomNavItem.search: GlobalKey<NavigatorState>(),
    BottomNavItem.create: GlobalKey<NavigatorState>(),
    BottomNavItem.notifications: GlobalKey<NavigatorState>(),
    BottomNavItem.profile: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, IconData> items = const {
    BottomNavItem.feed: Icons.home,
    BottomNavItem.search: Icons.search,
    BottomNavItem.create: Icons.add,
    BottomNavItem.notifications: Icons.favorite_border,
    BottomNavItem.profile: Icons.account_circle,
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) => Scaffold(
          body: Stack(
            children: _buildItems(context, state),
          ),
          bottomNavigationBar: BottomNavBar(
            items: items,
            selectedItem: state.selectedItem,
            onTap: (index) {
              final selectedItem = BottomNavItem.values[index];
              _selecBottomNavItem(
                  context, selectedItem, selectedItem == state.selectedItem);
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context, BottomNavBarState state) {
    return items
        .map(
          (key, value) => MapEntry(
            key,
            _buildOffStageNavigator(
              key,
              key == state.selectedItem,
            ),
          ),
        )
        .values
        .toList();
  }

  Widget _buildOffStageNavigator(BottomNavItem currentItem, bool isSelected) {
    return Offstage(
      offstage: !isSelected,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentItem],
        item: currentItem,
      ),
    );
  }

  void _selecBottomNavItem(
      BuildContext context, BottomNavItem selectedItem, bool isSameItem) {
    if (isSameItem) {
      navigatorKeys[selectedItem]
          .currentState
          .popUntil((route) => route.isFirst);
    }
    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
  }
}
