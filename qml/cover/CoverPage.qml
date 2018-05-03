import QtQuick 2.0
import Sailfish.Silica 1.0
import "../"

CoverBackground {
    Column {
        id: column
        width: parent.width
        spacing: Theme.paddingSmall
    PageHeader {
        id: label
        title: qsTr("Livetrack")
    }
    DetailItem {
        label: qsTr("Send ok")
        value: sendgood
    }
    DetailItem {
        label: qsTr("To send")
        value: positiontimer.tosend
    }
    DetailItem {
        label: qsTr("Ignored")
        value: positiontimer.ignored
    }
    }
    CoverActionList {
       id: coverAction
        CoverAction {
                        iconSource: {
                          if (positiontimer.running) return "image://theme/icon-cover-pause"
                            else return "image://theme/icon-cover-play"
                        }
                        onTriggered: {
                            if (positiontimer.running || positiontimer.done) {
                                positiontimer.stop();
                                }
                           else{ positiontimer.start();}
                        }
                   }
                }

              }



//+(positiontimer.tosend) +qsTr(" to send,\n ") + positiontimer.ignored +qsTr(" ignored ")
