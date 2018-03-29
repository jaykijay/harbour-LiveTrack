import QtQuick 2.0
import "."

    Timer {
        property bool done: false
        property int sendgood:0;
        property int sendbad:0;
        property int ignored:0;
        property int intervald:livetracksettings.get("intervald");

        id: positiontimer
        interval: intervald; running: false; repeat: false
        onTriggered:{
            console.log(positiondata.positionvar.length)
            done=true;
            if(gps.ready && gps.valid && gps.threshold>0 && gps.threshold<60 && (sendgood<1500 || gps.changedbig) ){ //sendgood===0
                       if(sendData(gps.position,(new Date).getTime()) === true) {
                        positiontimer.interval = intervald;
                        sendgood++;
                            while(positiondata.positionvar.length >0){
                                var positiontemp=positiondata.positionvar.pop();
                                var timestamptemp=positiondata.timestampvar.pop();
                                if(sendData(positiontemp,timestamptemp) === true){
                                   sendgood++;
                                }
                                    else{
                                    positiondata.positionvar.push(positiontemp);
                                    positiondata.timestampvar.push(timestamptemp);
                                    sendbad++;
                                }
                            }
                   }
                        else{
                           //array length should be checked before pushing, to be sure memory does not run out of space:
                           //if(positiondata.positionvar.length < xxxx) {...
                           positiondata.positionvar.push(gps.position);
                           positiondata.timestampvar.push((new Date).getTime());
//                           if(positiontimer.interval < 10*positiontimer.intervald) positiontimer.interval = positiontimer.interval *2;  have to check battery and memory usage if keeping high updates even if network is failing..

                        sendbad++;
                    }
            }
            else ignored++;

            positiontimer.restart();
            done=false;
        }
    }
