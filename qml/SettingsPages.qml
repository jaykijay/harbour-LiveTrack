import QtQuick 2.6
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
        onTextChanged: {
            //console.log("Got text: " + text);
            // define regexp:
            //  * what we want is inside ()
            //  * everything before the first ?:      [^?]*
            //  * and the / before that:              .*\/[*?]*
            //  * match all the rest after the ? too: .*
            var re = /(.*\/)[^?]*.*/
            // $1 contains the match between the () above
            var newtext = text.replace(re,'$1');
            //console.log("Transformed text: " + newtext);
            livetracksettings.set("URL",newtext)
        }
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
    ComboBox {
      anchors.horizontalCenter: parent.horizontalCenter
      label: qsTr("Timer Interval")
      description: "Tap to switch"
      menu: ContextMenu {
        width:parent.width - Theme.paddingLarge * 2
        MenuItem { text: "1s" }
        MenuItem { text: "3s" }
        MenuItem { text: "5s" }
        MenuItem { text: "10s" }
        MenuItem { text: "15s" }
        MenuItem { text: "30s" }
        MenuItem { text: "45s" }
        MenuItem { text: "60s" }
      }
      onValueChanged: {
        var val = parseInt(text.replace("s", "000"))
        positiontimer.intervald=val; livetracksettings.set("intervald",val)
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

