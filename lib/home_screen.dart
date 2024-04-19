import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final Completer<GoogleMapController> _controller = Completer();
  
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14
  );

  List<Marker> _marker = [];
  List<Marker> _list = const [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(37.42796133580664, -122.085749655962),
      infoWindow: InfoWindow(
        title: 'ID 1 position'
      )
    )
  ];

  loadData ()
  {
    getUserCurrentLocation().then((value)
      async {
        print("current location");
        print(value.latitude.toString() + " " + value.longitude.toString());

        _marker.add(
          Marker(
            markerId: MarkerId('2'),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: InfoWindow(
              title: "current location"
            )
          )
        );

        CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 14
        );

        final GoogleMapController controller = await _controller.future;

        controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        setState(() {
              
        });
      });
  }

  @override
  void initState() 
  {
    super.initState();
    _marker.addAll(_list);
    loadData();
  }

  Future<Position> getUserCurrentLocation()
  async {
    await Geolocator.requestPermission().then((value)
    {

    }).onError((error, stackTrace)
    {
      print("error" + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        mapType: MapType.normal,
        myLocationEnabled: true,
        compassEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        onMapCreated: (GoogleMapController controller)
        {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(_marker),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          getUserCurrentLocation().then((value)
          async {
            print("current location");
            print(value.latitude.toString() + " " + value.longitude.toString());

            _marker.add(
              Marker(
                markerId: MarkerId('2'),
                position: LatLng(value.latitude, value.longitude),
                infoWindow: InfoWindow(
                  title: "current location"
                )
              )
            );

            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 14
            );

            final GoogleMapController controller = await _controller.future;

            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {
              
            });
          });
        },
        child: const Icon(Icons.radio_button_off),
      ),
    );
  }
}