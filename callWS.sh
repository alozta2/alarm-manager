################VARIABLES##################
SCRIPT_DIR="/"
HOST=`echo $HOSTNAME| tr '[a-z]' '[A-Z]'`
SENDMAILX=$SCRIPT_DIR/smsmailx
PHONEBOOK=$SCRIPT_DIR/phonebook.txt
THETIME=`date +%Y%m%d%H%M%S`
MAIL_LOG=$SCRIPT_DIR/callWS.log
MAIL_FILE=$SCRIPT_DIR/mailList.txt
MAIL_LIST=`cat $MAIL_FILE`
WS_STATUS=$SCRIPT_DIR/ws_soap_response.xml

###Machine based variables###
NODE_NAME=""
###
###########################################

#################FUNCTIONS#################
function send_mail_alarm(){
delay=1
exec >> $MAIL_LOG 2>&1
{
RECIPIENTLIST=`echo "$MAIL_LIST" | sed "s/,/ /g"`
rcptlst=""
spt=""
echo "HELO "$HOST""
sleep "$delay"
echo "MAIL From:alozta@example.com"
sleep "$delay"
for RECIPIENT in $RECIPIENTLIST
do
echo "RCPT To:<"$RECIPIENT"@example.com>"
rcptlst="$rcptlst""$spt""$RECIPIENT"@example.com
spt=", "
sleep "$delay"
done
echo DATA
echo "From:ADMIN@"$NODE_NAME""
echo "To:"$rcptlst""
echo "Subject: Web Service ERROR | $THETIME : WS query has not returned success."
echo
echo "$THETIME : WS query has not returned success."
echo
echo -e "$STATUS"
echo .
sleep "$delay"
echo QUIT
} | telnet outlook.example.local 25
}

function send_sms_alarm {
exec >> $MAIL_LOG 2>&1
 for msisdn in `cat $PHONEBOOK | awk '{print $1}'`
    do
        echo "Alarm sending to $msisdn"
                $SENDMAILX $msisdn "ALERT\nHostname: $NODE_NAME\nTime: $THETIME\n\nWS query has not returned success."
    done
}
###########################################

##################MAIN#####################

#send_sms_alarm
#send_mail_alarm

/bin/bash /callWSv2/ws_soap_request.sh > $WS_STATUS
STATUS=`cat $WS_STATUS`
isSUCCESS=`echo $STATUS|grep "<resultDesc>Success</resultDesc>"`

if [ "$isSUCCESS" == "" ]
then
    echo "$THETIME : WS query has not returned success."
    send_sms_alarm
    send_mail_alarm
fi

###########################################
