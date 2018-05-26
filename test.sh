#!/bin/bash

IP_LIST="\
::ffff:203.151.85.51 \
::ffff:100.64.0.5 \
::ffff:100.125.0.1 \
::ffff:103.253.135.141 \
2001:c00:4618:cafe:1996::167 \
2401:5700:503:10::1 \
"

DB_COUNTRY="$1"
DB_CITY="$2"

for IP in ${IP_LIST}; do
	geoiplookup6 -f ${DB_COUNTRY} ${IP} || exit 1
	./test_city.py -f ${DB_CITY} ${IP} || exit 2
done

exit 0
