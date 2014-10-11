import QtQuick 2.3
import QtQuick.Controls 1.2

ApplicationWindow {
    property bool showStatusBar
    property bool showToolBar
    property variant tools
    property variant mainMenuItems
    property alias pageStack: stack
    property alias initialPage: stack.initialItem

    visible: true
    //@todo: Fix size hardcoding
    width: 640
    height: 480

    Item {
        id: contentArea
        anchors { top: parent.top; left: parent.left; right: parent.right; bottom: parent.bottom; }

        StackView {
            id: stack
            anchors.fill: parent

            focus: true

            Keys.onReleased: {
               if ((event.key === Qt.Key_Back ||
                (event.key === Qt.Key_Left && (event.modifiers & Qt.AltModifier))) &&
                stack.depth > 1) {
                    event.accepted = true
                    stack.pop()
                }
            }
        }

    }

    menuBar: mainMenuItems

    Component.onCompleted: {
        if (initialPage) pageStack.push(initialPage)
    }
}
