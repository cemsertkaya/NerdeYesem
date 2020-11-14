# NerdeYesem

## Project Plan
1-)Basic design of app DONE

2-)Implemantation of TableViewController-NavigationController DONE

3-)Taking Location and connect api to our app DONE

4-)Algorithm of getting restaurants whose location are close to us DONE

5-)Implement these restaurants to table view DONE

6-)Implementing firebase DONE

7-)Implementing user login and signup DONE

8-)Implementing most prefered restaurants to firebase DONE

9-)Taking photo and upload it to cloud DONE

10-)Fıngerprint Details DONE
***
## Firebase Implemantation
If a restaurant has more than 0 like, i push this restaurant to firestore placed under favorites collection.

Every restaurant has a unique key that comes from zomato api and i use this unique key as document id.

In document i keep these fields:

address(string)

cuisine(string)

favoritedBy(string array): When a user likes the restaurant, i push this user's firebase auth id into the favoriteBy array.
If a user take back its like , i delete from its id from favoriteBy array.

favoritedByCount(Int): Counter of favoriteBy array

name(string)

photo(string)

url(string)

***
## Warnings

You cannot take a photo with a simulator. If you do it crashes.

Some restaurants have no photos on zomato. So photo view can be empty.

***
## Extras

In restaurant details page, there are 2 label, one of them shows address and one of them shows zomato website url.

If you tap address, you will go to iMap for directions.

If you tap url, you will go to Safari.






