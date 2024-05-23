import requests
import csv
from hashlib import sha256


x = requests.get('https://www.googleapis.com/youtube/v3/commentThreads?key=AIzaSyCjBFuqPPsLVLePgKP92MKx8cHlLvrKPPQ&videoId=GNZBSZD16cY&part=snippet&maxResults=100')
print(x.status_code)
x_data=x.json()
usernames=[]
passwords=[]
images=[]
with open('data.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['Username', 'Password', 'Image'])  # Write header row

y=0
while y<300:

    i=0
    while i < 100 :
    
        comment_thread = x_data["items"][i]
        snippet = comment_thread["snippet"]
        top_comment = snippet["topLevelComment"]

        # Access the desired fields
        text_display = top_comment["snippet"]["textDisplay"]
        password = sha256(text_display.encode("utf-8")).hexdigest()
        password = password[:8]
        passwords.append(password)
        usernames.append(top_comment["snippet"]["authorDisplayName"])
        images.append(top_comment["snippet"]["authorProfileImageUrl"])
        i+=1
    with open('data.csv', 'a', newline='') as csvfile:
        writer = csv.writer(csvfile)

        i=0
        while i<100:
            writer.writerow([usernames[i], passwords[i], images[i]])  # Write data rows
            i+=1
    a = (y+1)*100
    nextPageToken = x_data["nextPageToken"]
    print ("Letti "+str(a)+" commenti")

    x = requests.get('https://www.googleapis.com/youtube/v3/commentThreads?key=AIzaSyCjBFuqPPsLVLePgKP92MKx8cHlLvrKPPQ&videoId=GNZBSZD16cY&part=snippet&maxResults=100&pageToken='+nextPageToken)
    print(x.status_code)
    x_data=x.json()

    y += 1






# &pageToken={nextPageToken}