import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/components/table_row.dart';
import 'package:muserpol_pvt/model/contacts_model.dart';
import 'package:url_launcher/url_launcher.dart' as urlauncher;

class CardContact extends StatefulWidget {
  final City city;
  const CardContact({super.key, required this.city});

  @override
  State<CardContact> createState() => _CardContactState();
}

class _CardContactState extends State<CardContact> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  AvailableMap? itemSelect;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: ContainerComponent(
        child:  Row(children: [
              Expanded(
                  child: Column(
                children: [
                  Text(widget.city.name!),
                  const SizedBox(height: 20),
                  Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3.5),
                        1: FlexColumnWidth(0.5),
                        2: FlexColumnWidth(6),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        tableInfo(
                            'Dirección:',
                            GestureDetector(
                              onTap: () => openMapsSheet(context, Coords(widget.city.latitude!, widget.city.longitude!), widget.city.companyAddress!),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on),
                                  Flexible(
                                      child: Text(
                                    widget.city.companyAddress!,
                                    style: const TextStyle(color: Color(0xff439CAB)),
                                  ))
                                ],
                              ),
                            )),
                        if (json.decode(widget.city.companyPhones!).length > 0)
                          tableInfo(
                              'Teléfonos:',
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var item in json.decode(widget.city.companyPhones!))
                                    GestureDetector(
                                      onTap: () => urlauncher.launchUrl(Uri(scheme: 'tel', path: '$item')),
                                      child: Text('$item', style: const TextStyle(color: Color(0xff439CAB))),
                                    )
                                ],
                              )),
                        if (json.decode(widget.city.companyCellphones!).length > 0)
                          tableInfo(
                              'Celulares:',
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var item in json.decode(widget.city.companyCellphones!))
                                    GestureDetector(
                                      onTap: () => urlauncher.launchUrl(Uri(scheme: 'tel', path: '$item')),
                                      child: Text('$item', style: const TextStyle(color: Color(0xff439CAB))),
                                    )
                                ],
                              )),
                      ])
                ],
              ))
            ])));
  }

  openMapsSheet(context, Coords coords, String title) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                        onTap: () => map.showMarker(
                              coords: coords,
                              title: title,
                            ),
                        title: Text('Abrir: ${map.mapName}'),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        )),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('e $e');
    }
  }
}
