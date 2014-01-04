//.pragma library

function getLengthUnit() {
    var unit = applicationData.getLengthUnit();
    var unitText;
    switch (unit) {
    case 0:
        unitText = qsTr("km");
        break;
    case 1:
    case 2:
        unitText = qsTr("miles");
        break;
    default:
        unitText = ""
        break;
    }
    return unitText
}

function getVolumeUnit() {
    var unit = applicationData.getVolumeUnit()
    var unitText;
    switch (unit) {
    case 0:
        unitText = qsTr("l");
        break;
    case 1:
    case 2:
        unitText = qsTr("gal.");
        break;
    default:
        unitText = ""
        break;
    }
    return unitText
}

function getConsumeUnit() {
    var unit = applicationData.getConsumeUnit()
    var unitText;
    switch (unit) {
    case 0:
        unitText = qsTr("l/100 km");
        break;
    case 1:
    case 2:
        unitText = qsTr("mpg");
        break;
    default:
        unitText = ""
        break;
    }
    return unitText
}
