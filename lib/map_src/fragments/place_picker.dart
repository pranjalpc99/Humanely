import 'dart:async';
import 'package:Humanely/main.dart';

//import 'package:Humanely/notch_shape.dart';
import 'package:Humanely/providers/place_provider.dart';
import 'file:///C:/Users/G3-3579/AndroidStudioProjects/humanely/lib/map_src/utils/uuid.dart';
import 'package:Humanely/utils/hexcolor.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

//import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart' as am;
//import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import '../../google_maps_place_picker.dart';
import 'autocomplete_search.dart';
import '../controllers/autocomplete_search_controller.dart';
import 'google_map_place_picker.dart';

enum PinState { Preparing, Idle, Dragging }
enum SearchingState { Idle, Searching }

class PlacePicker extends StatefulWidget {
  PlacePicker({
    Key key,
    @required this.apiKey,
    this.onPlacePicked,
    this.getAddress,
    this.initialPosition,
    this.useCurrentLocation,
    this.desiredLocationAccuracy = LocationAccuracy.high,
    this.onMapCreated,
    this.hintText,
    this.searchingText,
    // this.searchBarHeight,
    // this.contentPadding,
    this.onAutoCompleteFailed,
    this.onGeocodingSearchFailed,
    this.proxyBaseUrl,
    this.httpClient,
    this.selectedPlaceWidgetBuilder,
    this.pinBuilder,
    this.autoCompleteDebounceInMilliseconds = 1000,
    this.cameraMoveDebounceInMilliseconds = 750,
    this.initialMapType = MapType.normal,
    this.enableMapTypeButton = true,
    this.enableMyLocationButton = true,
    this.myLocationButtonCooldown = 10,
    this.usePinPointingSearch = true,
    this.usePlaceDetailSearch = false,
    this.autocompleteOffset,
    this.autocompleteRadius,
    this.autocompleteLanguage,
    this.autocompleteComponents,
    this.autocompleteTypes,
    this.strictbounds,
    this.region,
    this.selectInitialPosition = false,
    this.resizeToAvoidBottomInset = true,
    this.initialSearchString,
    this.searchForInitialValue = false,
    this.forceAndroidLocationManager = false,
    this.forceSearchOnZoomChanged = false,
    this.automaticallyImplyAppBarLeading = true,
  }) : super(key: key);

  final String apiKey;

  final LatLng initialPosition;
  final bool useCurrentLocation;
  final LocationAccuracy desiredLocationAccuracy;

  final MapCreatedCallback onMapCreated;

  final String hintText;
  final String searchingText;

  // final double searchBarHeight;
  // final EdgeInsetsGeometry contentPadding;

  final ValueChanged<String> onAutoCompleteFailed;
  final ValueChanged<String> onGeocodingSearchFailed;
  final int autoCompleteDebounceInMilliseconds;
  final int cameraMoveDebounceInMilliseconds;

  final MapType initialMapType;
  final bool enableMapTypeButton;
  final bool enableMyLocationButton;
  final int myLocationButtonCooldown;

  final bool usePinPointingSearch;
  final bool usePlaceDetailSearch;

  final num autocompleteOffset;
  final num autocompleteRadius;
  final String autocompleteLanguage;
  final List<String> autocompleteTypes;
  final List<Component> autocompleteComponents;
  final bool strictbounds;
  final String region;

  /// If true the [body] and the scaffold's floating widgets should size
  /// themselves to avoid the onscreen keyboard whose height is defined by the
  /// ambient [MediaQuery]'s [MediaQueryData.viewInsets] `bottom` property.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// scaffold, the body can be resized to avoid overlapping the keyboard, which
  /// prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true.
  final bool resizeToAvoidBottomInset;

  final bool selectInitialPosition;

  /// By using default setting of Place Picker, it will result result when user hits the select here button.
  ///
  /// If you managed to use your own [selectedPlaceWidgetBuilder], then this WILL NOT be invoked, and you need use data which is
  /// being sent with [selectedPlaceWidgetBuilder].
  final ValueChanged<PickResult> onPlacePicked;
  final ValueChanged<String> getAddress;

  /// optional - builds selected place's UI
  ///
  /// It is provided by default if you leave it as a null.
  /// INPORTANT: If this is non-null, [onPlacePicked] will not be invoked, as there will be no default 'Select here' button.
  final SelectedPlaceWidgetBuilder selectedPlaceWidgetBuilder;

  /// optional - builds customized pin widget which indicates current pointing position.
  ///
  /// It is provided by default if you leave it as a null.
  final PinBuilder pinBuilder;

  /// optional - sets 'proxy' value in google_maps_webservice
  ///
  /// In case of using a proxy the baseUrl can be set.
  /// The apiKey is not required in case the proxy sets it.
  /// (Not storing the apiKey in the app is good practice)
  final String proxyBaseUrl;

  /// optional - set 'client' value in google_maps_webservice
  ///
  /// In case of using a proxy url that requires authentication
  /// or custom configuration
  final BaseClient httpClient;

  /// Initial value of autocomplete search
  final String initialSearchString;

  /// Whether to search for the initial value or not
  final bool searchForInitialValue;

  /// On Android devices you can set [forceAndroidLocationManager]
  /// to true to force the plugin to use the [LocationManager] to determine the
  /// position instead of the [FusedLocationProviderClient]. On iOS this is ignored.
  final bool forceAndroidLocationManager;

  /// Allow searching place when zoom has changed. By default searching is disabled when zoom has changed in order to prevent unwilling API usage.
  final bool forceSearchOnZoomChanged;

  /// Whether to display appbar backbutton. Defaults to true.
  final bool automaticallyImplyAppBarLeading;

  @override
  _PlacePickerState createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker>
    with SingleTickerProviderStateMixin {
  FirebaseUser _firebaseUser;
  String _status;
  var _bottomNavIndex = 0; //default index of first screen

  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  FloatingActionButtonLocation floatingActionButtonLocation = FloatingActionButtonLocation.centerDocked;
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;

  GlobalKey appBarKey = GlobalKey();
  PlaceProvider provider;

  SearchBarController searchBarController = SearchBarController();

  @override
  void initState() {
    super.initState();
    _getFirebaseUser();

    provider =
        PlaceProvider(widget.apiKey, widget.proxyBaseUrl, widget.httpClient);
    provider.sessionToken = Uuid().generateV4();
    provider.desiredAccuracy = widget.desiredLocationAccuracy;
    provider.setMapType(widget.initialMapType);

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  Future<void> _getFirebaseUser() async {
    this._firebaseUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      _status =
          (_firebaseUser == null) ? 'Not Logged In\n' : 'Already LoggedIn\n';
      if (_firebaseUser == null) {
        print("Not logged in");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyHomePage(title: 'Flutter Demo Home Page')));
      } else {
        print("Already logged in");
      }
    });
  }

  final iconList = <IconData>[
    Icons.home,
    Icons.flash_on,
    Icons.notifications,
    Icons.person,
  ];

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          searchBarController.clearOverlay();
          return Future.value(true);
        },
        child: ChangeNotifierProvider.value(
          value: provider,
          child: Builder(
            builder: (context) {
              return Stack(
                children: <Widget>[
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                    extendBodyBehindAppBar: true,
                    extendBody: true,
                    appBar: AppBar(
                      key: appBarKey,
                      automaticallyImplyLeading: false,
                      iconTheme: Theme.of(context).iconTheme,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      titleSpacing: 0.0,
                      title: _buildSearchBar(),
                    ),
                    body: _buildMapWithLocation(),
                  ),
                ],
              );
            },
          ),
        ));
  }

//  Widget _buildBottomTab() {
//    return BottomAppBar(
//      shape: CircularNotchedAndCorneredRect(
//          leftCornerRadius: 24,
//          rightCornerRadius: 24,
//          notchSmoothness: NotchSmoothnessValue.smoothEdge),
//      color: HexColor('#444444'),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: _buildItems(),
//      ),
//    );
//  }

//
//  Widget _buildBottomTabContainer(){
//    return BottomAppBar(
//      shape: CircularNotchedAndCorneredRect(
//          leftCornerRadius: 24,
//          rightCornerRadius: 24,
//          notchSmoothness: NotchSmoothness.smoothEdge
//      ),
//      color: HexColor('#444444'),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          TabItem(icon: Icons.home,),
//          TabItem(icon: Icons.flash_on,),
//          SizedBox(width: 48,),
//          TabItem(icon: Icons.notifications,),
//          TabItem(icon: Icons.person,)
//        ],
//      ),
//    );
//  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        children: <Widget>[
//        widget.automaticallyImplyAppBarLeading
//            ? IconButton(
//                onPressed: () => Navigator.maybePop(context),
//                icon: Icon(
//                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
//                ),
//                padding: EdgeInsets.zero)
//            : SizedBox(width: 15),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: AutoCompleteSearch(
              appBarKey: appBarKey,
              searchBarController: searchBarController,
              sessionToken: provider.sessionToken,
              hintText: widget.hintText,
              searchingText: widget.searchingText,
              debounceMilliseconds: widget.autoCompleteDebounceInMilliseconds,
              onPicked: (prediction) {
                _pickPrediction(prediction);
              },
              onSearchFailed: (status) {
                if (widget.onAutoCompleteFailed != null) {
                  widget.onAutoCompleteFailed(status);
                }
              },
              autocompleteOffset: widget.autocompleteOffset,
              autocompleteRadius: widget.autocompleteRadius,
              autocompleteLanguage: widget.autocompleteLanguage,
              autocompleteComponents: widget.autocompleteComponents,
              autocompleteTypes: widget.autocompleteTypes,
              strictbounds: widget.strictbounds,
              region: widget.region,
              initialSearchString: widget.initialSearchString,
              searchForInitialValue: widget.searchForInitialValue,
            ),
          ),
          SizedBox(width: 5),
        ],
      ),
    );
  }

  _pickPrediction(Prediction prediction) async {
    provider.placeSearchingState = SearchingState.Searching;

    final PlacesDetailsResponse response =
        await provider.places.getDetailsByPlaceId(
      prediction.placeId,
      sessionToken: provider.sessionToken,
      language: widget.autocompleteLanguage,
    );

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == "REQUEST_DENIED") {
      print("AutoCompleteSearch Error: " + response.errorMessage);
      if (widget.onAutoCompleteFailed != null) {
        widget.onAutoCompleteFailed(response.status);
      }
      return;
    }

    provider.selectedPlace = PickResult.fromPlaceDetailResult(response.result);

    // Prevents searching again by camera movement.
    provider.isAutoCompleteSearching = true;

    await _moveTo(provider.selectedPlace.geometry.location.lat,
        provider.selectedPlace.geometry.location.lng);

    provider.placeSearchingState = SearchingState.Idle;
  }

  _moveTo(double latitude, double longitude) async {
    GoogleMapController controller = provider.mapController;
    if (controller == null) return;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 16,
        ),
      ),
    );
  }

  _moveToCurrentPosition() async {
    if (provider.currentPosition != null) {
      await _moveTo(provider.currentPosition.latitude,
          provider.currentPosition.longitude);
    }
  }

  Widget _buildMapWithLocation() {
    if (widget.useCurrentLocation) {
      return FutureBuilder(
          future: provider
              .updateCurrentLocation(widget.forceAndroidLocationManager),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (provider.currentPosition == null) {
                return _buildMap(widget.initialPosition);
              } else {
                return _buildMap(LatLng(provider.currentPosition.latitude,
                    provider.currentPosition.longitude));
              }
            }
          });
    } else {
      return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 1)),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildMap(widget.initialPosition);
          }
        },
      );
    }
  }

  Widget _buildMap(LatLng initialTarget) {
    return GoogleMapPlacePicker(
      initialTarget: initialTarget,
      appBarKey: appBarKey,
      selectedPlaceWidgetBuilder: widget.selectedPlaceWidgetBuilder,
      pinBuilder: widget.pinBuilder,
      onSearchFailed: widget.onGeocodingSearchFailed,
      debounceMilliseconds: widget.cameraMoveDebounceInMilliseconds,
      enableMapTypeButton: widget.enableMapTypeButton,
      enableMyLocationButton: widget.enableMyLocationButton,
      usePinPointingSearch: widget.usePinPointingSearch,
      usePlaceDetailSearch: widget.usePlaceDetailSearch,
      onMapCreated: widget.onMapCreated,
      selectInitialPosition: widget.selectInitialPosition,
      language: widget.autocompleteLanguage,
      forceSearchOnZoomChanged: widget.forceSearchOnZoomChanged,
      onToggleMapType: () {
        provider.switchMapType();
      },
      onMyLocation: () async {
        // Prevent to click many times in short period.
        if (provider.isOnUpdateLocationCooldown == false) {
          provider.isOnUpdateLocationCooldown = true;
          Timer(Duration(seconds: widget.myLocationButtonCooldown), () {
            provider.isOnUpdateLocationCooldown = false;
          });
          await provider
              .updateCurrentLocation(widget.forceAndroidLocationManager);
          await _moveToCurrentPosition();
        }
      },
      onMoveStart: () {
        searchBarController.reset();
      },
      onPlacePicked: widget.onPlacePicked,
      getAddress: widget.getAddress,
    );
  }
}

