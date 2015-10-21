/*
 * This file is part of Fuelpad.
 *
 * Copyright (C) 2007-2012,2014-2015 Julius Luukko <julle.luukko@quicknet.inet.fi>
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
import "CommonUnits.js" as Units

FPDialog {
    id: fuelSortSelectionDialog

    FPApplicationTheme {
        id: appTheme
    }

    width: parent.width

    title: qsTr("Select sort column and order")


    function fuelSortSelectionDialogAccepted() {
        console.log("Sort column selected, index = " + sortColumnSelector.selectedIndex + " order = " + sortOrderSelector.selectedIndex)
        applicationData.setSortColumn(sortColumnSelector.selectedIndex, sortOrderSelector.selectedIndex)
    }

    Flickable {
        id: fuelSortSelectionDialogData
        anchors {
            fill: parent
            leftMargin: appTheme.paddingLarge
            rightMargin: appTheme.paddingLarge
        }
        contentWidth: column.width
        contentHeight: column.height
        flickableDirection: Flickable.VerticalFlick
        clip: true

        // workaround https://bugreports.qt-project.org/browse/QTBUG-11403
        Text { text: qsTr(name) }
        ListModel {
            id: sortColumnModel
            ListElement { name: QT_TR_NOOP("Date") }
            ListElement { name: QT_TR_NOOP("Km") }
            ListElement { name: QT_TR_NOOP("Trip")}
            ListElement { name: QT_TR_NOOP("Fill")}
            ListElement { name: QT_TR_NOOP("Consumption")}
            ListElement { name: QT_TR_NOOP("Price")}
            ListElement { name: QT_TR_NOOP("Price/trip")}
            ListElement { name: QT_TR_NOOP("Price/litre")}
        }

        Text { text: qsTr(name) }
        ListModel {
            id: sortOrderModel
            ListElement { name: QT_TR_NOOP("Ascending") }
            ListElement { name: QT_TR_NOOP("Descending") }
        }

        Column {
            id: column
            spacing: appTheme.paddingMedium
            // Without these anchors the touch selectors can't be touched...
            anchors {
                fill: parent
                leftMargin: appTheme.paddingLarge
                rightMargin: appTheme.paddingLarge
            }

            FPTouchSelector {
                id: sortColumnSelector
                buttonText: qsTr("Sort column")
                titleText: qsTr("Select sort column")
                selectedIndex: applicationData.getFuelSortColumn()
                model: sortColumnModel
//                onSelected: setMainUnit(selectedIndex)
            }

            FPTouchSelector {
                id: sortOrderSelector
                buttonText: qsTr("Sort order")
                titleText: qsTr("Select sort order")
//                selectedIndex: applicationData.getMainUnit()
                selectedIndex: 0
                model: sortOrderModel
//                onSelected: setMainUnit(selectedIndex)
            }
        }
    }
    buttons: FPButtonRow {
        anchors.horizontalCenter: parent.horizontalCenter
        FPButton {
            text: qsTr("Apply")
            onClicked: fuelSortSelectionDialog.accept()
        }
        FPButton {
            text: qsTr("Cancel");
            onClicked: fuelSortSelectionDialog.cancel()
        }
    }

    onAccepted: fuelSortSelectionDialogAccepted()

}
