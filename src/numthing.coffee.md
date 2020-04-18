<a name=top>&nbsp;<p></a>       
[home](http://tiny.cc/silon#top) |
[src](https://github.com/timm/silon/raw/master/src) | 
[issues](http://tiny.cc/silon) |
<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>
<br> [<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://tiny.cc/silon)<br>


    {the} = require '../src/the'
    {Col} = require '../src/col'

Storing info about numeric columns.

    class NumThing extends Col
       dist:(x,y) ->
         if x is the.ch.ignore and y is the.ch.ignore
           return 1
         if x is the.ch.ignore
           y1 = @norm1 y
           x1 = y1 > 0.5 and 0 or 1
         else
           if y is the.ch.ignore
              x1 = @norm1 x
              y1 = x1 > 0.5 and 0 or 1
           else
             x1 = @norm1 x
             y1 = @norm1 y
         Math.abs(x1-y1)

    @NumThing = NumThing
