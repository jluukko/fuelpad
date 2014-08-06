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

FPPage {
    id: aboutPage

    FPApplicationTheme {
        id: appTheme
    }

    FPSimpleDialog {
        id: aboutDialog

        width: aboutPage.width

        title: Column {
                spacing: appTheme.paddingMedium
                Text {
                    id: titleText
                    font.pixelSize: appTheme.fontSizeExtraLarge
                    font.weight: Font.Bold
                    color: "white"
                    text: "Fuelpad2 v 0.0.12"
                }
                Rectangle {
                    id: titleField
                    height: 2
                    width: titleText.width
                    color: "red"
                }
        }

        content:Item {
            id: aboutDialogData
            height: childrenRect.height + 20
            width: aboutPage.width
            Text {
                width: 0.9*aboutPage.width
                text: "<b>Copyright (C) Julius Luukko 2008-2011,2014"
                      + "<p>"
                      + "<small>This software is free software distributed under the terms of"
                      + "the GNU General Public License version 3 or later.</small>"
                font.pixelSize: appTheme.fontSizeMedium
                font.weight: Font.Light
                color: "white"
                wrapMode: Text.WordWrap
            }
        }

        buttons: FPButtonRow {
            FPButton {
                text: qsTr("Close")
                onClicked: aboutDialog.accept()
            }
          }

    }
}
