<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>

# NumThing

Abstract class above `Some` and `Num`.
Storing info about numeric columns.

    src = '../../src/'
    {the} = require src+'lib/the'
    {Col} = require src+'cols/col'

Code:

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

Exports:

    @NumThing = NumThing
