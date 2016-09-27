Metab in elm
====================


Elm version of small react app I wrote. This application displays the weather,
specific subreddits, and top/ask stories from hackernews all in one place easy
to read on desktop and mobile


Running
=======

once you install elm dependencies/node dependencies then :
* In the main directory run `elm-css src/elm/style/StylesSheets.elm -o src/static/styles`
* then `npm start`

No routing, no caching of data, working but not beautiful code at the moment.

![Imgur](http://i.imgur.com/4vi4hjA.png)

Makes use of [elm-webpack-starter](https://github.com/moarwick/elm-webpack-starter) and my
hn logic/modeling/fetching was heaviliy influenced by [elm-hn](https://github.com/massung/elm-hn)
