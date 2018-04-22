import QtQuick 2.0
import Sailfish.Silica 1.0
import "."

Page {
    id: page
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPages.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("LiveTracker")
            }
            Label {
                id:longitudelabel
                x: Theme.horizontalPageMargin
                text: qsTr("Longitude:")+gps.position.coordinate.longitude
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label {
                id: latitudelabel
                x: Theme.horizontalPageMargin
                y: longitudelabel.AlignBottom
                text: qsTr("Latitude:")+gps.position.coordinate.latitude
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label {
                id: accuracylabel
                x: Theme.horizontalPageMargin
                y: longitudelabel.AlignBottom
                text: qsTr("Accuracy:")+gps.position.horizontalAccuracy+qsTr("m")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label {
                id: altitude
                x: Theme.horizontalPageMargin
                y: accuracylabel.AlignBottom
                text: qsTr("Height:")+gps.position.coordinate.altitude+qsTr("m")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label {
                id: speed
                x: Theme.horizontalPageMargin
                y: altitude.AlignBottom
                text:  qsTr("Speed:")+gps.position.speed.toFixed(2)+qsTr("m/s")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
                visible: true
            }

            Row {
                id: iconButtons
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                y: speed.AlignBottom
                IconButton {
                    id: pause
                    icon.source: "image://theme/icon-l-pause"
                    onClicked:  positiontimer.stop();
                    enabled: (positiontimer.running || positiontimer.done)
                }
                IconButton {
                    id: play
                    icon.source: "image://theme/icon-l-play"
                    onClicked: positiontimer.start();
                    enabled: !(positiontimer.running || positiontimer.done)
                }
                IconButton {
                    id: debug
                    icon.source: "image://theme/icon-l-clear"
                    onClicked: positiontimer.debug = true;
                    enabled: !positiontimer.debug

                }
            }
            Column {
                id: statistics
                spacing: Theme.paddingLarge
                width: parent.width
                x: Theme.horizontalPageMargin
                y: iconButtons.AlignBottom
                visible: true
                Label {
                    text:  qsTr("Statistics: \n")+sendgood+qsTr(" send ok, ")+(positiondata.positionvar.length) +qsTr(" to send, ") + positiontimer.ignored +qsTr(" ignored ")
                    color: Theme.secondaryHighlightColor
                    font.pixelSize: Theme.fontSizeLarge
                }
                Label {
                    text:  qsTr("Timer Intervall: ")+(positiontimer.interval/1000)+qsTr("sec")
                    color: Theme.secondaryHighlightColor
                    font.pixelSize: Theme.fontSizeLarge
                }

            }
        }
    }
}
