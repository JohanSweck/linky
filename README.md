Prerequisites
- have a linky electric meter
- create an account on https://mon-compte-client.enedis.fr/

Installation
- retrieve the linky.sh file on a linux system
- get a token from https://conso.vercel.app/ 
- put the Id, token and rtoken in 3 files and configure linky.sh with the corresponding path

Usage
- type "sh linky.sh refresh" to refresh token (must be done every 3 hours)
- type "sh linky.sh json" to retrieve daily electrical consumption in a json file
- type "sh linky.sh last" to retrieve last daily consumption from previous json file 
