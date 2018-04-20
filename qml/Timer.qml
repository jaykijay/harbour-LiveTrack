import QtQuick 2.0
import "."

    Timer {
        property bool done: false
        property int tempindextimer: 0
        property int intervald:livetracksettings.get("intervald");

        id: positiontimer
        interval: intervald; running: false; repeat: false
        onTriggered:{
            done=true;
            if(gps.ready && gps.valid && gps.threshold>0 && gps.threshold<60 && (sendgood<3000 || gps.changedbig) ){ //DEBUG
                positiondata.positionvar.push({   postion: gps.position,
                                                  timestamp: (new Date).getTime(),
                                                  dirty: false });

                for(tempindextimer=0;positiondata.positionvar.length >0;tempindextimer++){
                    console.log(gps.position.coordinate.latitude+ "\n");
                    console.log(positiondata.positionvar[tempindextimer].position.coordinate.latitude);
                    if( positiondata.positionvar[tempindextimer].dirty === false ){
                        positiondata.positionvar[tempindextimer].dirty = true;
                        sendData(tempindextimer);
                    }
                            }
            }
            positiontimer.restart();
            done=false;
        }
    }
