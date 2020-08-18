import QtQuick 2.0
import Sailfish.Silica 1.0
import "."

Page {
    id: settingspages
    property var textAlignment: undefined
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
        EnterKey.onClicked: idlabel.focus = true
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
        EnterKey.onClicked: intervaldlabel.focus = true
        onTextChanged:
            livetracksettings.set("ID",text)
    }
    TextField {
        id: intervaldlabel
        width: parent.width
        inputMethodHints: Qt.ImhFormattedNumbersOnly
        label: "Update locatation every x seconds"
        text: livetracksettings.getString("intervald")/1000
        placeholderText: label
        horizontalAlignment: textAlignment
        EnterKey.iconSource: "image://theme/icon-m-enter-next"
        EnterKey.onClicked: serverurllabel.focus = true
        onTextChanged: {
            if(text >0.1){
            positiontimer.intervald=text*1000;
            livetracksettings.set("intervald",text*1000)
            }
        }
    }
    TextSwitch {
        id: autostart
        text: "Autostart"
        checked: livetracksettings.getBool("autostart")
        description: "Start tracking automatically when LiveTracker starts"
        onCheckedChanged: {
            livetracksettings.set("autostart",checked)
        }
    }
    Button {
        id: debug
        text: "Debug"
        onClicked: positiontimer.debug = true;
        enabled: !positiontimer.debug
        anchors.horizontalCenter: parent.horizontalCenter

    }
}

}

