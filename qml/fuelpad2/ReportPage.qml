// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

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
import "DialogStatus.js" as DialogStatus

import "CommonFuncs.js" as Funcs
import "CommonUnits.js" as Units

FPPage {
    id: reportPage
    tools: reportTools

    FPApplicationTheme {
        id: appTheme
    }

    FPPageHeader {
        id: applicationHeader
        title: "Statistics: " + applicationData.getCarMark(-1) + " " + applicationData.getCarModel(-1)
    }

    FPToolBarLayout {
        id: reportTools
        visible: false
        FPToolIcon {
            iconId: "toolbar-back"
            onClicked: { pageStack.pop(); }
        }
    }

    FPFlickablePageContent {
        id: content

        width: reportPage.width
        anchors.top: applicationHeader.bottom
        anchors.bottom: parent.bottom

        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            spacing: 10

            ListView {
                id: listView
                model: carStatisticsModel
                delegate: delegate
                anchors {
                    top: applicationHeader.bottom
                    leftMargin: appTheme.paddingLarge
                    rightMargin: appTheme.paddingLarge
                }
                height: content.height
                width: content.width
                clip: true
            }

            FPScrollDecorator {
                flickableItem: listView
            }

            Component {
                id: delegate

                Item {
                    height: yearLabel.height*1.5 + grid.height
                    width: parent.width
                    FPLabel {
                        id: yearLabel
                        text: year
                        platformStyle: MyLabelStyleTitle{}
                        font.bold: true
                    }
                    Grid {
                        id: grid
                        anchors.top: yearLabel.bottom
                        columns: 1

                        Row {
                            spacing: appTheme.paddingSmall
                            LabelText {
                                text: qsTr("Min km")
                            }
                            ElementText {
                                text: minkm
                            }
                        }
                        Row {
                            spacing: appTheme.paddingSmall
                            LabelText {
                                text: qsTr("Max km")
                            }
                            ElementText {
                                text: maxkm
                            }
                        }

                        Rectangle {
                            id: itemSeperator
                            height: 2
                            width: listView.width
                            color: appTheme.separatorColor
                        }
                    }


                }
            }

        }
    }

}
