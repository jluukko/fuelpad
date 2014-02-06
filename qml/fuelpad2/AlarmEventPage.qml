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

// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import "UIConstants.js" as UIConstants
import "CommonFuncs.js" as Funcs
import "CommonUnits.js" as Units

Page {
    id: alarmEventPage
    tools: alarmEventTools

    property int alarmId: -1
    property string alarmName

    PageHeader {
        id: applicationHeader
//        title: applicationData.getCarMark(-1) + " " + applicationData.getCarModel(-1)
        title: alarmName + " (" + applicationData.getCarMark(-1) + ")"
        titleForegroundColor: UIConstants.COLOR_PAGEHEADER_FOREGROUND
        titleBackgroundColor: UIConstants.COLOR_PAGEHEADER_BACKGROUND
    }

    ListView {
        id: listView
        model: alarmEventModel
        delegate: delegate
        anchors {
            top: applicationHeader.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: UIConstants.DEFAULT_MARGIN
            rightMargin: UIConstants.DEFAULT_MARGIN
        }
        clip: true
    }

    ScrollDecorator {
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
//                    onPressAndHold: Funcs.loadComponent("DeletealarmEventDialog.qml", mainPage,
//                                                        {databaseId: databaseid}).open()
                    onClicked: Funcs.loadComponent("AddAlarmEventDialog.qml",mainPage,
                                                      {"editMode": true,
                                                      "oldId": alarmId,
                                                      "oldRecordId": recordid,
                                                      "oldDate": date,
                                                      "oldKm": km,
                                                      "oldNotes": notes,
                                                      "oldService": service,
                                                      "oldOil": oil,
                                                      "oldTires": tires}
                                                   ).open()
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
                        rightMargin: UIConstants.SCROLLDECORATOR_SHORT_MARGIN
                    }

                    smooth: true
                    source: "image://theme/icon-m-common-drilldown-arrow"
                            + (theme.inverted ? "-inverse" : "");
                }

                Label {
                    id: headerText
                    text: date + ": " + km.toFixed(0) + " " + Units.getLengthUnit()
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
                        spacing: 10
                        visible: (service > 0)? true : false
                        LabelText {
                            id: serviceLabel
                            text: qsTr("Service")
                        }
                        ElementText {
                            text: service.toFixed(2) + " " + applicationData.getCurrencySymbol()
                        }
                    }

                    Row {
                        spacing: 10
                        visible: (oil > 0)? true : false
                        LabelText {
                            id: oilLabel
                            text: qsTr("Oil")
                        }
                        ElementText {
                            text: oil
                        }
                    }

                    Row {
                        spacing: 10
                        visible: (tires > 0)? true : false
                        LabelText {
                            id: tiresLabel
                            text: qsTr("Tires")
                        }
                        ElementText {
                            text: tires
                        }
                    }

                    Row {
                        spacing: 10
                        visible: (notes == "")? false : true
                        LabelText {
                            id: notesLabel
                            text: qsTr("Notes")
                        }
                        ElementText {
                            text: notes
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

    ToolBarLayout {
        id: alarmEventTools
        visible: false
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: { pageStack.pop(); }
        }
        ToolIcon {
            iconId: "toolbar-add"
            onClicked: Funcs.loadComponent("AddAlarmEventDialog.qml",mainPage, {"editMode": false}).open()
        }
    }

}
