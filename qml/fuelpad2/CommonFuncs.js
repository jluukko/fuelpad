// Can't use .pragma library (=stateless) since Component.Ready
// does not exist for stateless library

//.pragma library

function loadComponent(file, parent, properties) {
    var component = Qt.createComponent(file)
    if (component.status == Component.Ready) {
        var comp = component.createObject(parent, properties)
        console.debug("Instantiating component")
        return comp
    }
    else {
        console.debug("Error instantiating component")
    }
}
