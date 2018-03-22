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
            //console.log("debug "+ gps.ready +"a "+ gps.valid +"b "+ gps.threshold +"c "+ sendgood +"d "+ gps.changedbig);
            if(gps.ready && gps.valid && gps.threshold>0 && gps.threshold<40 && (sendgood===0 || gps.changedbig) ){
                //console.log("Gps okay,sending Data");
                       if(sendData(gps.position) === true) {
                        positiontimer.interval = intervald;
                        sendgood++;

                    }
                        else{
                        positiontimer.interval = positiontimer.interval *2;
                        sendbad++;
                    }
            }
            else ignored++;

            positiontimer.restart();
            done=false;
        }
    }
