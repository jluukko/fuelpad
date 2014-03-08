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
import "CommonUnits.js" as Units

FPPage {
    id: alarmTypePage
    tools: alarmTypeTools

    property int carId: -1

    function loadAlarmEventPage(dbid, alarmname) {
        applicationData.addAllRecordsToAlarmEventModel(dbid);
        pageStack.push(Funcs.loadComponent("AlarmEventPage.qml",mainPage, {"alarmId": dbid, "alarmName": alarmname}));
    }

    FPPageHeader {
        id: applicationHeader
        title: applicationData.getCarMark(-1) + " " + applicationData.getCarModel(-1)
    }

    ListView {
        id: listView
        model: alarmTypeModel
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
            Rectangle {
                id: delegateRec
                height: headerText.height*1.5 + + grid.height
                width: parent.width
                MouseArea {
                    width: parent.width
                    height: parent.height
//                    onPressAndHold: Funcs.loadComponent("DeleteAlarmTypeDialog.qml", mainPage,
//                                                        {databaseId: databaseid}).open()
                    onClicked: loadAlarmEventPage(databaseid, description)
                }

//                states: [
//                    State {
//                        name: "selected"
//                        when: (databaseid==selectedId)
//                        PropertyChanges {target: delegateRec; color: "red"}
//                    }
//                ]

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
                    id: headerText
                    text: description
                    platformStyle: MyLabelStyleTitle{}
                    font.bold: true
                }
                Grid {
                    id: grid
                    anchors {
                        top: headerText.bottom
                    }

                    columns: 1

                    Row {
                        Text {
                            text: databaseid
                            visible: false
                        }

                    }

                    Row {
                        visible: kmlimit > 0
                        spacing: 10
                        LabelText {
                            id: kmlimitLabel
                            text: applicationData.getLengthUnit() == 0 ? qsTr("Km limit") : qsTr("Miles limit")
                        }
                        ElementText {
                            text: kmlimit.toFixed(0) + " " + Units.getLengthUnit()
                        }
                    }

                    Row {
                        visible: timelimit > 0
                        spacing: 10
                        LabelText {
                            id: timelimitLabel
                            text: qsTr("Time limit")
                        }
                        ElementText {
                            text: timelimit.toFixed(0) + " " + qsTr("months")
                        }
                    }

                    Row {
                        spacing: 10
                        LabelText {
                            id: lastkmLabel
                            text: applicationData.getLengthUnit() == 0 ? qsTr("Last km") : qsTr("Last miles")
                        }
                        ElementText {
                            text: lastkm.toFixed(0) + " " + Units.getLengthUnit()
                        }
                    }

                    Row {
                        spacing: 10
                        LabelText {
                            id: lastdateLabel
                            text: qsTr("Last date")
                        }
                        ElementText {
                            text: lastdate
                        }
                    }

                    Row {
                        spacing: 10
                        LabelText {
                            id: nextkmLabel
                            text: applicationData.getLengthUnit() == 0 ? qsTr("Next km") : qsTr("Next miles")
                        }
                        ElementText {
                            text: nextkm.toFixed(0) + " " + Units.getLengthUnit()
                        }
                    }

                    Row {
                        spacing: 10
                        LabelText {
                            id: nextdateLabel
                            text: qsTr("Next date")
                        }
                        ElementText {
                            text: nextdate
                        }
                    }

            }
            Rectangle {
                id: itemSeperator
                height: 2
                width: parent.width
                color: appTheme.separatorColor
            }

        }
    }

    FPToolBarLayout {
        id: alarmTypeTools
        visible: false
        FPToolIcon {
            iconId: "toolbar-back"
            onClicked: { pageStack.pop(); }
        }
    }

}
