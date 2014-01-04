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
    id: settingsPage
    tools: commonTools

    function setMainUnit(index) {
        var check = individualUnit.checked
        applicationData.setMainUnit(index, check)
    }

    // workaround https://bugreports.qt-project.org/browse/QTBUG-11403
    Text { text: qsTr(name) }
    ListModel {
        id: unitModel
        ListElement { name: QT_TR_NOOP("SI") }
        ListElement { name: QT_TR_NOOP("US") }
        ListElement { name: QT_TR_NOOP("Imperial")}
    }

    PageHeader {
        id: applicationHeader
        title: "Settings"
        titleForegroundColor: UIConstants.COLOR_PAGEHEADER_FOREGROUND
        titleBackgroundColor: UIConstants.COLOR_PAGEHEADER_BACKGROUND
    }

    Column {
        anchors.top: applicationHeader.bottom
        anchors.topMargin: UIConstants.PADDING_LARGE
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: UIConstants.PADDING_MEDIUM

        // todo Get selectedIndex from global settings
        TouchSelector {
            buttonText: qsTr("Unit system")
            titleText: qsTr("Select unit system")
            selectedIndex: 0
            model: unitModel
            onSelected: setMainUnit(selectedIndex)
        }

        Row {

            Label {
                text: "Select units individually"
            }

            // todo Get checked from global settings
            Switch {
                id: individualUnit
                checked: false
            }
        }

        TouchSelector {
            id: lengthSelector
            visible: individualUnit.checked
            buttonText: qsTr("Unit system for length")
            titleText: qsTr("Select unit system")
            selectedIndex: 0
            model: unitModel
            onSelected: applicationData.setLengthUnit(selectedIndex)
        }

        TouchSelector {
            visible: individualUnit.checked
            buttonText: qsTr("Unit system for volume")
            titleText: qsTr("Select unit system")
            selectedIndex: 0
            model: unitModel
            onSelected: applicationData.setVolumeUnit(selectedIndex)
        }

        TouchSelector {
            visible: individualUnit.checked
            buttonText: qsTr("Unit system for mass")
            titleText: qsTr("Select unit system")
            selectedIndex: 0
            model: unitModel
            onSelected: applicationData.setMassUnit(selectedIndex)
        }

        TouchSelector {
            visible: individualUnit.checked
            buttonText: qsTr("Unit system for consumption")
            titleText: qsTr("Select unit system")
            selectedIndex: 0
            model: unitModel
            onSelected: applicationData.setConsumeUnit(selectedIndex)
        }

    }


}
