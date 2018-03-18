import QtQuick 2.0

    Timer {
        property bool done: false
        id: positiontimer
        interval: 1000; running: false; repeat: false //1s
        onTriggered:{
            done=true;
            if(gps.ready && gps.valid && sendData(gps.position)) {
                positiontimer.restart();
                done=false;
                console.log("Timmer triggered, send good");

            }
                else{
                positiontimer.interval = positiontimer.interval *2;
                positiontimer.restart();
                done=false;
                console.log("Timmer triggered, send failed");
            }
        }

    }
