import requests
import xml.etree.ElementTree as ET

RSS_FEED_URL = "https://www.latimes.com/feeds"

def loadRSS():
	resp = requests.get(RSS_FEED_URL)
	return resp.content
	
def parseXML(rss):
	root = ET.fromstring(rss)
	newsitems = []
	
	for item in root.findall('./channel/item'): # path for content
		news = {}
		for child in item:
			# this needs to be adjusted for the updated feed tags
			if child.tag == '{https://latimes.com/}content':
				news['media'] = child.attrib['url']
			else:
				news[child.tag] = child.text.encode('utf8')
		newsitems.append(news)	
	return newsitems

def topStories():
	rss = loadRSS()
	newsitems = parseXML(rss)
	return newsitems
	