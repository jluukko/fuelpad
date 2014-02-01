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

import QtQuick 1.1
import com.nokia.meego 1.1
import "UIConstants.js" as UIConstants
import "CommonFuncs.js" as Funcs
import "CommonUnits.js" as Units

Page {
    id: mainPage
    tools: commonTools

    PageHeader {
        id: applicationHeader
        title: "Fuelpad"
        titleForegroundColor: UIConstants.COLOR_PAGEHEADER_FOREGROUND
        titleBackgroundColor: UIConstants.COLOR_PAGEHEADER_BACKGROUND
    }

    ListView {
        id: carListView
        model: carModel
        delegate: carDelegate
        anchors {
            top: applicationHeader.bottom
            left: parent.left
            right: parent.right
            bottom: button1.top
            leftMargin: UIConstants.DEFAULT_MARGIN
            rightMargin: UIConstants.DEFAULT_MARGIN
        }
        clip: true
    }

    ScrollDecorator {
        flickableItem: carListView
    }

    function loadFuelViewPage(dbid) {
        applicationData.setCurrentCar(dbid)
        pageStack.push(Funcs.loadComponent("FuelViewPage.qml",mainPage, {"carId": dbid}))
    }

    Component {
        id: carDelegate
        Rectangle {
            id: carDelegateRec
            width: parent.width
            height: carNameText.height*1.5 + grid.height
            MouseArea {
                width: parent.width
                height: parent.height
                onClicked: loadFuelViewPage(databaseid)
            }
            Image {
                id: subIndicatorArrow
                width: sourceSize.width

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: UIConstants.SCROLLDECORATOR_SHORT_MARGIN
                }

                smooth: true
                source: "image://theme/icon-m-common-drilldown-arrow"
                        + (theme.inverted ? "-inverse" : "");
            }
            Label {
                id: carNameText
                text: mark + " " + carmodel
                platformStyle: MyLabelStyleTitle{}
                font.bold: true
            }
            Grid {
                id: grid
                anchors {
                    top: carNameText.bottom
                }
                columns: 1

                Row {
                    LabelText {
                        text: qsTr("Overall distance:") + " "
                    }
                    ElementText {
                        text: totalkm.toFixed(0) + " " + Units.getLengthUnit()
                    }
                }

                Row {
                    LabelText {
                        text: qsTr("Last month:") + " "
                    }
                    ElementText {
                        text: lastmonthkm.toFixed(0) + " " + Units.getLengthUnit()
                    }
                }

                Row {
                    LabelText {
                        text: qsTr("Last year:") + " "
                    }
                    ElementText {
                        text: lastyearkm.toFixed(0) + " " + Units.getLengthUnit()
                    }
                }
            }
            Rectangle {
                id: itemSeperator
                height: 2
                width: parent.width
                color: UIConstants.COLOR_INVERTED_BACKGROUND
            }
        }
    }

    Button{
        id: button1
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: button4.top
            topMargin: 10
        }
        text: qsTr("Examine service reminders")
        onClicked: pageStack.push(Funcs.loadComponent("RemindersPage.qml",mainPage, {}))
        width: parent.width-50
    }
    Button{
        id: button4
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            topMargin: 10
        }
        text: qsTr("Log driving")
        onClicked: pageStack.push(Funcs.loadComponent("DrivingLogPage.qml",mainPage, {}))
        width: parent.width-50
    }
}
