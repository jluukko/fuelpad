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
    property string oldFullname
    property string oldNickname

    function open() {
        addDialog.open()
    }

    // applicationData.addFuelEntry could be directly called from onAccepted
    function addDialogAccepted() {
        if (editMode) {
            console.log("Now entry would be updated if a function would exist")
            applicationData.updateDriver(oldId, fullnameField.text, nicknameField.text)
        } else {
            applicationData.addDriver(fullnameField.text, nicknameField.text)
        }
    }

    Dialog {
        id: addDialog

        width: parent.width

        title: Column {
                spacing: UIConstants.PADDING_MEDIUM
                Text {
                    id: titleText
                    font.pixelSize: UIConstants.FONT_XLARGE
                    font.weight: Font.Bold
//                    anchors.centerIn: parent
                    color: "white"
                    text: editMode ? qsTr("Edit driver") : qsTr("Add a new driver")
                }
                Rectangle {
                    id: titleField
                    height: 2
                    width: parent.width
                    color: "red"
                }
        }

        content:Item {
            id: addDialogData
            height: 600
            width: parent.width
            Grid {
                id: addDialogGrid
                columns: 2
                spacing: UIConstants.PADDING_MEDIUM
                Text {
                    text: qsTr("Full name")
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    font.weight: Font.Light
                    color: "white"
                }
                TextField {
                    id: fullnameField
                    placeholderText: qsTr("Full name")
                    maximumLength: 40
                    validator: RegExpValidator{}
                    text: editMode ? oldFullname : ""
                }
                Text {
                    text: qsTr("Nick name")
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    font.weight: Font.Light
                    color: "white"
                }
                TextField {
                    id: nicknameField
                    placeholderText: qsTr("Nick name")
                    maximumLength: 40
                    validator: RegExpValidator{}
                    text: editMode ? oldNickname : ""
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
                onClicked: addDialog.reject()
            }
          }

        onAccepted: addDialogAccepted()
        onRejected: console.log("Dialog: Rejected")

        }

}
