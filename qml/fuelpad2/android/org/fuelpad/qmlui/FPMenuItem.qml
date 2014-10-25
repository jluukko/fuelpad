import QtQuick 2.3
import QtQuick.Controls 1.2

MenuItem {
    signal clicked

    onTriggered: clicked()
}
