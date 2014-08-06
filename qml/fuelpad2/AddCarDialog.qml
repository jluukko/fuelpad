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

import QtQuick 2.0
import org.fuelpad.qmlui 1.0

FPDialog {
    id: addDialog

    property bool editMode: false
    property string oldId
    property string oldMark
    property string oldModel
    property string oldYear
    property string oldRegnum
    property string oldFueltype
    property string oldNotes

    width: parent.width

    title: editMode ? qsTr("Edit car") : qsTr("Add a new car")

    function addDialogAccepted() {
        if (editMode) {
            applicationData.updateCar(oldId, markField.text, modelField.text, yearField.text, regnumField.text,
                                            notesField.text, fueltypeField.selectedIndex)
        } else {
            applicationData.addCar(markField.text, modelField.text, yearField.text, regnumField.text,
                                         notesField.text, fueltypeField.selectedIndex)
        }
    }

    Flickable {
        id: addDialogData
        anchors {
            fill: parent
            leftMargin: appTheme.paddingLarge
            rightMargin: appTheme.paddingLarge
        }
        contentWidth: column.width
        contentHeight: column.height
        flickableDirection: Flickable.VerticalFlick

        // workaround https://bugreports.qt-project.org/browse/QTBUG-11403
        Text { text: qsTr(name) }
        ListModel {
            id: fueltypeModel
            ListElement { name: QT_TR_NOOP("Petrol") }
            ListElement { name: QT_TR_NOOP("Diesel") }
            ListElement { name: QT_TR_NOOP("Ethanol")}
            ListElement { name: QT_TR_NOOP("Other")}
        }

        Column {
            id: column
            spacing: appTheme.paddingMedium
            Grid {
                id: addDialogGrid
                columns: 1
                spacing: appTheme.paddingMedium
                Text {
                    text: qsTr("Mark")
                    font.pixelSize: appTheme.fontSizeMedium
                }
                FPTextField {
                    id: markField
                    width: addDialog.width-2*appTheme.paddingLarge
                    placeholderText: qsTr("My car mark")
                    maximumLength: 40
                    validator: RegExpValidator{}
                    text: editMode ? oldMark : ""
                }
                Text {
                    text: qsTr("Model")
                    font.pixelSize: appTheme.fontSizeMedium
                }
                FPTextField {
                    id: modelField
                    width: addDialog.width-2*appTheme.paddingLarge
                    placeholderText: qsTr("My car model")
                    maximumLength: 40
                    validator: RegExpValidator{}
                    text: editMode ? oldModel : ""
                }
                Text {
                    text: qsTr("Model year")
                    font.pixelSize: appTheme.fontSizeMedium
                }
                FPTextField {
                    id: yearField
                    width: addDialog.width-2*appTheme.paddingLarge
                    placeholderText: qsTr("My car model year")
                    maximumLength: 4
                    validator: IntValidator{bottom: 1800; top: 2100}
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    text: editMode ? oldYear : ""
                }
                Text {
                    text: qsTr("Registration number")
                    font.pixelSize: appTheme.fontSizeMedium
                }
                FPTextField {
                    id: regnumField
                    width: addDialog.width-2*appTheme.paddingLarge
                    placeholderText: qsTr("My car registration number")
                    maximumLength: 40
                    validator: RegExpValidator{}
                    text: editMode ? oldRegnum : ""
                }
                Text {
                    text: qsTr("Notes")
                    font.pixelSize: appTheme.fontSizeMedium
                }
                FPTextField {
                    id: notesField
                    width: addDialog.width-2*appTheme.paddingLarge
                    placeholderText: qsTr("Add notes")
                    maximumLength: 120
                    validator: RegExpValidator{}
                    text: editMode ? oldNotes : ""
                }
            }
            FPTouchSelector {
                id: fueltypeField
                buttonText: qsTr("Primary fuel type")
                titleText: qsTr("Select primary fuel type")
                selectedIndex: 0
                model: fueltypeModel
            }
        }

    }

    buttons: FPButtonRow {
        anchors.horizontalCenter: parent.horizontalCenter
        FPButton {
            text: editMode ? qsTr("Apply") : qsTr("Add");
            onClicked: addDialog.accept()
        }
        FPButton {
            text: qsTr("Cancel");
            onClicked: addDialog.cancel()
        }
      }

    onAccepted: addDialogAccepted()

}
