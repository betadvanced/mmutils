#!/bin/bash

cd ~/geoip/mmutils
source env/bin/activate

# Country
rm -f GeoIPCountryCSV.zip GeoIPCountryWhois.csv
wget http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip || exit 1
unzip GeoIPCountryCSV.zip || exit 1
rm -f GeoIPv6.csv.gz GeoIPv6.csv
wget http://geolite.maxmind.com/download/geoip/database/GeoIPv6.csv.gz || exit 1
gzip -d GeoIPv6.csv.gz || exit 1

# City
rm -fr GeoLiteCity-latest.zip GeoLiteCity_20*
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity_CSV/GeoLiteCity-latest.zip || exit 2
unzip GeoLiteCity-latest.zip || exit 2
rm -f GeoLiteCityv6.csv.gz GeoLiteCityv6.csv 
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.csv.gz || exit 2
gzip -d GeoLiteCityv6.csv.gz || exit 2

GEOLITE_IPV4=`find . -type d -name "GeoLiteCity_20*"`

DATE=`date +%Y%m%d-%H%M`

# Merge database
./merge_geoip_csv GeoIPCountryWhois.csv GeoIPv6.csv -o GeoIPv4v6-${DATE}.csv && \
	./csv2dat.py -w GeoIPv4v6-${DATE}.dat mmcountry6 GeoIPv4v6-${DATE}.csv || exit 3

./merge_geoip_city_csv -l ${GEOLITE_IPV4}/GeoLiteCity-Location.csv ${GEOLITE_IPV4}/GeoLiteCity-Blocks.csv GeoLiteCityv6.csv -o GeoLiteCityv4v6-${DATE}.csv && \
	./csv2dat.py -w GeoLiteCityv4v6-${DATE}.dat mmcity6 GeoLiteCityv4v6-${DATE}.csv || exit 4

./test.sh GeoIPv4v6-${DATE}.dat GeoLiteCityv4v6-${DATE}.dat || exit 5

rm -f GeoIPv4v6.dat GeoLiteCityv4v6.dat
ln -sf GeoIPv4v6-${DATE}.dat GeoIPv6.dat
ln -sf GeoLiteCityv4v6-${DATE}.dat GeoLiteCityv6.dat

exit 0
