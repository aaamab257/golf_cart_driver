import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../helpers/stars_method.dart';
import '../helpers/style.dart';
import '../providers/app_provider.dart';
import '../providers/user.dart';
import '../widgets/custom_btn.dart';
import '../widgets/custom_text.dart';

class RideRequestScreen extends StatefulWidget {
  @override
  _RideRequestScreenState createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  @override
  void initState() {
    super.initState();
    AppStateProvider _state =
        Provider.of<AppStateProvider>(context, listen: false);
    _state.listenToRequest(id: _state.rideRequestModel.id, context: context);
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: "New Ride Request",
          size: 19,
          weight: FontWeight.bold,
        ),
      ),
      backgroundColor: white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(40)),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 45,
                    child: Icon(
                      Icons.person,
                      size: 65,
                      color: white,
                    ),
                  ),
                ),
                // if (appState.riderModel.photo == null)

                // if (appState.riderModel.photo != null)
                //   Container(
                //     decoration: BoxDecoration(
                //         color: Colors.deepOrange,
                //         borderRadius: BorderRadius.circular(40)),
                //     child: CircleAvatar(
                //       radius: 45,
                //       backgroundImage: NetworkImage(appState.riderModel?.photo),
                //     ),
                //   ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: "Hind" ?? "Nada"),
              ],
            ),
            SizedBox(height: 10),
            stars(rating: 5, votes: 5),
            Divider(),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Destiation",
                    color: grey,
                  ),
                ],
              ),
              subtitle: ElevatedButton.icon(
                  onPressed: () async {
                    LatLng destinationCoordiates =
                        LatLng(21.5777381, 39.1828419);
                    appState.addLocationMarker(
                        destinationCoordiates,
                        "كلية الآداب والعلوم الانسانية_ جامعة جدة، Jeddah Saudi Arabia" ??
                            "Nada",
                        "Destination Location");
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return Container(
                            height: 400,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                  target: destinationCoordiates, zoom: 13),
                              onMapCreated: appState.onCreate,
                              myLocationEnabled: true,
                              mapType: MapType.normal,
                              tiltGesturesEnabled: true,
                              compassEnabled: false,
                              markers: appState.markers,
                              onCameraMove: appState.onCameraMove,
                              polylines: appState.poly,
                            ),
                          );
                        });
                  },
                  icon: Icon(
                    Icons.location_on,
                  ),
                  label: CustomText(
                    text:
                        "كلية الآداب والعلوم الانسانية_ جامعة جدة، Jeddah Saudi Arabia" ??
                            "Nada",
                    weight: FontWeight.bold,
                  )),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.flag),
                    label: Text('User is near by')),
                ElevatedButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.attach_money),
                    label: Text("${6519 / 500} ")),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomBtn(
                  text: "Accept",
                  onTap: () async {
                    appState.clearMarkers();

                    appState.acceptRequest(
                        requestId: "1c6e8a70-ace8-11ed-9bb9-7b44632198a4",
                        driverId: userProvider.userModel.id);
                    appState.changeWidgetShowed(showWidget: Show.RIDER);
                    appState.sendRequest(
                        coordinates:
                            appState.requestModelFirebase.getCoordinates());
                    // if (appState.requestModelFirebase.status != "pending") {
                    //   showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return Dialog(
                    //           shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(
                    //                   20.0)), //this right here
                    //           child: Container(
                    //             height: 200,
                    //             child: Padding(
                    //                 padding: const EdgeInsets.all(12.0),
                    //                 child: Column(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     CustomText(
                    //                         text: "Sorry! Request Expired")
                    //                   ],
                    //                 )),
                    //           ),
                    //         );
                    //       });
                    // } else {
                    //   appState.clearMarkers();

                    //   appState.acceptRequest(
                    //       requestId: appState.rideRequestModel.id,
                    //       driverId: userProvider.userModel.id);
                    //   appState.changeWidgetShowed(showWidget: Show.RIDER);
                    //   appState.sendRequest(
                    //       coordinates:
                    //           appState.requestModelFirebase.getCoordinates());
                    // }
                  },
                  bgColor: green,
                  shadowColor: Colors.greenAccent,
                ),
                CustomBtn(
                  text: "Reject",
                  onTap: () {
                    appState.clearMarkers();
                    appState.changeRideRequestStatus();
                  },
                  bgColor: red,
                  shadowColor: Colors.redAccent,
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
