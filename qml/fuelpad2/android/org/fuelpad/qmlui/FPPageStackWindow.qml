import QtQuick 2.3
import QtQuick.Controls 1.2

ApplicationWindow {
    property bool showStatusBar
    property bool showToolBar
    property variant tools
    property variant mainMenuItems
    property alias pageStack: stack
    property alias initialPage: stack.initialItem

    Item {
        id: contentArea
        anchors { top: parent.top; left: parent.left; right: parent.right; bottom: parent.bottom; }

        StackView {
            id: stack
            anchors.fill: parent
        }

    }

    menuBar: mainMenuItems

    Component.onCompleted: {
        if (initialPage) pageStack.push(initialPage)
    }
}
