import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    id: about
    allowedOrientations: Orientation.All

    SilicaFlickable {
        id: aboutContainer
        contentHeight: column.height
        anchors.fill: parent

        Column {
            id: column
            width: about.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("About Livetrack")
            }


            Label {
                text: "LiveTrack 0.10.0"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Label {
                text: qsTr("By Jahn Kohlhas")
                font.pixelSize: Theme.fontSizeSmall
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
            }


            Text {
                text: "<a href=\"mailto:jayki@kohlhas.info\">" + qsTr("Send E-Mail") + "</a>"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                font.pixelSize: Theme.fontSizeSmall
                linkColor: Theme.highlightColor

                onLinkActivated: Qt.openUrlExternally("mailto:jayki@kohlhas.info")
            }

            Separator {
                width: parent.width
                color: Theme.primaryColor
                horizontalAlignment: Qt.AlignHCenter
            }

            Label {
                text: qsTr("Licensed under GNU GPLv3")
                font.pixelSize: Theme.fontSizeSmall
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Text {
                text: "<a href=\"https://github.com/jaykijay/harbour-LiveTrack\">" + qsTr("Source on GitHub") + "</a>"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                font.pixelSize: Theme.fontSizeSmall
                linkColor: Theme.highlightColor

                onLinkActivated: Qt.openUrlExternally("https://github.com/jaykijay/harbour-LiveTrack")
            }


            SectionHeader {
                text: qsTr("Credits")
            }


            Label {
                x: Theme.horizontalPageMargin
                width: parent.width  - ( 2 * Theme.horizontalPageMargin )
                text: qsTr("This project uses code from other Developers, which is either released under GNU GPLv3 or GNU GPLv2. Namely Source from Whogo maps by Otsaloma and About Page from Piepmatz by Sebastian Wolf (Ygriega). \n
Icon was made by goncharov(@gregguh)\n
Thanks to: \n
@ajftw_ani ,my love -> for testing \n
my Brother -> for testing \n
nephros for his good PRs \n
otsaloma,ygriega for their really good code \n
@DylanVanAssche for helping me with some bugs.")
                font.pixelSize: Theme.fontSizeExtraSmall
                wrapMode: Text.Wrap
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
            }


            Label {
                id: separatorLabel
                x: Theme.horizontalPageMargin
                width: parent.width  - ( 2 * Theme.horizontalPageMargin )
                font.pixelSize: Theme.fontSizeExtraSmall
                wrapMode: Text.Wrap
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
            }

            VerticalScrollDecorator {}
        }

    }
}
