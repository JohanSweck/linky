#/bin/bash
#Script: linky.sh
#Version : 1.
#Auteur : Samuel

#variables d'initialisation

TOKEN=$(cat /path/token)   
RTOKEN=$(cat /path/rtoken)  
ID=$(cat /path/id)

#date du jour
START="2021-06-01"
YESTERDAY=`/bin/date --date '1 days ago' +"%Y-%m-%d"`
TODAY=`/bin/date --date '0 days ago' +"%Y-%m-%d"`

#Refresh
if [ $1 = "refresh" ]
then
RESPONSE=`curl -m 10 -X GET https://conso.vercel.app/api/refresh?token=${RTOKEN} `
echo $RESPONSE | jq .response.access_token | sed "s/\"//g " > /etc/openhab/scripts/linky/token
echo $RESPONSE | jq .response.refresh_token | sed "s/\"//g " > /etc/openhab/scripts/linky/rtoken
fi

#génération du json
if [ $1 = "json" ]
then
RESPONSE=`curl -m 10 -X GET "https://gw.prd.api.enedis.fr/v4/metering_data/daily_consumption?start=${START}&end=${TODAY}&usage_point_id=${ID}"  -H  "Authorization: Bearer ${TOKEN}"`
echo $RESPONSE | jq .meter_reading.interval_reading > /etc/openhab/scripts/linky/linky.json
fi

#génération du last conso
if [ $1 = "last" ]
then
jq '.[] | select(.date=="'${YESTERDAY}'") | .value'  /etc/openhab/scripts/linky/linky.json  | sed "s/\"//g "
fi
