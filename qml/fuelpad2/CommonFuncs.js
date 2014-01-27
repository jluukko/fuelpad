// Can't use .pragma library (=stateless) since Component.Ready
// does not exist for stateless library

//.pragma library

var component;

function loadComponent(file, parent, properties) {
    console.debug("loadComponent starting");
    component = Qt.createComponent(file)
    if (component.status == Component.Ready) {
        var comp = finishCreation(parent, properties);
        console.debug("loadComponent returning");
        return comp;
    }
    else {
        component.statusChanged.connect(finishCreation);
    }
}

function finishCreation(parent, properties) {
     if (component.status == Component.Ready) {
         var comp = component.createObject(parent, properties);
         console.debug("Instantiating component");
         if (comp == null) {
             // Error Handling
             console.log("Error creating object");
         }
         return comp;
     } else if (component.status == Component.Error) {
         // Error Handling
         console.log("Error loading component:", component.errorString());
     }
 }
