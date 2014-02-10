/*
 * This file is part of Fuelpad.
 *
 * Copyright (C) 2007-2012,2014 Julius Luukko <julle.luukko@quicknet.inet.fi>
 *
 * Fuelpad is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Fuelpad is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Fuelpad.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import "UIConstants.js" as UIConstants
import "CommonFuncs.js" as Funcs
import "CommonUnits.js" as Units

Page {
    id: selectLocationPage

    function open() {
        locationDialog.open()
    }

    function toggleGPS() {
        if (enableGPS.checked) {
            positionSource.start()
        }
        else {
            positionSource.stop()
        }
    }

    function locationDialogAccepted() {
        parent.addressFound(placeField.text);
    }

    Connections {
        target: applicationData
        onAddressReady: {
            placeField.text = applicationData.getAddress()
            console.log(applicationData.getAddress())
        }
    }

    MyDialog {
        id: locationDialog
        width: parent.width

        titleText: qsTr("Retrieve location")

        content:Flickable {
            id: locationDialogData
            anchors {
                fill: parent
                leftMargin: UIConstants.DEFAULT_MARGIN
                rightMargin: UIConstants.DEFAULT_MARGIN
            }
            contentWidth: column.width
            contentHeight: column.height
            flickableDirection: Flickable.VerticalFlick

            Column {
                id: column
                spacing: UIConstants.PADDING_MEDIUM

                Grid {
                    columns: 2
                    spacing: UIConstants.PADDING_MEDIUM

                    Label {
                        text: qsTr("Enable GPS")
                    }

                    // todo Get checked from global settings
                    Switch {
                        id: enableGPS
                        checked: positionSource.active
                        onCheckedChanged: toggleGPS()
                    }

                    Label {
                        text: qsTr("Latitude")
                        font.pixelSize: UIConstants.FONT_DEFAULT
                    }
                    Label {
                        id: latField
                        text: positionSource.position.coordinate.latitude.toFixed(8)
                    }

                    Label {
                        text: qsTr("Longitude")
                        font.pixelSize: UIConstants.FONT_DEFAULT
                    }
                    Label {
                        id: lonField
                        text: positionSource.position.coordinate.longitude.toFixed(8)
                    }

                    Label {
                        text: qsTr("Position valid")
                    }

                    Label {
                        text: (positionSource.position.latitudeValid && positionSource.position.longitudeValid) ?
                                  qsTr("valid") : qsTr("invalid")
                    }

                    Label {
                        text: qsTr("Horizontal accuracy")
                    }

                    Label {
                        text: positionSource.position.horizontalAccuracy.toFixed(1)
                    }

                    Label {
                        text: qsTr("Vertical accuracy")
                    }

                    Label {
                        text: positionSource.position.verticalAccuracy.toFixed(1)
                    }

                }

                Button {
//                    anchors.horizontalCenter: locationDialog.horizontalCenter
                    text: qsTr("Retrieve address")
                    onClicked: applicationData.requestAddress(latField.text, lonField.text)
                }

                TextArea {
                    id: placeField
                    width: locationDialog.width-2*UIConstants.DEFAULT_MARGIN
                    height: 4*UIConstants.FONT_DEFAULT
                    placeholderText: qsTr("Place")
                    readOnly: true
                }

            }
        }
        buttons: ButtonRow {
            style: ButtonStyle { }
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                text: qsTr("Apply")
                onClicked: locationDialog.accept()
            }
            Button {
                text: qsTr("Cancel");
                onClicked: locationDialog.cancel()
            }
        }

        onAccepted: locationDialogAccepted()

    }


}
