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

import CustomComponents 1.0
// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import com.nokia.meego 1.1
import "UIConstants.js" as UIConstants
import "CommonFuncs.js" as Funcs

Page {
    id: statisticPage
    orientationLock: PageOrientation.LockLandscape
    tools: commonTools

    ListModel {
        id: plotData
        ListElement {
            xc: 0.0
            yc: 0.0
        }
        ListElement {
            xc: 0.1
            yc: 0.2
        }
        ListElement {
            xc: 0.2
            yc: 0.4
        }
        ListElement {
            xc: 0.3
            yc: 0.6
        }
        ListElement {
            xc: 0.4
            yc: 0.8
        }
    }

    Plot {
        width: parent.width
        height: 200
        anchors.top: parent.top
        data: plotData
    }

}
