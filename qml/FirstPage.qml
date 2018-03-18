/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.3
import '.'


Page {
    id: page
    property bool timerdone : true;
    property Position positionsave: []




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
                text: qsTr("longitude:")+gps.position.coordinate.longitude
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label {
                id: latitudelabel
                x: Theme.horizontalPageMargin
                y: longitudelabel.AlignBottom
                text: qsTr("latitude:")+gps.position.coordinate.latitude
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label {
                id: altitude
                x: Theme.horizontalPageMargin
                y: latitudelabel.AlignBottom
                text: qsTr("Höhe:")+gps.position.coordinate.altitude+qsTr("m")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label {
                id: speed
                x: Theme.horizontalPageMargin
                y: altitude.AlignBottom
                text:  qsTr("Geschwindigkeit:")+gps.speed+qsTr("m/s")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
                visible: true
            }

            Button {
                id: start
                x: Theme.horizontalPageMargin
                y: speed.AlignBottom
                text:  qsTr("Start this shit")
                color: Theme.secondaryHighlightColor
                visible: true
                onClicked:{
                    positiontimer.start();

                }

            }
        }
    }
    Component.onCompleted: gps.start();   //start timer,todo




    PositionSource {
        id: gps
        // If application is no longer active, turn positioning off immediately
        // if we already have a lock, otherwise keep trying for a couple minutes
        // and give up if we still don't gain that lock.
        active: true
        property var coordHistory: []
        property bool ready: false
        property var timeActivate:  Date.now()
        property var timePosition:  Date.now()

        onActiveChanged: {
            // Keep track of when positioning was (re)activated.
            if (gps.active) gps.timeActivate = Date.now();
        }

        onPositionChanged: {
            // Calculate direction as a median of individual direction values
            // calculated after significant changes in position. This should be
            // more stable than any direct value and usable with map.autoRotate.
            gps.ready = gps.position.latitudeValid &&
                gps.position.longitudeValid &&
                gps.position.coordinate.latitude &&
                gps.position.coordinate.longitude;
            gps.timePosition = Date.now();
            var threshold = gps.position.horizontalAccuracy || 15;
            if (threshold < 0 || threshold > 40) return;
            var coord = gps.position.coordinate;
            if (gps.coordHistory.length === 0)
                gps.coordHistory.push(QtPositioning.coordinate(
                    coord.latitude, coord.longitude));
            var coordPrev = gps.coordHistory[gps.coordHistory.length-1];
            if (coordPrev.distanceTo(coord) > threshold) {
                gps.coordHistory.push(QtPositioning.coordinate(
                    coord.latitude, coord.longitude));
                gps.coordHistory = gps.coordHistory.slice(-3); }



            if (positiontimer.done){
            positiontimer.restart();
            positiontimer.done=false;
                backend.sendData()
               }

        }

    }




    QtObject {
        id:backend

     function sendData(Position) {
         console.log("Sending location"+(new Date).getTime());
         var http = new XMLHttpRequest()
         var url = vars.url+"?id="+ vars.id +"&lat=" + Position.coordinate.latitude +"&lon="+Position.coordinate.longitude+"&timestamp="+this.timestamp+"&speed="+this.speed;
         http.open("Get", url, true);
         http.addEventListener('load', function(http) {
            if (http.status === 200) {
               console.log(http.responseText);
           //     positiontimer...;
            }
            else {
               console.warn(http.statusText, http.responseText);
            }
         });
         http.send();
     //    return
    }

    }

    Timer {
        id: positiontimer
        interval: 1; running: true; repeat: false //1ms for debug
        onTriggered: timerdone = true
    }


}
