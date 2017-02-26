
# coding: utf-8

# ## This notebook has code that grabs N random words from an online swedish dictionary 

# In[ ]:

import sys
from bs4 import BeautifulSoup
import urllib
import string
import random
import urllib.request
import html.parser
import requests
from requests.exceptions import HTTPError
from socket import error as SocketError
from http.cookiejar import CookieJar

def main():
    choice = sys.argv[1]
    english = sys.argv[2]
    if choice == 'a':
        english_given(english)
    elif choice == 'b':
        random_word()
    else:
        pass 


# In[ ]:

def english_given(choice):
    
    url = 'http://en.bab.la/dictionary/english-swedish/' + choice 
    html = urllib.request.urlopen(url).read()
    soup = BeautifulSoup(html, "html.parser")
    
    results = []
    links = soup.find_all('a', href=True)
    for link in links:
        if '/dictionary/swedish-english/' in link['href']:
            results.append(link['href'].rsplit('/', 1)[1])#.encode('UTF-8'))
    print(list(set(results))[1::])
    #return list(set(results))[1::]
    #return choice
    # We will get a new word


def random_word():
	alphabet = string.ascii_lowercase
	letter = random.sample(alphabet, 1)[0]


	url = "http://en.bab.la/dictionary/english-swedish/" + letter + "/"
	html = urllib.request.urlopen(url).read()
	soup = BeautifulSoup(html, "html.parser")

	links = soup.findAll('a', href=True)

	counter = 0

	for link in links:
		try:
			if 'for letter {}'.format(letter.upper()) in link.contents[0]:
				counter += 1
			else:
				pass
		except:
			pass
        
	numbers = range(counter)
	number = random.sample(numbers, 1)[0]

	url2 = 'http://en.bab.la/dictionary/english-swedish/' + letter + '/' + '{}'.format(number)
	html2 = urllib.request.urlopen(url2).read()
	soup2 = BeautifulSoup(html2, "html.parser")

	links = soup2.findAll('a', href=True)
	words = []

	for link in links:
		if '/dictionary/english-swedish/' in link.get('href'):
			counter += 1
			words.append(link.get('href').split('/')[-1])
		else:
			pass
    
	word = random.sample(words,1)[0] 


	url = "http://en.bab.la/dictionary/english-swedish/" + word

	try:
		req=urllib.request.Request(url, None)
		cj = CookieJar()
		opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))
		response = opener.open(req)
		raw_response = response.read().decode('utf8', errors='ignore')
		response.close()
	except urllib.request.HTTPError as inst:
		output = format(inst)

	soup = BeautifulSoup(raw_response, 'html.parser')


	links = soup.findAll('strong') #, href=True, attrs={'class': None})

	definitions = []
	for link in links:#if link.text != word:
		defs = link.text
		defs2 = defs.replace(" ", "-")
		definitions.append(defs2)
    #else:
    #    pass
	everything = [w for w in list(set(definitions)) if w != word]
	everything.append(word)
	print(everything)



# Standard boilerplate to call the main() function.
if __name__ == '__main__':
    main()


