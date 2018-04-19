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
            if(gps.ready && gps.valid && gps.threshold>0 && gps.threshold<60 && (sendgood<3000 || gps.changedbig) ){ //DEBUG
                positiondata.positionvar.push({
                                                  "name":"postion",
                                                  value: gps.position,
                                               },
                                              {
                                                  "name":"timestamp",
                                                  value: (new Date).getTime()
                                               },

                                               {
                                                  "name":"dirty",
                                                  value: 'false' }

            );


                while(positiondata.positionvar.length >0 && positiondata.positionvar.  ){
                            sendData(positiondata.positionvar.length -1);
                            }
            }
            positiontimer.restart();
            done=false;
        }
    }
