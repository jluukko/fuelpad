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
import org.fuelpad.qmlui 1.0
//import "harmattan/org/fuelpad/qmlui/DialogStatus.js" as DialogStatus
import "DialogStatus.js" as DialogStatus
import "CommonFuncs.js" as Funcs

FPPageStackWindow {
    id: appWindow

    initialPage: Component { MainPage{} }
    showStatusBar: false
    showToolBar: true

    function loadPreviousPage() {
        pageStack.pop();
    }

    function loadSettingsPage() {
        pageStack.push(Funcs.loadComponent("SettingsPage.qml",parent, {}));
    }

    FPToolBarLayout {
        id: commonTools
        visible: false
        z: 99
        FPToolIcon {
            iconId: "toolbar-back"
            visible: pageStack.depth > 1
            onClicked: { loadPreviousPage() }
        }
        FPToolIcon {
            iconId: "toolbar-settings"
            visible: pageStack.depth == 1
            onClicked: loadSettingsPage()
        }
        FPToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            visible: pageStack.depth == 1
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    FPMenu {
        id: myMenu
        visualParent: pageStack
        FPMenuLayout {
            FPMenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Funcs.loadComponent("SettingsPage.qml",parent, {}))
            }
            FPMenuItem {
                text: qsTr("Manage cars")
                onClicked: pageStack.push(Funcs.loadComponent("ManageCarsPage.qml",parent, {}))
            }
            FPMenuItem {
                text: qsTr("Manage drivers")
                onClicked: pageStack.push(Funcs.loadComponent("ManageDriversPage.qml",parent, {}))
            }
            FPMenuItem {
                text: qsTr("About")
                onClicked: Funcs.loadComponent("AboutDialog.qml",parent, {}).open()
            }
        }
    }

}
