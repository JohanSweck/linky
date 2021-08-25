#/bin/bash
#Script: linky.sh
#Version : 1.
#Auteur : Samuel

#variables d'initialisation
#initalisation des TOKEN ici:  https://conso.vercel.app/
TOKEN=$(cat /etc/openhab/scripts/linky/token)
RTOKEN=$(cat /etc/openhab/scripts/linky/rtoken)
ID=$(cat /etc/openhab/scripts/linky/id)


#date du jour
START="2021-06-01"
YESTERDAY=`/bin/date --date '1 days ago' +"%Y-%m-%d"`
TODAY=`/bin/date --date '0 days ago' +"%Y-%m-%d"`

#refresh
if [ $1 = "refresh" ]
then
	RESPONSE=`curl -s -m 10 -X GET https://conso.vercel.app/api/refresh?token=${RTOKEN}`

	if [ ! -z $(echo $RESPONSE | jq 'select(.response.access_token != null) | .response.access_token') ]
	then
		echo "access token OK"
		echo $RESPONSE | jq .response.access_token | sed "s/\"//g " > /etc/openhab/scripts/linky/token
	else
		echo "access token error"
	fi

        if [ ! -z $(echo $RESPONSE | jq 'select(.response.refresh_token != null) | .response.refresh_token') ]
        then
                echo "refresh token OK"
                echo $RESPONSE | jq .response.refresh_token | sed "s/\"//g " > /etc/openhab/scripts/linky/rtoken
        else
                echo "refresh token error"
        fi

fi

#json
if [ $1 = "json" ]
then
	RESPONSE=`curl -s -m 10 -X GET "https://gw.prd.api.enedis.fr/v4/metering_data/daily_consumption?start=${START}&end=${TODAY}&usage_point_id=${ID}"  -H  "Authorization: Bearer ${TOKEN}" |
		 jq 'select(.meter_reading.interval_reading != null) | .meter_reading.interval_reading' `
        if [ ! -z "${RESPONSE}" ]
        then
                echo "json OK"
		echo $RESPONSE > /etc/openhab/scripts/linky/linky.json
	else
                echo "json error"
        fi
fi

#last
if [ $1 = "last" ]
then
	RESPONSE=`jq '.[] | select(.date=="'${YESTERDAY}'") | .value'  /etc/openhab/scripts/linky/linky.json  | sed "s/\"//g "`
#        RESPONSE=`jq '.[] | select(.date=="'${TODAY}'") | .value'  /etc/openhab/scripts/linky/linky.json  | sed "s/\"//g "`

	if [ -z "${RESPONSE}" ]
	then
		echo "-"
	else
		echo $RESPONSE
	fi
fi
