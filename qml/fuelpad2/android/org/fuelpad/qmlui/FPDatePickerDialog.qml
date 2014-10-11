import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

Dialog {
    id: dateDialog

    property string titleText
    property string acceptButtonText
    property string rejectButtonText
    property int minimumYear
    property int maximumYear

    // Output
    property int year
    property int month
    property int day

    title: titleText

    standardButtons: StandardButton.Save | StandardButton.Cancel

    onAccepted: {
        console.log("Saving the date " +
        calendar.selectedDate.toLocaleDateString())
        dateDialog.year = calendar.selectedDate.getFullYear()
        dateDialog.month = calendar.selectedDate.getMonth()
        dateDialog.day = calendar.selectedDate.getDate()
    }

    Calendar {
        id: calendar
        onDoubleClicked: dateDialog.click(StandardButton.Save)
    }

}
