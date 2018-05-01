import QtQuick 2.0
import Sailfish.Silica 1.0
import "../"

CoverBackground {
    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("Livetrack")
    }
    Label {
//        horizontalAlignment:Text.AlignHCenter
//        verticalAlignment:Text.AlignVCenter
        text:  qsTr("Stats:\n ")+sendgood+qsTr(" ok,\n ")+(positiondata.positionvar.length) +qsTr(" to send,\n") + positiontimer.ignored +qsTr(" ignored ")
        color: Theme.secondaryHighlightColor
        font.pixelSize: Theme.fontSizeLarge
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

