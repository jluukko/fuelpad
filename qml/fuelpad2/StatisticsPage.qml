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
//    orientationLock: PageOrientation.LockLandscape
    tools: commonTools

    property int year: 2014

    function changeYear(dy) {
        year = year + dy;
        applicationData.getStatistics(year,2);
    }

    PageHeader {
        id: statisticsHeader
        title: applicationData.getCarMark(-1) + " " + applicationData.getCarModel(-1)
        titleForegroundColor: UIConstants.COLOR_PAGEHEADER_FOREGROUND
        titleBackgroundColor: UIConstants.COLOR_PAGEHEADER_BACKGROUND
    }

    ListModel {
        id: testData
        ListElement {
            xc: 1
            yc: 10.222925023141
        }
        ListElement {
            xc: 2
            yc: 10.6830122591944
        }
        ListElement {
            xc: 3
            yc: 11.6581777023203
        }
        ListElement {
            xc: 4
            yc: 10.4933857704684
        }
        ListElement {
            xc: 5
            yc: 0.0
        }
        ListElement {
            xc: 6
            yc: 9.39358257285841
        }
        ListElement {
            xc: 7
            yc: 8.94745635285273
        }
        ListElement {
            xc: 8
            yc: 9.16784953867992
        }
        ListElement {
            xc: 9
            yc: 10.7719475277497
        }
        ListElement {
            xc: 10
            yc: 9.3165821539393
        }
        ListElement {
            xc: 11
            yc: 8.97641112047178
        }
        ListElement {
            xc: 12
            yc: 9.33869115958668
        }

    }

    Plot {
        id: plot
        anchors.top: statisticsHeader.bottom
        width: parent.width
        height: 200
//        data: testData
        data: statisticsModel
    }

    ButtonRow {
        id: buttonRow
        anchors.top: plot.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        Button {
            text: "Previous"
            width: parent.width/2
            onClicked: changeYear(-1)
        }
        Button {
            text: "Next"
            width: parent.width/2
            onClicked: changeYear(+1)
        }
    }

}
