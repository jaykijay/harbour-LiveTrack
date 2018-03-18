import QtQuick 2.0
import Sailfish.Silica 1.0
import '.'

Page {

    id: settingspages
    property var textAlignment: undefined

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    Column {
        id: column

        width: settingspages.width
        spacing: Theme.paddingLarge
        PageHeader {
            title: qsTr("Settings")
        }

    TextField {
        id: serverurllabel
        focus: true
        text: livetracksettings.getString("URL")
        label: "Serverurl"
        placeholderText: label
        width: parent.width
        horizontalAlignment: textAlignment
        EnterKey.iconSource: "image://theme/icon-m-enter-next"
        onTextChanged:
            livetracksettings.set("URL",text)
    }
    TextField {
        id:idlabel
        label: "ID"
        text: livetracksettings.getString("ID")
        placeholderText: label
        width: parent.width
        horizontalAlignment: textAlignment
        EnterKey.iconSource: "image://theme/icon-m-enter-next"
        onTextChanged:
            livetracksettings.set("ID",text)

    }
}
}

