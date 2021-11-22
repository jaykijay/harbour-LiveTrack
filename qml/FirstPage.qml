import QtQuick 2.6
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
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("LiveTracker")
            }
            DetailItem2 {
                label: qsTr("Latitude")
                value: { return gps.position.coordinate.latitude.toPrecision(9) }
            }
            DetailItem2 {
                label: qsTr("Longitude")
                value: { return gps.position.coordinate.longitude.toPrecision(9) }
            }
            DetailItem {
                label: qsTr("Accuracy")
                value:gps.position.horizontalAccuracy.toPrecision(4) + qsTr("m")
            }
            DetailItem {
                label: qsTr("Height")
                value: { gps.position.coordinate.altitude.toPrecision(4) + qsTr("m")}
            }
            DetailItem {
                label: qsTr("Speed")
                value: {if (gps.position.speedValid) Math.round(gps.position.speed.toPrecision(4) * 3.6)+qsTr("km/h")
                        else "0"}
            }
            Separator {
                width: parent.width
                color: Theme.primaryColor
                horizontalAlignment: Qt.AlignHCenter
            }
            Row {
                id: iconButtons
                spacing: Theme.paddingLarge * 2
                anchors.horizontalCenter: parent.horizontalCenter
                Column{
                    anchors.top: parent.top
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Theme.fontSizeSmall
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.highlightColor
                        text: qsTr("Accuracy")
                    }
                    IconButton {
                        id: gpsbutton
                        anchors.horizontalCenter: parent.horizontalCenter
                        icon.source: {
                            if ( gps.position.horizontalAccuracy > 0 && gps.position.horizontalAccuracy < 60 ) {
                              "image://theme/icon-m-gps?" + Theme.highlightColor
                            } else if ( gps.position.horizontalAccuracy > 0 && gps.position.horizontalAccuracy < 120 ) {
                              "image://theme/icon-m-gps?" + Theme.PresenceBusy
                            } else {
                              "image://theme/icon-m-gps?" + Theme.errorColor
                            }
                        }
                        enabled: true
                        opacity: ( gps.position.horizontalAccuracy > 0 && gps.position.horizontalAccuracy < 120 ) ? 1.0 : 0.5
                        Behavior on opacity { FadeAnimation {} }
                        TouchBlocker { anchors.fill: parent }
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Theme.fontSizeTiny
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.secondaryColor
                        text: {
                            if ( gps.position.horizontalAccuracy > 0 && gps.position.horizontalAccuracy < 60 ) {
                              qsTr("ok")
                            } else if ( gps.position.horizontalAccuracy > 0 && gps.position.horizontalAccuracy < 120 ) {
                              qsTr("low")
                            } else {
                              qsTr("bad")
                            }
                        }
                    }
                }
                Column {
                    anchors.top: parent.top
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Theme.fontSizeSmall
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.highlightColor
                        text: qsTr("Tracking")
                    }
                    IconButton {
                        id: play
                        anchors.horizontalCenter: parent.horizontalCenter
                        icon.source: positiontimer.running ? "image://theme/icon-m-pause?" + Theme.highlightColor : "image://theme/icon-m-play?" + Theme.secondaryColor
                        onClicked: {
                          playClicked();
                        }
                        enabled: true
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Theme.fontSizeTiny
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.secondaryColor
                        text: positiontimer.running ?  qsTr("enabled") : qsTr("paused")
                    }
                }
                Column {
                    anchors.top: parent.top
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Theme.fontSizeSmall
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.highlightColor
                        text: qsTr("Upload")
                    }
                    IconButton {
                       id: sendold
                       icon.source: ( positiontimer.tosend !== 0 ) ? "image://theme/icon-m-cloud-upload?" + Theme.highlightColor : "image://theme/icon-m-cloud-upload?" + Theme.secondaryColor
                       property bool sending
                       onClicked: {
                                   sending = true
                                   for(var i=0;positiondata.positionvar.length >0 && positiondata.positionvar.length > i ;i++){
                                       sendData(i);
                                       positiontimer.tosend = positiondata.positionvar.length;
                                   }
                                   sending = false
                                   }
                       enabled: ( positiontimer.tosend !== 0 )
                       Behavior on enabled { FadeAnimation {} }
                       BusyIndicator {
                         id: upbusy
                         anchors.centerIn: parent
                         size: BusyIndicatorSize.Small
                         running: ( sendold.sending && page.status === PageStatus.Active )
                       }
                   }
                   Label {
                       anchors.horizontalCenter: parent.horizontalCenter
                       font.pixelSize: Theme.fontSizeTiny
                       horizontalAlignment: Text.AlignHCenter
                       color: Theme.secondaryColor
                       //text: positiontimer.running ?  qsTr("sending") : positiontimer.tosend
                       text: sendold.sending ? qsTr("sending") : positiontimer.tosend + " / " + sendgood
                   }
                }
                Column {
                    anchors.top: parent.top
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Theme.fontSizeSmall
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.highlightColor
                        text: qsTr("Datapoints")
                    }
                    Row {
                      Column {
                        Label {
                            horizontalAlignment: Text.AlignRight
                            color: Theme.secondaryHighlightColor
                            font.pixelSize: Theme.fontSizeTiny
                            text: qsTr("Sent") + ": "
                        }
                        Label {
                            horizontalAlignment: Text.AlignRight
                            color: Theme.secondaryHighlightColor
                            font.pixelSize: Theme.fontSizeTiny
                            text: qsTr("Saved") + ": "
                        }
                        Label {
                            horizontalAlignment: Text.AlignRight
                            color: Theme.secondaryHighlightColor
                            font.pixelSize: Theme.fontSizeTiny
                            text: qsTr("Ignored") + ": "
                        }
                        Label {
                            horizontalAlignment: Text.AlignRight
                            color: Theme.secondaryHighlightColor
                            font.pixelSize: Theme.fontSizeTiny
                            text: qsTr("Interval") + ": "
                        }
                      }
                      Column {
                        Label {
                            horizontalAlignment: Text.AlignRight
                            color: Theme.highlightColor
                            font.pixelSize: Theme.fontSizeTiny
                            text: sendgood
                        }
                        Label {
                            horizontalAlignment: Text.AlignRight
                            color: Theme.highlightColor
                            font.pixelSize: Theme.fontSizeTiny
                            text: positiontimer.tosend
                        }
                        Label {
                            horizontalAlignment: Text.AlignRight
                            color: Theme.highlightColor
                            font.pixelSize: Theme.fontSizeTiny
                            text: positiontimer.ignored
                        }
                        Label {
                            horizontalAlignment: Text.AlignRight
                            color: Theme.highlightColor
                            font.pixelSize: Theme.fontSizeTiny
                            text: (positiontimer.interval/1000 +"s")

                        }
                      }
                  }
                }
            }
        }
    }
    function playClicked() {
        if(!(positiontimer.running)){
            positiontimer.start();
            gps.start();
        }
        else{
           positiontimer.stop();
           gps.stop();
        }
    }

    Component.onCompleted: {
        if(livetracksettings.getBool("autostart")) {
            playClicked();
        }
    }
}
