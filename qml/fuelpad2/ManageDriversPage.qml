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
//import "harmattan/org/fuelpad/qmlui/DialogStatus.js" as DialogStatus
import "DialogStatus.js" as DialogStatus
import "CommonFuncs.js" as Funcs

FPPage {
    id: manageDriversPage
    tools: manageDriversTools

    FPApplicationTheme {
        id: appTheme
    }

    FPPageHeader {
        id: applicationHeader
        title: qsTr("Drivers")
    }

    ListView {
        id: listView
        model: driverModel
        delegate: delegate
        anchors {
            top: applicationHeader.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: appTheme.paddingLarge
            rightMargin: appTheme.paddingLarge
        }
        clip: true
    }

    FPScrollDecorator {
        flickableItem: listView
    }

    Component {
        id: delegate
            Item {
                id: delegateRec
                height: driverNameText.height*1.5 + + grid.height
                width: parent.width
                MouseArea {
                    width: parent.width
                    height: parent.height
                    onPressAndHold: Funcs.loadComponent("DeleteDriverDialog.qml", manageDriversPage,
                                                        {databaseId: databaseid}).open()
                    onClicked: pageStack.push(Funcs.loadComponent("AddDriverDialog.qml",manageDriversPage,
                                                   {editMode: true,
                                                    oldId: databaseid,
                                                    oldFullname: fullname,
                                                    oldNickname: nickname
                                                   }))
                }

                states: [
                    State {
                        name: "selected"
                        when: (databaseid==selectedId)
                        PropertyChanges {target: delegateRec; color: "red"}
                    }
                ]

                Image {
                    id: subIndicatorArrow
                    width: sourceSize.width

                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: appTheme.scrollDecoratorMarginShort
                    }

                    smooth: true
                    source: "image://theme/icon-m-common-drilldown-arrow"
                            + (theme.inverted ? "-inverse" : "");
                }

                FPLabel {
                    id: driverNameText
                    text: nickname
                    platformStyle: MyLabelStyleTitle{}
                    font.bold: true
                }
                Grid {
                    id: grid
                    anchors {
                        top: driverNameText.bottom
                    }

                    columns: 1

                    Row {
                        Text {
                            text: databaseid
                            visible: false
                        }
                    }

                    Row {
                        LabelText {
                            text: qsTr("Full name:") + " "
                        }
                        ElementText {
                            text: fullname
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

    FPToolBarLayout {
        id: manageDriversTools
        visible: false
        FPToolIcon {
            iconId: "toolbar-back"
            onClicked: { pageStack.pop(); }
        }
        FPToolIcon {
            iconId: "toolbar-add"
            onClicked: pageStack.push(Funcs.loadComponent("AddDriverDialog.qml",manageDriversPage, {}))
        }
//        FPToolIcon {
//            platformIconId: "toolbar-view-menu"
//            anchors.right: (parent === undefined) ? undefined : parent.right
//            onClicked: (fuelViewMenu.status === DialogStatus.Closed) ? fuelViewMenu.open() : fuelViewMenu.close()
//        }
    }

}
