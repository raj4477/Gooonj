import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gooonj_app/http_function.dart';
import 'package:gooonj_app/theme.dart';

class FutureMapScreen extends StatelessWidget {
  const FutureMapScreen({Key? key}) : super(key: key);

  Future<List<dynamic>> machines() async {
    final response = await httpFunGet('machines');

    final object = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return object['machines'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: machines(),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          return MapScreen(machines: snapshot.data!);
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: mainRed,
              color: floatingAction,
            ),
          );
        }
      },
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key, required this.machines}) : super(key: key);
  final List<dynamic> machines;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(26.87976274075033, 75.81260405424698),
    zoom: 14.4746,
  );
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          compassEnabled: true,
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          markers: dynamicMarkerSet(),
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }

  Set<Marker> dynamicMarkerSet() {
    return widget.machines
        .map(
          (machine) => Marker(
              markerId: MarkerId(machine['_id']),
              icon: BitmapDescriptor.defaultMarker,
              infoWindow:
                  InfoWindow(title: '${machine['name']}, ${machine['area']}'),
              position: LatLng(machine['latitude'], machine['longitude'])),
        )
        .toSet();
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context, Size size) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) => SizedBox(
        height: size.height * .3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'IIT Roorkee Gooonj Hotspot',
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: "Outfit-Bold",
                      fontSize: size.width * .07,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: size.height * .01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'IIT Roorkee, Roorkee, Uttrakhand',
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: "Outfit-Regular",
                      fontSize: size.width * .04,
                    ),
                  ),
                  Text(
                    'status: Working',
                    style: TextStyle(
                        fontFamily: "Outfit-Bold",
                        fontSize: size.width * .04,
                        color: Colors.green),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .1,
              ),
              InkWell(
                // onTap: (){getDirection(LatLng(29.8651735, 77.8963589));},
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: mainRed, borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Direction',
                        style: TextStyle(
                            fontFamily: "Outfit-Bold",
                            fontSize: size.width * .05,
                            color: Colors.white),
                      ),
                      SizedBox(
                        width: size.width * .015,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
