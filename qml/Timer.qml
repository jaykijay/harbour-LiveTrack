import QtQuick 2.0
import "."

    Timer {
        property bool done: false
        property int sendgood:0;
        property int sendlater:0;
        property int sendbad:0;
        property int ignored:0;
        property int intervald:livetracksettings.get("intervald");

        id: positiontimer
        interval: intervald; running: false; repeat: false
        onTriggered:{
            done=true;
            if(gps.ready && gps.valid && gps.threshold>0 && gps.threshold<60 && (sendgood<2 || gps.changedbig) ){
                       if(sendData(gps.position,(new Date).getTime()) === true) {
                        positiontimer.interval = intervald;
                        sendgood++;
                            while(positiondata.positionvar.length >0){
                                        var positiontemp=positiondata.positionvar.pop();
                                        var timestamptemp=positiondata.timestampvar.pop();
                                        if(sendData(positiontemp,timestamptemp) === true){
                                           sendlater++;
                                        }
                                            else{
                                            positiondata.positionvar.push(positiontemp);
                                            positiondata.timestampvar.push(timestamptemp);
                                            sendbad++;
                                            break; //jump out of loop, because network is down again..
                                        }
                                    }
                        }

               else{
                       positiondata.positionvar.push(gps.position);
                       positiondata.timestampvar.push((new Date).getTime());
                       sendbad++;
                    }
            }
            else ignored++;

            positiontimer.restart();
            done=false;
        }
    }
