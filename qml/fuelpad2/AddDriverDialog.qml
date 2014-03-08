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
import org.fuelpad.qmlui 1.0

FPPage {
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

    MyDialog {
        id: addDialog

        width: parent.width

        titleText: editMode ? qsTr("Edit driver") : qsTr("Add a new driver")

        content:Flickable {
            id: addDialogData
            height: 600
            anchors {
                fill: parent
                leftMargin: appTheme.paddingLarge
                rightMargin: appTheme.paddingLarge
            }
            contentWidth: addDialogGrid.width
            contentHeight: addDialogGrid.height
            Grid {
                id: addDialogGrid
                columns: 1
                spacing: appTheme.paddingMedium
                Text {
                    text: qsTr("Full name")
                    font.pixelSize: appTheme.fontSizeMedium
                }
                FPTextField {
                    id: fullnameField
                    width: addDialog.width-2*appTheme.paddingLarge
                    placeholderText: qsTr("Full name")
                    maximumLength: 40
                    validator: RegExpValidator{}
                    text: editMode ? oldFullname : ""
                }
                Text {
                    text: qsTr("Nick name")
                    font.pixelSize: appTheme.fontSizeMedium
                }
                FPTextField {
                    id: nicknameField
                    width: addDialog.width-2*appTheme.paddingLarge
                    placeholderText: qsTr("Nick name")
                    maximumLength: 40
                    validator: RegExpValidator{}
                    text: editMode ? oldNickname : ""
                }
            }

        }

        buttons: FPButtonRow {
            style: FPButtonStyle { }
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

}
