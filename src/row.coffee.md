<a name=top>&nbsp;<p></a>       
&nbsp;&nbsp;[home](http://tiny.cc/silon#top) :::
[src](https://github.com/timm/silon/raw/master/src) :::
[issues](http://tiny.cc/silon) :::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>, Tim Menzies <<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br> [<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://tiny.cc/silon)<br>


    {id} = require '../src/fun'

# Row

    class Row
       constructor: (@cells,@id) ->
         @id or= id(@)
       dist: (that, cols, p=2, n=0, d=0) ->
         for c in cols
           n++
           x  = this.cells[c.pos]
           y  = that.cells[c.pos]
           d0 = c.dist(x,y)
           d += d0**p
         (d / n) ** (1/p)
       dominates: (that, cols) ->
         [ s1,s2,n ] = [ 0,0,cols.length ]
         for c in cols
           x   = this.cells[c.pos]
           y   = that.cells[c.pos]
           x1   = c.norm(x)
           y1   = c.norm(y)
           s1 -= 10**(c.w*(x1-y1)/n)
           s2 -= 10**(c.w*(y1-x1)/n)
         s1/n < s2/n

     @Row = Row
