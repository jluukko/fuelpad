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

import QtQuick 1.1
import org.fuelpad.qmlui 1.0
import "CommonFuncs.js" as Funcs

FPPage {
    id: settingsPage
    tools: commonTools

    function setMainUnit(index) {
        var check = applicationData.getIndividualUnit()
        applicationData.setMainUnit(index, check)
    }

    function setIndividualUnit(checked) {
        var mainUnit = mainUnitSelector.selectedIndex
        applicationData.setMainUnit(mainUnit, checked)
    }

    FPApplicationTheme {
        id: appTheme
    }

    // workaround https://bugreports.qt-project.org/browse/QTBUG-11403
    Text { text: qsTr(name) }
    ListModel {
        id: unitModel
        ListElement { name: QT_TR_NOOP("SI") }
        ListElement { name: QT_TR_NOOP("US") }
        ListElement { name: QT_TR_NOOP("Imperial")}
    }

    FPPageHeader {
        id: applicationHeader
        title: "Settings"
    }

    Column {
        anchors.top: applicationHeader.bottom
        anchors.topMargin: appTheme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: appTheme.paddingMedium

        TouchSelector {
            id: mainUnitSelector
            buttonText: qsTr("Unit system")
            titleText: qsTr("Select unit system")
            selectedIndex: applicationData.getMainUnit()
            model: unitModel
            onSelected: setMainUnit(selectedIndex)
        }

        Row {

            FPLabel {
                text: "Select units individually"
            }

            FPSwitch {
                id: individualUnit
                checked: applicationData.getIndividualUnit()
                onCheckedChanged: setIndividualUnit(checked)
            }
        }

        TouchSelector {
            id: lengthSelector
            visible: individualUnit.checked
            buttonText: qsTr("Unit system for length")
            titleText: qsTr("Select unit system")
            selectedIndex: applicationData.getLengthUnit()
            model: unitModel
            onSelected: applicationData.setLengthUnit(selectedIndex)
        }

        TouchSelector {
            visible: individualUnit.checked
            buttonText: qsTr("Unit system for volume")
            titleText: qsTr("Select unit system")
            selectedIndex: applicationData.getVolumeUnit()
            model: unitModel
            onSelected: applicationData.setVolumeUnit(selectedIndex)
        }

        TouchSelector {
            visible: individualUnit.checked
            buttonText: qsTr("Unit system for mass")
            titleText: qsTr("Select unit system")
            selectedIndex: applicationData.getMassUnit()
            model: unitModel
            onSelected: applicationData.setMassUnit(selectedIndex)
        }

        TouchSelector {
            visible: individualUnit.checked
            buttonText: qsTr("Unit system for consumption")
            titleText: qsTr("Select unit system")
            selectedIndex: applicationData.getConsumeUnit()
            model: unitModel
            onSelected: applicationData.setConsumeUnit(selectedIndex)
        }

    }


}
