#! /usr/bin/env python

import argparse
import ssl
import sys
import urllib2

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Verify loadbalancer test")
	parser.add_argument("-H", dest="url", default="localhost:8080", help="url to check")
	parser.add_argument("-n", dest="tries", default=100, type=int, help="number och checks")
	parser.add_argument("-k", dest="ssl_verify", default=True, action="store_false", help="verify ssl-certificate")
	args = parser.parse_args()
	if len(sys.argv) < 1:
		parser.print_help()
		sys.exit(1)

	if args.ssl_verify:
		ssl_context = ssl._create_default_https_context
	else:
		ssl_context = ssl._create_unverified_context

	if args.url.startswith("http"):
		url = args.url
	else:
		url = "http://%s" % args.url

	result = dict()
	for request_n in range(args.tries):
		node = urllib2.urlopen(url, context=ssl_context()).read().strip()
		result[node] = result.get(node, 0) + 1

	for node_value in result.iteritems():
		print "Node: %s, Responses: %s" % node_value
