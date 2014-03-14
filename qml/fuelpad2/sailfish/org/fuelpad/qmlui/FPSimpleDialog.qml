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
import Sailfish.Silica 1.0

// Stub implementation
Item {
    id: pageRoot

    default property alias content: content.children
    property alias title: title.children
    property alias buttons: buttons.children

    signal accepted
    signal rejected

    function open() {
        // Nothing to do: only for compatibility with Harmattan Dialog
    }

    function accept() {
        close();
        accecpted();
    }

    function reject() {
        close();
        rejected();
    }

    function close() {
        pageStack.pop()
    }

    Item {
        id:stuff

        Item {
            id:title
            anchors.bottom: content.top
        }

        Item {
            id: content
            anchors.horizontalCenter: stuff.horizontalCenter
            anchors.verticalCenter: stuff.verticalCenter
        }

        Item {
            id:buttons
            width: parent.width
            anchors.top: content.bottom
        }

    }

}
