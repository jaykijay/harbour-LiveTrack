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
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
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
            spacing: Theme.paddingMedium
            PageHeader {
                title: qsTr("LiveTracker")
            }
            DetailItem2 {
                label: qsTr("Longitude")
                value: gps.position.coordinate.longitude
            }
            DetailItem2 {
                label: qsTr("Latitude")
                value: gps.position.coordinate.latitude
            }
            DetailItem2 {
                label: qsTr("Accuracy")
                value:gps.position.horizontalAccuracy+qsTr("m")
            }
            DetailItem2 {
                label: qsTr("Height")
                value: {if (gps.position.altitudeValid) gps.position.coordinate.altitude+qsTr("m")
                        else qsTr("fetching")}
            }
            DetailItem2 {
                label: qsTr("Speed")
                value: {if (gps.position.speedValid) Math.round(gps.position.speed * 3.6)+qsTr("km/h")
                        else "0"}
            }
            Row {
                id: iconButtons
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                IconButton {
                    id: play
                    icon.source:
                        if(!(positiontimer.running)){
                            "image://theme/icon-l-play"
                        }
                        else{
                            "image://theme/icon-l-pause"
                        }
                    onClicked:
                        if(!(positiontimer.running)){
                            positiontimer.start();
                            gps.start();
                        }
                        else{
                           positiontimer.stop();
                            gps.stop();
                        }

                    enabled: true
                }
                IconButton {
                    id: sendold
                    icon.source: "image://theme/icon-l-clear"
                    onClicked: {  for(var i=0;positiondata.positionvar.length >0 && positiondata.positionvar.length > i ;i++){
                                    sendData(i);
                                }
                                }
                    enabled: true

                }
            }
            Separator {
                width: parent.width
                color: Theme.primaryColor
                horizontalAlignment: Qt.AlignHCenter
            }
                PageHeader {
                   id:header
                   title: qsTr("Statistics")
                }

                DetailItem2 {
                    label: qsTr("Send ok")
                    value: sendgood
                }
                DetailItem2 {
                    label: qsTr("To send")
                    value: positiontimer.tosend
                }
                DetailItem2 {
                    label: qsTr("Ignored")
                    value: positiontimer.ignored
                }
                DetailItem2 {
                    label: qsTr("Timer Interval")
                    value:  (positiontimer.interval/1000)+qsTr(" sec")
                }


        }
    }
}
