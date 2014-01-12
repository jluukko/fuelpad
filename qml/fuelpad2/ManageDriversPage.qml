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
import "UIConstants.js" as UIConstants
import "CommonFuncs.js" as Funcs

Page {
    tools: commonTools

    PageHeader {
        id: applicationHeader
        title: "Drivers"
        titleForegroundColor: UIConstants.COLOR_PAGEHEADER_FOREGROUND
        titleBackgroundColor: UIConstants.COLOR_PAGEHEADER_BACKGROUND
    }

    Text {
        wrapMode: Text.WordWrap
        text: "Driver management has not been implemented yet"
        font.pixelSize: UIConstants.FONT_XLARGE
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
    }

}
