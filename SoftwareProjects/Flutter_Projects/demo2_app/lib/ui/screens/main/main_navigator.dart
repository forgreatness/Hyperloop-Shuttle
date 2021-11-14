import 'dart:convert';

import 'package:flutter/material.dart';

class MainNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String rootPage;
  final bool active;
  final Stream<MainPageEnum> tabSelectionStream;
  final MainAppObserver observer;

  MainNavigator({Key key, @required this.navigatorKey, @required this.rootPage, @required this.tabSelectionStream, this.active = true, this.observer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.active == false) {
      return Container();
    }

    return Navigator(key: navigatorKey, initialRoute: rootPage, onGenerateRoute: _onGenerateRoute, observers: [observer]);
  }

  Route _onGenerateRoute(RouteSettings settings) {
    WidgetBuilder builder;
    bool isFullScreenDialog = false;
    String routeName = settings.name;

    ///Todo Remove later
    Map<String, dynamic> routeParams = {};
    if (routeName.contains('?params=')) {
      try {
        var splits = settings.name.split("?params=");
        routeName = splits[0];
        var encodedParams = splits[1];
        final JsonDecoder decoder = JsonDecoder();
        routeParams = decoder.convert(encodedParams) ?? [];

        if (routeParams?.isNotEmpty == true) {
          routeParams.forEach((key, val) {
            if (val is String) {
              routeParams[key] = Uri.decodeComponent(val);
            }
          });
        }
      } catch (e) {}
    }

    ///

    MenuActionEnum activeMenu = null;

    switch (routeName) {
      case MainRouteNames.HOME:
        builder = (BuildContext _) => HomeScreen(tabSelectionStream: tabSelectionStream);
        activeMenu = MenuActionEnum.HOME;
        break;

      case MainRouteNames.NETWORKS:
        builder = (_) => MainNetworkScreen(tabSelectionStream: tabSelectionStream);
        break;

      case MainRouteNames.EVENTS:
        builder = (_) => MainEventsScreen(tabSelectionStream: tabSelectionStream);
        break;

      case MainRouteNames.DISCUSSIONS:
        builder = (_) => MainDiscussionsScreen(tabSelectionStream: tabSelectionStream);
        break;
      case RouteNames.DISCUSSION_DETAIL:
        final params = NavigatorUtil.getRouteParams<DiscussionDetailParams>(settings);
        params.showFullScreen = true;

        builder = (_) => DiscussionDetailScreen(params: params);
        break;

      case RouteNames.COMMUNITY:
        final params = NavigatorUtil.getRouteParams<CommunityParams>(settings);
        if (params?.communityId?.isNotEmpty == true) {
          builder = (BuildContext context) => CommunityScreen(params: params);
        }
        break;

      case RouteNames.MY_COMMUNITIES:
        builder = (_) => MyCommunitiesScreen();
        activeMenu = MenuActionEnum.MY_COMMUNITIES;
        break;

      case RouteNames.MY_EVENTS:
        builder = (_) => MyEventsScreen();
        activeMenu = MenuActionEnum.MY_EVENTS;
        break;

      case RouteNames.EVENT_DETAIL:
        if (settings?.arguments is EventDetailParams) {
          EventDetailParams params = settings.arguments;

          final eventId = params.eventId;
          final key = createEventGlobalObjectKeyById(eventId + eventId.hashCode.toString());
          builder = (_) => EventDetailScreen(key: key, params: params);
        }

        break;

      case RouteNames.EVENT_EDIT:
        EventEditParams params = settings.arguments;
        builder = (_) => EventEditScreen(params);

        break;

      case RouteNames.EVENT_EDIT_HIGHLIGHT_PEOPLE:
        EventEditParams params = settings.arguments;
        builder = (_) => EventEditHighlightPeople(params);

        break;

      case RouteNames.EVENT_EDIT_VOLUNTEERS:
        EventEditParams params = settings.arguments;
        builder = (_) => EventEditVolunteers(params);

        break;

      case RouteNames.EVENT_EDIT_SPONSORS:
        EventEditParams params = settings.arguments;
        builder = (_) => EventEditSponsors(params);

        break;

      case RouteNames.EVENT_EDIT_LINKS:
        EventEditParams params = settings.arguments;
        builder = (_) => EventEditLinks(params);

        break;

      case RouteNames.EVENT_EDIT_MEDIAS:
        EventEditParams params = settings.arguments;
        builder = (_) => EventEditMedia(settings.arguments);
        break;

      case RouteNames.MY_SAVED:
        builder = (_) => MySavedScreen();
        activeMenu = MenuActionEnum.SAVED;
        break;

      case RouteNames.MESSAGING:
        builder = (BuildContext context) => ConversationModalScreen();
        break;

      case RouteNames.PROFILE:
        builder = (_) => AppUserProfileScreen();
        break;

      case RouteNames.SETUP_PROFILE:
        builder = (BuildContext context) => SetUpProfileScreen(
              params: NavigatorUtil.getRouteParams<UserProfileEditingParams>(settings),
            );
        break;

      case RouteNames.SETTING:
        builder = (_) => UserSettingScreen();
        break;

      case RouteNames.NOTIFICATION:
        builder = (_) => NotificationListScreen();
        activeMenu = MenuActionEnum.NOTIFICATION;
        break;

      case RouteNames.ADD_EDUCATION:
        builder = (_) => EducationForm();
        break;

      case RouteNames.EVENT_ATTENDEE_LIST:
        builder = (_) => EventAttendeeListScreen(params: NavigatorUtil.getRouteParams<EventParams>(settings));
        break;

      case RouteNames.CONVERSATION_MESSAGE_LIST:
        builder = (_) => ConversationMessageListScreen(NavigatorUtil.getRouteParams<ConversationDetailParams>(settings));
        break;

      case RouteNames.USER_PROFILE:
        builder = (_) => UserProfileDialog(NavigatorUtil.getRouteParams<UserProfileParams>(settings));
        break;

      case RouteNames.EVENT_PROFILE:
        if (settings?.arguments is EventDetailParams) {
          EventDetailParams params = settings.arguments;
          final eventId = params.eventId;
          final key = createEventGlobalObjectKeyById(eventId + eventId.hashCode.toString());

          builder = (_) => EventDetailScreen(key: key, params: params);
        }

        break;

      case RouteNames.PLACE_PROFILE:
        builder = (BuildContext context) => PlaceProfileScreen(NavigatorUtil.getRouteParams<PlaceParams>(settings));
        break;

      case RouteNames.RECOMMENDED_USER_LIST:
        builder = (BuildContext context) => RecommendedUserListScreen(
              params: NavigatorUtil.getRouteParams<UserListParams>(settings),
            );
        break;

      case RouteNames.RECOMMENDED_EVENT_LIST:
        builder = (BuildContext context) => RecommendedEventListScreen(
              params: NavigatorUtil.getRouteParams<EventListParams>(settings),
            );
        break;

      case RouteNames.ACCOUNT_INFO_SETTING:
        builder = (BuildContext context) => AccountInfoScreen();
        break;

      case RouteNames.NOTIFICATION_SETTING:
        builder = (BuildContext context) => NotificationSettingScreen();
        break;

      case RouteNames.LOCATION_SETTING:
        builder = (BuildContext context) => LocationSettingScreen();
        break;

      case RouteNames.PRIVACY_SETTING:
        builder = (BuildContext context) => PrivacySettingScreen();
        break;

      case RouteNames.LANGUAGE_SETTING:
        builder = (BuildContext context) => LanguagesScreen();
        break;

      case RouteNames.INVITATIONS:
        builder = (BuildContext context) => InvitationsScreen();
        break;

      case RouteNames.CONNECTIONS_SEARCH:
        final params = NavigatorUtil.getRouteParams<UserParams>(settings);
        if (params?.userId != null) {
          builder = (BuildContext context) => ConnectionsSearchScreen(params: params);
        }
        break;

      case RouteNames.CONTACTS:
        builder = (BuildContext context) => ContactsScreen();
        break;

      case RouteNames.INVITING_CONTACTS:
        builder = (BuildContext context) => InvitingContactsScreen();
        break;

      case RouteNames.WEB_VIEW_SCREEN:
        final params = NavigatorUtil.getRouteParams<WebViewParams>(settings);

        if (params?.url?.isNotEmpty == true) {
          params.showFullScreen = true;
          builder = (BuildContext context) => WebViewScreen(params: params);
        }
        break;

      case RouteNames.SELECT_INTERESTS_CHECK_IN_SCREEN:
        final params = NavigatorUtil.getRouteParams<SelectInterestsCheckInParams>(settings);

        if (params?.eventId?.isNotEmpty == true) {
          params.showFullScreen = true;
          builder = (BuildContext context) => SelectInterestsCheckInScreen(params: params);
        }
        break;

      case RouteNames.PEOPLE_CHECK_IN_SCREEN:
        final params = NavigatorUtil.getRouteParams<PeopleCheckInParams>(settings);
        if (params?.eventId?.isNotEmpty == true) {
          params.showFullScreen = true;
          builder = (BuildContext context) => PeopleCheckInScreen(params: params);
        }
        break;

      case RouteNames.ATTENDEE_LIST_SCREEN:
        final params = NavigatorUtil.getRouteParams<AttendeesListParams>(settings);
        if (params?.eventId?.isNotEmpty == true) {
          params.showFullScreen = true;
          builder = (BuildContext context) => AttendeesListScreen(params: params);
        }
        break;

      case RouteNames.MEDIA_EVENT_PROFILE_SCREEN:
        final params = NavigatorUtil.getRouteParams<MediaEventProfileParams>(settings);
        if (params?.eventId?.isNotEmpty == true) {
          params.showFullScreen = true;
          builder = (BuildContext context) => MediaEventProfileScreen(params: params);
        }
        break;

      case RouteNames.DISCUSSIONS_EVENT_PROFILE_SCREEN:
        final params = NavigatorUtil.getRouteParams<DiscussionsEventProfileParams>(settings);
        if (params?.eventId?.isNotEmpty == true) {
          params.showFullScreen = true;
          builder = (BuildContext context) => DiscussionsEventProfileScreen(params: params);
        }
        break;

      case RouteNames.BEHIND_THE_SCENE_EVENT:
        final params = NavigatorUtil.getRouteParams<BehindTheEventParams>(settings);
        if (params?.eventId?.isNotEmpty == true) {
          params.showFullScreen = true;
          builder = (BuildContext context) => BehindTheSceneEventScreen(params: params);
        }
        break;

      case RouteNames.LINKS_EVENT_PROFILE:
        final _params = NavigatorUtil.getRouteParams<LinksEventProfileParams>(settings);
        if (_params?.eventId?.isNotEmpty == true) {
          _params.showFullScreen = true;
          builder = (BuildContext context) => LinksEventProfileScreen(params: _params);
        }
        break;

      case RouteNames.POST_COMPOSE:
        PostComposeParams params = settings.arguments;
        builder = (_) => PostComposerScreen(params);

        break;

      case RouteNames.LOCATION_MAP:
        PlaceParams params = settings.arguments;
        builder = (_) => LocationMapScreen(
              params: params,
            );

        break;

      default:
        print("Missing route ${settings.name} in MainNavigator");
        builder = (BuildContext _) => HomeScreen();
    }

    mainLayoutStateKey?.currentState?.setActiveMenu(activeMenu);

    return MaterialPageRoute(builder: builder, settings: settings, fullscreenDialog: isFullScreenDialog);
  }

  static Set<String> get mainRouteTabs {
    return Set.from([
      MainRouteNames.HOME,
      MainRouteNames.NETWORKS,
      MainRouteNames.EVENTS,
      MainRouteNames.DISCUSSIONS,
    ]);
  }

  static Set<String> get mainRouteList {
    return Set.from([
      RouteNames.COMMUNITY,
      RouteNames.MESSAGING,
      RouteNames.PROFILE,
      RouteNames.SETTING,
      RouteNames.NOTIFICATION,
      RouteNames.ADD_EDUCATION,
      RouteNames.CONNECTION_LIST,
      RouteNames.EVENT_ATTENDEE_LIST,
      RouteNames.CONVERSATION_MESSAGE_LIST,
      RouteNames.USER_SUGGESTION_LIST,
      RouteNames.EVENT_SUGGESTION_LIST,
      RouteNames.USER_PROFILE,
      RouteNames.EVENT_PROFILE,
      RouteNames.PLACE_PROFILE,
      RouteNames.RECOMMENDED_USER_LIST,
      RouteNames.RECOMMENDED_EVENT_LIST,
      RouteNames.ACCOUNT_INFO_SETTING,
      RouteNames.NOTIFICATION_SETTING,
      RouteNames.LOCATION_SETTING,
      RouteNames.PRIVACY_SETTING,
      RouteNames.LANGUAGE_SETTING,
    ]);
  }
}

class MainAppObserver extends AppObserver {
  MainAppObserver({this.onFullscreen}) : super(analytics: FirebaseAnalyticsClient.analytics);

  final ValueChanged<bool> onFullscreen;

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    _checkFullscreen(previousRoute);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    _checkFullscreen(route);
  }

  void _checkFullscreen(Route<dynamic> route) {
    if (route is PageRoute && onFullscreen != null) {
      bool isFullScreen = route.fullscreenDialog ?? false;
      if (route.settings?.arguments is BaseRouteParams) {
        BaseRouteParams params = route.settings.arguments;
        isFullScreen = params?.showFullScreen == true;
      }

      onFullscreen(isFullScreen);
    }
  }
}
