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
import "CommonFuncs.js" as Funcs

PageStackWindow {
    id: appWindow

    initialPage: MainPage{}
    showStatusBar: false
    showToolBar: true

    MainPage {
        id: mainPage
    }

    ToolBarLayout {
        id: commonTools
        visible: false
        z: 99
        ToolIcon {
            iconId: "toolbar-back"
            visible: pageStack.depth > 1
            onClicked: { pageStack.pop(); }
        }
        ToolIcon {
            iconId: "toolbar-settings"
            visible: pageStack.depth == 1
            onClicked: pageStack.push(Funcs.loadComponent("SettingsPage.qml",mainPage, {}))
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Funcs.loadComponent("SettingsPage.qml",mainPage, {}))
            }
            MenuItem {
                text: qsTr("Manage cars")
                onClicked: pageStack.push(Funcs.loadComponent("ManageCarsPage.qml",mainPage, {}))
            }
            MenuItem {
                text: qsTr("Manage drivers")
                onClicked: pageStack.push(Funcs.loadComponent("ManageDriversPage.qml",mainPage, {}))
            }
        }
    }

}
