
= TaxiMetrics

A toy application to fetch interesting metrics about taxi usage in New York City.
It can be run from the command line by running `index.js` in src/cli like so:

`node index.js`

A full list of options can be seen with:

`node index.js help`

To find the cheapest taxi between two routes:

`node index.js whichbest <pickup> <dropoff>`

This will select the best taxi service (green or yellow) for the route.
Possible pickup and dropoff locations can be determined by:

`node index.js zones`

If you know the borough that your zone is part of, you can narrow down the selection by:

`node index.js zones <borough>`

To see a list of possible boroguhs, run:

`node index.js boroughs`
