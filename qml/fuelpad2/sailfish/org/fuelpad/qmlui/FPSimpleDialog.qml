import QtQuick 2.0
import Sailfish.Silica 1.0

// Stub implementation
Item {
    id: pageRoot

    property alias buttons: buttons.children

    Item {
        id: content
    }

    Item {
        id:buttons
        width: parent.width
        anchors.top: pageRoot.top
    }

}
