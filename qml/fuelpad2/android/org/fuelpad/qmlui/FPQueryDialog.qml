import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

MessageDialog {
    property string titleText
    property string message
    property string acceptButtonText: "Accept"
    property string rejectButtonText: "Reject"

    signal accepted

    // Todo: accept button, reject button
    title: titleText
    text: message
    standardButtons: StandardButton.Yes | StandardButton.No
    onYes: accepted()
}
