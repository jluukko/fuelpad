import QtQuick 2.3
import QtQuick.Controls 1.2

Item {
    default property alias flickableItem: flickable.children

    Item {
        id: flickable
    }
}
