import 'dart:async';
import 'package:Humanely/providers/place_provider.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../google_maps_place_picker.dart';
import 'components/animated_pin.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/services.dart' show rootBundle;

String _currentAddress = "";
loc.LocationData locationData;
loc.Location location;
loc.LocationData currentLocation;
String _mapStyle;

typedef SelectedPlaceWidgetBuilder = Widget Function(
    BuildContext context,
    PickResult selectedPlace,
    SearchingState state,
    bool isSearchBarFocused,
    );

typedef PinBuilder = Widget Function(
    BuildContext context,
    PinState state,
    );

class GoogleMapPlacePicker extends StatelessWidget {
  const GoogleMapPlacePicker({
    Key key,
    @required this.initialTarget,
    @required this.appBarKey,
    this.selectedPlaceWidgetBuilder,
    this.pinBuilder,
    this.onSearchFailed,
    this.onMoveStart,
    this.onMapCreated,
    this.debounceMilliseconds,
    this.enableMapTypeButton,
    this.enableMyLocationButton,
    this.onToggleMapType,
    this.onMyLocation,
    this.onPlacePicked,
    this.getAddress,
    this.usePinPointingSearch,
    this.usePlaceDetailSearch,
    this.selectInitialPosition,
    this.language,
    this.forceSearchOnZoomChanged,
  }) : super(key: key);

  final LatLng initialTarget;
  final GlobalKey appBarKey;

  final SelectedPlaceWidgetBuilder selectedPlaceWidgetBuilder;
  final PinBuilder pinBuilder;

  final ValueChanged<String> onSearchFailed;
  final VoidCallback onMoveStart;
  final MapCreatedCallback onMapCreated;
  final VoidCallback onToggleMapType;
  final VoidCallback onMyLocation;
  final ValueChanged<PickResult> onPlacePicked;
  final ValueChanged<String> getAddress;

  final int debounceMilliseconds;
  final bool enableMapTypeButton;
  final bool enableMyLocationButton;

  final bool usePinPointingSearch;
  final bool usePlaceDetailSearch;

  final bool selectInitialPosition;

  final String language;

  final bool forceSearchOnZoomChanged;

  _searchByCameraLocation(PlaceProvider provider) async {
    // We don't want to search location again if camera location is changed by zooming in/out.
    bool hasZoomChanged = provider.cameraPosition != null &&
        provider.prevCameraPosition != null &&
        provider.cameraPosition.zoom != provider.prevCameraPosition.zoom;
    if (forceSearchOnZoomChanged == false && hasZoomChanged) return;

    provider.placeSearchingState = SearchingState.Searching;

    //double long = provider.cameraPosition.target.longitude;
    //double lat = provider.cameraPosition.target.latitude;

    final coordinates = new Coordinates(
        provider.cameraPosition.target.latitude, provider.cameraPosition.target.longitude);

    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);

    var first = addresses.first;
    _currentAddress = '${first.addressLine}';

    final GeocodingResponse response =
    await provider.geocoding.searchByLocation(
      Location(provider.cameraPosition.target.latitude,
          provider.cameraPosition.target.longitude),
      language: language,
    );

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == "REQUEST_DENIED") {
      print("Camera Location Search Error: " + response.errorMessage);
      if (onSearchFailed != null) {
        onSearchFailed(response.status);
      }
      provider.placeSearchingState = SearchingState.Idle;
      return;
    }

    if (usePlaceDetailSearch) {
      final PlacesDetailsResponse detailResponse =
      await provider.places.getDetailsByPlaceId(
        response.results[0].placeId,
        language: language,
      );

      if (detailResponse.errorMessage?.isNotEmpty == true ||
          detailResponse.status == "REQUEST_DENIED") {
        print("Fetching details by placeId Error: " +
            detailResponse.errorMessage);
        if (onSearchFailed != null) {
          onSearchFailed(detailResponse.status);
        }
        provider.placeSearchingState = SearchingState.Idle;
        return;
      }

      provider.selectedPlace =
          PickResult.fromPlaceDetailResult(detailResponse.result);
    } else {
      provider.selectedPlace =
          PickResult.fromGeocodingResult(response.results[0]);
    }

    provider.placeSearchingState = SearchingState.Idle;
  }


  void setInitialLocation() async {
    location = new loc.Location();
    location.onLocationChanged.listen((loc.LocationData cLoc) {
      currentLocation = cLoc;
    });

    final coordinates = new Coordinates(
        currentLocation.latitude, currentLocation.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    _currentAddress = '${first.addressLine}';
    _buildFloatingCard();
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        _buildGoogleMap(context),
        _buildPin(),
        //_buildFloatingCard(),
        _buildMapIcons(context),
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Selector<PlaceProvider, MapType>(
        selector: (_, provider) => provider.mapType,
        builder: (_, data, __) {
          PlaceProvider provider = PlaceProvider.of(context, listen: false);
          CameraPosition initialCameraPosition =
          CameraPosition(target: initialTarget, zoom: 15);

          return GoogleMap(
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            initialCameraPosition: initialCameraPosition,
            mapType: data,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) async {
              print("map created");
              String style = await getJsonFile('assets/map/map_style.json');
              provider.mapController = controller;
              provider.setCameraPosition(null);
              provider.pinState = PinState.Idle;
              provider.mapController.setMapStyle(style);

              // When select initialPosition set to true.
              if (selectInitialPosition) {
                provider.setCameraPosition(initialCameraPosition);
                _searchByCameraLocation(provider);
              }

              setInitialLocation();

            },
            onCameraIdle: () {
              print("map idle");
              if (provider.isAutoCompleteSearching) {
                provider.isAutoCompleteSearching = false;
                provider.pinState = PinState.Idle;
                return;
              }

              // Perform search only if the setting is to true.
              if (usePinPointingSearch) {
                // Search current camera location only if camera has moved (dragged) before.
                if (provider.pinState == PinState.Dragging) {
                  // Cancel previous timer.
                  if (provider.debounceTimer?.isActive ?? false) {
                    provider.debounceTimer.cancel();
                  }
                  provider.debounceTimer =
                      Timer(Duration(milliseconds: debounceMilliseconds), () {
                        _searchByCameraLocation(provider);
                      });
                }
              }

              provider.pinState = PinState.Idle;
            },
            onCameraMoveStarted: () {
              print("map move started");
              provider.setPrevCameraPosition(provider.cameraPosition);

              // Cancel any other timer.
              provider.debounceTimer?.cancel();

              // Update state, dismiss keyboard and clear text.
              provider.pinState = PinState.Dragging;

              onMoveStart();
            },
            onCameraMove: (CameraPosition position) {
              print("map moving");
              provider.setCameraPosition(position);
            },
          );
        });
  }

  Widget _buildPin() {
    return Center(
      child: Selector<PlaceProvider, PinState>(
        selector: (_, provider) => provider.pinState,
        builder: (context, state, __) {
          if (pinBuilder == null) {
            return _defaultPinBuilder(context, state);
          } else {
            return Builder(
                builder: (builderContext) => pinBuilder(builderContext, state));
          }
        },
      ),
    );
  }

  Widget _defaultPinBuilder(BuildContext context, PinState state) {
    if (state == PinState.Preparing) {
      return Container();
    } else if (state == PinState.Idle) {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.place, size: 36, color: Colors.red),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedPin(
                    child: Icon(Icons.place, size: 36, color: Colors.red)),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildFloatingCard() {
    return Selector<PlaceProvider, Tuple3<PickResult, SearchingState, bool>>(
      selector: (_, provider) => Tuple3(provider.selectedPlace,
          provider.placeSearchingState, provider.isSearchBarFocused),
      builder: (context, data, __) {
        return _defaultPlaceWidgetBuilder(context, data.item1, data.item2);
//        if ((data.item1 == null && data.item2 == SearchingState.Idle) ||
//            data.item3 == true) {
//          return Container();
//        } else {
//          if (selectedPlaceWidgetBuilder == null) {
//            return _defaultPlaceWidgetBuilder(context, data.item1, data.item2);
//          } else {
//            return Builder(
//                builder: (builderContext) => selectedPlaceWidgetBuilder(
//                    builderContext, data.item1, data.item2, data.item3));
//          }
//        }
      },
    );
  }

  Widget _defaultPlaceWidgetBuilder(
      BuildContext context, PickResult data, SearchingState state) {
    return FloatingCard(
      bottomPosition: MediaQuery.of(context).size.height * 0.05,
      leftPosition: MediaQuery.of(context).size.width * 0.025,
      rightPosition: MediaQuery.of(context).size.width * 0.025,
      width: MediaQuery.of(context).size.width * 0.9,
      borderRadius: BorderRadius.circular(12.0),
      elevation: 4.0,
      color: Theme.of(context).cardColor,
      child: state == SearchingState.Searching
          ? _buildLoadingIndicator()
          : _buildSelectionDetails(context, data),
    );
  }

  Widget _buildLoadingIndicator() {
    print("in indicator");
    return Container(
      height: 48,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

//  String getAddress(_currentAddress){
//    return _currentAddress;
//  }

  Widget _buildSelectionDetails(BuildContext context, PickResult result) {
    print("in details");
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            _currentAddress,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "Select here",
              style: TextStyle(fontSize: 16,color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            onPressed: () {
              print("place picked "+_currentAddress);
              onPlacePicked(result);
              getAddress(_currentAddress);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapIcons(BuildContext context) {
    final RenderBox appBarRenderBox =
    appBarKey.currentContext.findRenderObject();

    return Positioned(
      top: appBarRenderBox.size.height+10.0,
      right: 15,
      child: Column(
        children: <Widget>[
//          enableMapTypeButton
//              ? Container(
//            width: 35,
//            height: 35,
//            child: RawMaterialButton(
//              shape: CircleBorder(),
//              fillColor: Theme.of(context).brightness == Brightness.dark
//                  ? Colors.black54
//                  : Colors.white,
//              elevation: 8.0,
//              onPressed: onToggleMapType,
//              child: Icon(Icons.layers),
//            ),
//          )
//              : Container(),
          SizedBox(height: 10),
          enableMyLocationButton
              ? Container(
            width: 35,
            height: 35,
            child: RawMaterialButton(
              shape: CircleBorder(),
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black54
                  : Colors.white60,
              elevation: 8.0,
              onPressed: onMyLocation,
              child: Icon(Icons.my_location),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}
