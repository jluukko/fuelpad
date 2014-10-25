import QtQuick 2.3
import QtQuick.Controls 1.2

import "."
import "FPApplicationTheme.js" as AppTheme

Rectangle {
    id: pageHeader
    property alias title: title.text

    color: AppTheme.headerColorBackground

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }

    height: AppTheme.headerHeightPortrait

    FPLabel {
        id: title
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: AppTheme.paddingLarge
            topMargin: -AppTheme.paddingLarge
        }
        font.pixelSize: AppTheme.fontSizeExtraLarge
        color: AppTheme.headerColorForeground
    }
}
