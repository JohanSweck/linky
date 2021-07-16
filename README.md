Purpose of the script
- integrate your electrical consumption into a home automation software like openhab

Prerequisites
- have a linky electric meter
- create an account on https://mon-compte-client.enedis.fr/

Installation
- retrieve the linky.sh file on a linux system
- get a token from https://conso.vercel.app/ 
- put the Id, token and rtoken in 3 files and configure linky.sh with the corresponding path

Usage: configure your home automation system to launch these command lines
- "sh linky.sh refresh" to refresh token (must be done every 3 hours)
- "sh linky.sh json" to retrieve daily electrical consumption in a json file
- "sh linky.sh last" to retrieve last daily consumption from previous json file 
