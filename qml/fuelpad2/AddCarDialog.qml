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

    property bool editMode: false
    property string oldId
    property string oldMark
    property string oldModel
    property string oldYear
    property string oldRegnum
    property string oldFueltype
    property string oldNotes

    function open() {
        addDialog.open()
    }

    // applicationData.addFuelEntry could be directly called from onAccepted
    function addDialogAccepted() {
        if (editMode) {
            console.log("Now entry would be updated if a function would exist")
            applicationData.updateCar(oldId, markField.text, modelField.text, yearField.text, regnumField.text,
                                            notesField.text, fueltypeField.selectedIndex)
        } else {
            applicationData.addCar(markField.text, modelField.text, yearField.text, regnumField.text,
                                         notesField.text, fueltypeField.selectedIndex)
        }
    }

    // workaround https://bugreports.qt-project.org/browse/QTBUG-11403
    Text { text: qsTr(name) }
    ListModel {
        id: fueltypeModel
        ListElement { name: QT_TR_NOOP("Petrol") }
        ListElement { name: QT_TR_NOOP("Diesel") }
        ListElement { name: QT_TR_NOOP("Ethanol")}
        ListElement { name: QT_TR_NOOP("Other")}
    }

    MyDialog {
        id: addDialog

        width: parent.width

        titleText: editMode ? qsTr("Edit car") : qsTr("Add a new car")

        content:Flickable {
            id: addDialogData
            height: 600
            width: parent.width
            Grid {
                id: addDialogGrid
                columns: 2
                spacing: UIConstants.PADDING_MEDIUM
                Text {
                    text: qsTr("Mark")
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    font.weight: Font.Light
                    color: "white"
                }
                TextField {
                    id: markField
                    placeholderText: qsTr("My car mark")
                    maximumLength: 40
                    validator: RegExpValidator{}
                    text: editMode ? oldMark : ""
                }
                Text {
                    text: qsTr("Model")
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    font.weight: Font.Light
                    color: "white"
                }
                TextField {
                    id: modelField
                    placeholderText: qsTr("My car model")
                    maximumLength: 40
                    validator: RegExpValidator{}
                    text: editMode ? oldModel : ""
                }
                Text {
                    text: qsTr("Model year")
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    font.weight: Font.Light
                    color: "white"
                }
                TextField {
                    id: yearField
                    placeholderText: qsTr("My car model year")
                    maximumLength: 4
                    validator: IntValidator{bottom: 1800; top: 2100}
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    text: editMode ? oldYear : ""
                }
                Text {
                    text: qsTr("Registration number")
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    font.weight: Font.Light
                    color: "white"
                }
                TextField {
                    id: regnumField
                    placeholderText: qsTr("My car registration number")
                    maximumLength: 40
                    validator: RegExpValidator{}
                    text: editMode ? oldRegnum : ""
                }
                Text {
                    text: qsTr("Notes")
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    font.weight: Font.Light
                    color: "white"
                }
                TextField {
                    id: notesField
                    placeholderText: qsTr("Add notes")
                    maximumLength: 120
                    validator: RegExpValidator{}
                    text: editMode ? oldNotes : ""
                }
            }

            TouchSelector {
                id: fueltypeField
                anchors.top: addDialogGrid.bottom
                buttonText: qsTr("Primary fuel type")
                titleText: qsTr("Select primary fuel type")
                selectedIndex: 0
                model: fueltypeModel
            }

        }

        buttons: ButtonRow {
            platformStyle: ButtonStyle { }
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
        onRejected: console.log("Dialog: Rejected")

        }

}
