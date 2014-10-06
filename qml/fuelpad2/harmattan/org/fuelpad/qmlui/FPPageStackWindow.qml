import QtQuick 1.1
import com.nokia.meego 1.1

PageStackWindow {
    id: page
    property alias mainMenuItems: menuBarItems.children

    Item {
        id: menuBarItems
    }
}
