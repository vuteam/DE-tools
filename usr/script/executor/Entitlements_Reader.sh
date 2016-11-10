#!/bin/sh

#DESCRIZIONE= Visualizzazione aggiornamenti smartcards
#Universal CIC
#by virgola
#grazie a 
#Tanica76: per lo script delle nuove NewCS  e Oscam
#Littlesat : autore dello script originale
#
#!/bin/sh
#	
Vlist=`ps | grep -v grep`

if echo "$Vlist" | grep -q CCcam_2.2.1 ; then
   echo "entitlements" | nc localhost 16000
fi

if echo "$Vlist" | grep -q newcs ; then
 ( echo "level None";
   sleep 2
   echo "sub 0";
   sleep 1
   echo "sub 1";
 )|nc localhost 3001 
fi

if [ ! -e $PIDFILE ]; then
  echo "PID file not found"
  exit 2
fi

PIDFILE=/usr/bin/CCcam_2.2.1.pid
LOG=/tmp/CCcam__2.2.1.log
TIERFILE=/tmp/tiers.log

# Send kill to cccam pid
PIDNUMBER=`cat $PIDFILE`

kill -s USR2 $PIDNUMBER

RC=$?
if [ "$RC" = "1" ]; then
   echo "CCcam_2.2.1 not running or pid invalid"
   exit 1
fi

sleep 5

tail -30 $LOG > $TIERFILE

EXPPOS1=`grep "r02" $TIERFILE | sed -n '/expiry/ {p;q;}' |awk -v find=expiry '{ printf ("%s\n", index($0,find) ) }'`
EXPPOS2=`grep "r03" $TIERFILE | sed -n '/expiry/ {p;q;}' |awk -v find=expiry '{ printf ("%s\n", index($0,find) ) }'`
CARDPOS1=`grep "r02 type:" $LOG | sed -n '/r02 type:/ {p;q;}' |awk -v find="r02 type:" '{ printf ("%s\n", index($0,find) ) }'`
CARDPOS2=`grep "r03 type:" $LOG | sed -n '/r03 type:/ {p;q;}' |awk -v find="r03 type:" '{ printf ("%s\n", index($0,find) ) }'`

if [ "$CARDPOS1" != "" ]
then
    echo "Reading Tiers for Reader Lower"
    echo ""
    echo "Card:" 
    sed -n '/r02 type:/ {p;q;}' $LOG | awk '{ print (substr($0,"'"$CARDPOS1"'"+4) ) }'
    echo ""
    echo "Tiers:"
    grep  "expiry date:" $TIERFILE | grep "r02" | awk '{ print (substr($0,"'"$EXPPOS1"'") ) }'
    echo ""
    echo "************************************************************"
fi
echo ""
if [ "$CARDPOS2" != "" ]
then
    echo "Reading Tiers for Reader Upper"
    echo ""
    echo "Card:" 
    sed -n '/r03 type:/ {p;q;}' $LOG | awk '{ print (substr($0,"'"$CARDPOS2"'"+4) ) }'
    echo ""
    echo "Tiers:"
    grep  "expiry date:" $TIERFILE | grep "r03" | awk '{ print (substr($0,"'"$EXPPOS2"'") ) }'
    echo ""
    echo "************************************************************"
fi
echo " End reading OScam Tiers"
echo "************************************************************"

rm -f $TIERFILE

exit 0