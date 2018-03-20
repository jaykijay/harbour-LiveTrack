import QtQuick 2.0

    Timer {
        property bool done: false
        property int sendgood:0;
        property int sendbad:0;
        property int ignored:0;
        property int intervald:livetracksettings.get("intervald");

        id: positiontimer
        interval: intervald; running: false; repeat: false //1s
        onTriggered:{
            done=true;
            if(gps.ready && gps.valid){
                       if(sendData(gps.position) === true) {
                        positiontimer.interval = intervald;
                        positiontimer.restart();
                        done=false;
                        sendgood++;

                    }
                        else{
                        positiontimer.interval = positiontimer.interval *2;
                        positiontimer.restart();
                        done=false;
                        sendbad++;
                    }
            }
            else
                ignored++;
        }
    }
