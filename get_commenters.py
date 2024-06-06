import requests
import json
from hashlib import sha256
import random

x = requests.get('https://www.googleapis.com/youtube/v3/commentThreads?key=AIzaSyCjBFuqPPsLVLePgKP92MKx8cHlLvrKPPQ&videoId=GNZBSZD16cY&part=snippet&maxResults=100')
print("request api yt:["+str(x.status_code)+"]")
user_data=x.json()

x = requests.get('https://7yndq2n1hc.execute-api.us-east-1.amazonaws.com/default/get_all_tags')
print("request api aws["+str(x.status_code)+"]")
tags_data=x.json()


usernames=[]
passwords=[]
images=[]

y=0
utenti_finale = []
while y<300:
    utenti = []
    
    i=0
    while i < len(user_data["items"]) :
        utente = {}
        
        comment_thread = user_data["items"][i]
        snippet = comment_thread["snippet"]
        top_comment = snippet["topLevelComment"]

        # Access the desired fields
        text_display = top_comment["snippet"]["textDisplay"]
        password = sha256(text_display.encode("utf-8")).hexdigest()
        password = password[:8]
        # passwords.append(password)
        # usernames.append(top_comment["snippet"]["authorDisplayName"])
        # images.append(top_comment["snippet"]["authorProfileImageUrl"])

        utente['password'] = password
        utente['username'] = top_comment["snippet"]["authorDisplayName"]
        utente['image'] = top_comment["snippet"]["authorProfileImageUrl"]

        tags = []
        tag = {}
        t = 0
        numTag = random.randint(2,6)
        tagUsati = []
        while t < numTag:
            randomTag = 0
            c = False
            while c == False:
                randomTag = random.randint(0,len(tags_data)-1)
                if randomTag not in tagUsati:
                    c = True
                    tagUsati.append(randomTag)


            tag['tag'] = tags_data[randomTag]
            tag['score'] = random.randint(0,100)
            if(tag['score']!=0):
                tags.append(tag.copy())
            t+=1
        utente['tags'] = tags
        utenti.append(utente.copy())

        # print(utente)
        i+=1
    
    utenti_finale.append(utenti.copy())
    commenti_letti = (y+1)*len(user_data["items"])
    nextPageToken = user_data["nextPageToken"]
    print ("Letti "+str(commenti_letti)+" commenti")

    x = requests.get('https://www.googleapis.com/youtube/v3/commentThreads?key=AIzaSyCjBFuqPPsLVLePgKP92MKx8cHlLvrKPPQ&videoId=GNZBSZD16cY&part=snippet&maxResults=100&pageToken='+nextPageToken)
    print(x.status_code)
    user_data=x.json()

    y += 1


with open('data.json', 'w', newline='') as jsonfile:
    json.dump(utenti_finale, jsonfile)


# &pageToken={nextPageToken}
