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

import QtQuick 2.6
import Sailfish.Silica 1.0
import QtPositioning 5.4
import Nemo.DBus 2.0
import "."

ApplicationWindow
{
    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
    PositionSource { id: gps }
    Timer {id: positiontimer}
    Page {id:settingspages;}
    Item{
        id:positiondata
        property var positionvar: [];
    }
    property int sendgood:0;
    readonly property string userAgent: Qt.application.name

    Item {
        id: batteryData
        property var percentage: null
        property var charging: null

        function isValidBatteryPercentage(value) {
            return typeof value === "number" &&
                    value >= 0 && value <= 100 &&
                    Math.floor(value) === value; // Check if integer
        }

        function updateLevel(value) {
            percentage = isValidBatteryPercentage(value) ? value : null;
        }

        function updateState(value) {
            if (value === "charging")
                charging = true;
            else if (value === "discharging" || value === "not_charging" || value === "full")
                charging = false;
            else
                charging = null;
        }

        DBusInterface {
            id: batteryRequest
            bus: DBus.SystemBus
            service: "com.nokia.mce"
            path: "/com/nokia/mce/request"
            iface: "com.nokia.mce.request"
        }

        DBusInterface {
            bus: DBus.SystemBus
            service: "com.nokia.mce"
            path: "/com/nokia/mce/signal"
            iface: "com.nokia.mce.signal"
            signalsEnabled: true

            function battery_level_ind(value) { batteryData.updateLevel(value); }
            function battery_state_ind(value) { batteryData.updateState(value); }
        }

        Component.onCompleted: {
            batteryRequest.typedCall("get_battery_level", [], function(value) {
                batteryData.updateLevel(value);
            });
            batteryRequest.typedCall("get_battery_state", [], function(value) {
                batteryData.updateState(value);
            });
        }
    }

//-----------------------Function-----------------------------//
    property bool state: false;
    function sendData(index) {
        var http = new XMLHttpRequest()
        var url
        if(livetracksettings.getBool("traccar")) {
            url = livetracksettings.getString("URL")+"?id="+livetracksettings.getString("ID")+"&lat=" + positiondata.positionvar[index].positn.latitude +"&lon="+ positiondata.positionvar[index].positn.longitude+"&timestamp="+ positiondata.positionvar[index].timestamp+"&alt="+ positiondata.positionvar[index].alt+"&speed="+ positiondata.positionvar[index].speed+"&acc="+ positiondata.positionvar[index].horizontalAccuracy;
            var point = positiondata.positionvar[index];
            if (batteryData.isValidBatteryPercentage(point.batteryLevel))
                url += "&batt=" + point.batteryLevel;
            if (typeof point.charging === "boolean")
                url += "&charge=" + (point.charging ? "true" : "false");
        }
        else {
            url = livetracksettings.getString("URL")+livetracksettings.getString("ID")+"?lat=" + positiondata.positionvar[index].positn.latitude +"&lon="+ positiondata.positionvar[index].positn.longitude+"&timestamp="+ positiondata.positionvar[index].timestamp+"&alt="+ positiondata.positionvar[index].alt+"&speed="+ positiondata.positionvar[index].speed+"&acc="+ positiondata.positionvar[index].horizontalAccuracy+"&useragent=" + userAgent;
        }
        http.open("Get", url, true); //true=asynchronus,false=synchronus
        http.onreadystatechange = function() {
          if (http.readyState === XMLHttpRequest.DONE) {
           if (http.status === 200) {
                     positiondata.positionvar.splice(index, 1);
               sendgood++;
           }
           else {
                positiondata.positionvar[index].dirty=false;
                }
            }
        };
        http.send();
       return true;
}
//------------------------------------------------------------//

}

