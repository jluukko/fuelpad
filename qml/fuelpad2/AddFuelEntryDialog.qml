/*
 * This file is part of Fuelpad.
 *
 * Copyright (C) 2007-2012 Julius Luukko <julle.luukko@quicknet.inet.fi>
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
import com.nokia.extras 1.1
import "UIConstants.js" as UIConstants

Page {
    tools: commonTools

    property int carId: -1
    property bool editMode: false
    property string oldId
    property string oldDate
    property double oldKm
    property double oldTrip
    property double oldFill
    property bool oldNotFull
    property double oldPrice
    property string oldNotes
    property double oldService
    property double oldOil
    property double oldTires
    property double oldLat
    property double oldLon
    property string oldPlace

    function open() {
        addDialog.open()
    }

    function launchDateDialogToToday() {
         var d = new Date();
         dateDialog.year = d.getFullYear();
         dateDialog.month = d.getMonth()+1;
         dateDialog.day = d.getDate();
         dateDialog.open();
    }

    function dateDialogAccecpted() {
        dateField.text = dateDialog.year+"-"+dateDialog.month+"-"+dateDialog.day
    }

    // applicationData.addFuelEntry could be directly called from onAccepted
    function addDialogAccepted() {
        if (editMode) {
            applicationData.updateFuelEntry(carId, oldId, dateField.text, kmField.text, tripField.text, fillField.text,
                                         notFullFill.checked, priceField.text, serviceField.text,
                                         oilField.text, tiresField.text, latField.text, lonField.text,
                                            placeField.text, notesField.text)
        } else {
            applicationData.addFuelEntry(carId, dateField.text, kmField.text, tripField.text, fillField.text,
                                         notFullFill.checked, priceField.text, serviceField.text,
                                         oilField.text, tiresField.text, latField.text, lonField.text,
                                         placeField.text, notesField.text)
        }
    }

    DatePickerDialog {
        id: dateDialog
        titleText: qsTr("Entry date")
        acceptButtonText: qsTr("OK")
        rejectButtonText: qsTr("Cancel")
        onAccepted: dateDialogAccecpted()
    }

    MyDialog {
        id: addDialog

        width: parent.width

        titleText: editMode ? qsTr("Edit fuel record") : qsTr("Add a new fuel record")

        content:Flickable {
            id: addDialogData
            anchors {
                fill: parent
                leftMargin: UIConstants.DEFAULT_MARGIN
                rightMargin: UIConstants.DEFAULT_MARGIN
            }
            contentWidth: column.width
            contentHeight: column.height
            flickableDirection: Flickable.VerticalFlick
            Column{
                id: column
                Grid {
                    columns: 2
                    spacing: UIConstants.PADDING_MEDIUM

                    ListButton {
                         id: dateButton
                         text: qsTr("Pick date")
                         width: text.width
                         onClicked: launchDateDialogToToday()
                    }
                    TextField {
                        id: dateField
                        placeholderText: qsTr("Add date")
                        maximumLength: 10
                        readOnly: true
                        text: editMode ? oldDate : ""
                    }
                    Text {
                        text: qsTr("Km")
                        font.pixelSize: UIConstants.FONT_DEFAULT
                    }
                    TextField {
                        id: kmField
                        placeholderText: qsTr("Add overall km")
                        maximumLength: 8
                        validator: DoubleValidator{bottom: 0.0}
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        text: editMode ? oldKm : ""
                    }
                    Text {
                        text: qsTr("Trip")
                        font.pixelSize: UIConstants.FONT_DEFAULT
                    }
                    TextField {
                        id: tripField
                        placeholderText: qsTr("Add trip")
                        maximumLength: 5
                        validator: DoubleValidator{bottom: 0.0}
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        text: editMode ? oldTrip : ""
                    }
                    Text {
                        text: qsTr("Fill")
                        font.pixelSize: UIConstants.FONT_DEFAULT
                    }
                    TextField {
                        id: fillField
                        placeholderText: qsTr("Add fill")
                        maximumLength: 5
                        validator: DoubleValidator{bottom: 0.0}
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        text: editMode ? oldFill : ""
                    }
                    Text {
                        text: qsTr("Not full fill")
                        font.pixelSize: UIConstants.FONT_DEFAULT
                    }
                    Switch {
                        id: notFullFill
                        checked: editMode ? oldNotFull : false
                    }
                    Text {
                        text: qsTr("Price")
                        font.pixelSize: UIConstants.FONT_DEFAULT
                    }
                    TextField {
                        id: priceField
                        placeholderText: qsTr("Add price")
                        maximumLength: 10
                        validator: DoubleValidator{}
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        text: editMode ? oldPrice : ""
                    }
                    Text {
                        text: qsTr("Notes")
                        font.pixelSize: UIConstants.FONT_DEFAULT
                    }
                    TextField {
                        id: notesField
                        placeholderText: qsTr("Add notes")
                        maximumLength: 120
                        validator: RegExpValidator{}
                        text: editMode ? oldNotes : ""
                    }
                    Text {
                        text: qsTr("Service")
                        font.pixelSize: UIConstants.FONT_DEFAULT
                    }
                    TextField {
                        id: serviceField
                        placeholderText: qsTr("Add service cost")
                        maximumLength: 5
                        validator: DoubleValidator{bottom: 0.0}
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        text: editMode ? oldService : ""
                    }
                    Text {
                        text: qsTr("Oil")
                        font.pixelSize: UIConstants.FONT_DEFAULT
                    }
                    TextField {
                        id: oilField
                        placeholderText: qsTr("Add oil cost")
                        maximumLength: 5
                        validator: DoubleValidator{bottom: 0.0}
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        text: editMode ? oldOil : ""
                    }
                    Text {
                        text: qsTr("Tires")
                        font.pixelSize: UIConstants.FONT_DEFAULT
                    }
                    TextField {
                        id: tiresField
                        placeholderText: qsTr("Add tires cost")
                        maximumLength: 5
                        validator: DoubleValidator{bottom: 0.0}
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        text: editMode ? oldTires : ""
                    }

                    Text {
                        text: qsTr("Latitude")
                        font.pixelSize: UIConstants.FONT_DEFAULT
                    }
                    TextField {
                        id: latField
                        text: editMode ? oldLat : positionSource.position.coordinate.latitude.toFixed(8)
                    }

                    Text {
                        text: qsTr("Longitude")
                        font.pixelSize: UIConstants.FONT_DEFAULT
                    }
                    TextField {
                        id: lonField
                        text: editMode ? oldLon : positionSource.position.coordinate.longitude.toFixed(8)
                    }

                    Text {
                        text: qsTr("Place")
                        font.pixelSize: UIConstants.FONT_DEFAULT
                    }
                    TextField {
                        id: placeField
                        placeholderText: qsTr("Add place")
                        maximumLength: 120
                        validator: RegExpValidator{}
                        text: editMode ? oldPlace : ""
                    }
                }

            }
        }

        buttons: ButtonRow {
            style: ButtonStyle { }
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                text: editMode ? qsTr("Apply") : qsTr("Add");
                onClicked: addDialog.accept()
            }
            Button {
                text: qsTr("Cancel");
                onClicked: addDialog.cancel()
            }
          }

        onAccepted: addDialogAccepted()

        }

}
