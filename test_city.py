#!/usr/bin/python

from __future__ import print_function
from argparse import ArgumentParser
from ipaddress import IPv4Address, IPv6Address, AddressValueError, NetmaskValueError
from pprint import pprint

import GeoIP

arg_parser = ArgumentParser()

arg_parser.add_argument('-f', '--geoip-dat', default = '/usr/share/geoip/GeoIPCity.dat', 
        help = 'Path to GeoIPCity.dat')
arg_parser.add_argument('ip_or_name', help = 'IP or Name to lookup')

args = arg_parser.parse_args()

gi = GeoIP.open(args.geoip_dat, GeoIP.GEOIP_STANDARD)

try :
    ipaddr = IPv6Address(unicode(args.ip_or_name))
    gir = gi.record_by_addr_v6(args.ip_or_name)
except (AddressValueError, NetmaskValueError):
    try :
        ipaddr = IPv4Address(unicode(args.ip_or_name))
        gir = gi.record_by_addr(args.ip_or_name)
    except (AddressValueError, NetmaskValueError):
        ipaddr = None
        gir = gi.record_by_name(args.ip_or_name)

if gir is not None:
    pprint(gir)
#    print(gir['country_code'])
#    print(gir['country_code3'])
#    print(gir['country_name'])
#    print(gir['city'])
#    print(gir['region'])
#    print(gir['region_name'])
#    print(gir['postal_code'])
#    print(gir['latitude'])
#    print(gir['longitude'])
#    print(gir['area_code'])
#    print(gir['time_zone'])
#    print(gir['metro_code'])
#    print(str(gir))
else :
    print('{} not found'.format(args.ip_or_name))
