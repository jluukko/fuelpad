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
import org.fuelpad.components 1.0
import "CommonFuncs.js" as Funcs
import "CommonUnits.js" as Units
import "DialogStatus.js" as DialogStatus

FPPage {
    id: mainPage
    tools: mainTools

    function loadFuelViewPage(dbid) {
        applicationData.setCurrentCar(dbid)
        pageStack.push(Funcs.loadComponent("FuelViewPage.qml",mainPage, {"carId": dbid}))
    }

    FPApplicationTheme {
        id: appTheme
    }

    FPPositionSource {
        id: positionSource
        updateInterval: 1000
        active: false
    }

    FPToolBarLayout {
        id: mainTools
        visible: false
        z: 99
        FPToolIcon {
            iconId: "toolbar-settings"
            onClicked: loadSettingsPage()
        }
        FPToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    FPFlickablePageContent {
        id: content

        width: mainPage.width
        anchors.fill: parent

        contentHeight: contentColumn.height

        FPMenu {
            id: mainMenu
            visualParent: mainPage
            FPMenuLayout {
                FPMenuItem {
                    text: qsTr("Settings")
                    onClicked: pageStack.push(Funcs.loadComponent("SettingsPage.qml",mainPage, {}))
                }
                FPMenuItem {
                    text: qsTr("Manage cars")
                    onClicked: pageStack.push(Funcs.loadComponent("ManageCarsPage.qml",mainPage, {}))
                }
                FPMenuItem {
                    text: qsTr("Manage drivers")
                    onClicked: pageStack.push(Funcs.loadComponent("ManageDriversPage.qml",mainPage, {}))
                }
                FPMenuItem {
                    text: qsTr("About")
                    onClicked: Funcs.loadComponent("AboutDialog.qml",mainPage, {}).open()
                }
            }
        }

        Column {
            id: contentColumn
            spacing: 10

            FPPageHeader {
                id: applicationHeader
                title: "Fuelpad"
            }

            ListView {
                id: carListView
                model: carModel
                delegate: carDelegate
                anchors {
                    top: applicationHeader.bottom
//                    bottom: button1.top
                    leftMargin: appTheme.paddingLarge
                    rightMargin: appTheme.paddingLarge
                }
//                height: mainPage.height-applicationHeader.height-button1.height-button4.height-mainTools.height-3*contentColumn.spacing
//                height: contentHeight-button1.height-button4.height-mainTools.height-3*contentColumn.spacing
                height: content.height-button1.height-button4.height-mainTools.height-3*contentColumn.spacing
                width: content.width
                clip: true
            }

            // If ListView is inside ScrollDecorator, buttons below won't show on Harmattan
//            FPScrollDecorator {
//                flickableItem: carListView
//            }

            Component {
                id: carDelegate
                Item {
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
        //                    rightMargin: UIConstants.SCROLLDECORATOR_SHORT_MARGIN
                            rightMargin: appTheme.scrollDecoratorMarginShort
                        }

                        smooth: true
                        source: "image://theme/icon-m-common-drilldown-arrow"
                                + (theme.inverted ? "-inverse" : "");
                    }
                    FPLabel {
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
        //                    spacing: UIConstants.BUTTON_SPACING
                            spacing: appTheme.buttonSpacing
                            LabelText {
                                text: qsTr("Overall:") + " "
                            }
                            ElementText {
                                text: totalkm.toFixed(0) + " " + Units.getLengthUnit()
                            }
                            ElementText {
                                text: totalconsumption.toFixed(1) + " " + Units.getConsumeUnit()
                            }
                        }

                        Row {
        //                    spacing: UIConstants.BUTTON_SPACING
                            spacing: appTheme.buttonSpacing
                            LabelText {
                                text: qsTr("Last month:") + " "
                            }
                            ElementText {
                                text: lastmonthkm.toFixed(0) + " " + Units.getLengthUnit()
                            }
                            ElementText {
                                text: lastmonthconsumption.toFixed(1) + " " + Units.getConsumeUnit()
                            }
                        }

                        Row {
        //                    spacing: UIConstants.BUTTON_SPACING
                            spacing: appTheme.buttonSpacing
                            LabelText {
                                text: qsTr("Last year:") + " "
                            }
                            ElementText {
                                text: lastyearkm.toFixed(0) + " " + Units.getLengthUnit()
                            }
                            ElementText {
                                text: lastyearconsumption.toFixed(1) + " " + Units.getConsumeUnit()
                            }
                        }
                        Rectangle {
                            id: itemSeperator
                            height: 2
                            width: carListView.width
            //                color: UIConstants.COLOR_INVERTED_BACKGROUND
                            color: appTheme.separatorColor
                        }
                    }
                }
            }

            FPButton {
                id: button1
                anchors {
                    horizontalCenter: parent.horizontalCenter
//                    bottom: button4.top
//                    topMargin: 10
                }
                text: qsTr("Examine service reminders")
                onClicked: pageStack.push(Funcs.loadComponent("RemindersPage.qml",mainPage, {}))
                width: content.width-50
            }
            FPButton {
                id: button4
                anchors {
                    horizontalCenter: parent.horizontalCenter
//                    bottom: content.bottom
//                    topMargin: 10
                }
                text: qsTr("Log driving")
                onClicked: pageStack.push(Funcs.loadComponent("DrivingLogPage.qml",mainPage, {}))
                width: content.width-50
            }
        }

    }
}
