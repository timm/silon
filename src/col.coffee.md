<a name=top>&nbsp;</a><p>       
&nbsp;&nbsp;[home](http://tiny.cc/silon#top) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://tiny.cc/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>, Tim Menzies <<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br> [<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://tiny.cc/silon)<br>


    {the}  = require '../src/the'
    {same} = require '../src/fun'

Storing info about a column.

    class Col
       constructor:(@txt="",@pos=0,@w=1) -> 
         @n = 0
         @w = -1 if the.ch.less in @txt

       # ---------  --------- --------- ---------
       norm: (x) ->  if x is   the.ch.ignore then x else @norm1 x
       bin:  (x) ->  if x is   the.ch.ignore then x else @bin1  x
       add:  (x) -> (if x isnt the.ch.ignore then (@n++; @add1 x)); x
       show:     -> (@w>0 and ">" or "<")+@mid()
       # ---------  --------- --------- ---------
       adds: (a,f=same) ->
          (@add f(x) for x in a)
          @
       # ---------  --------- --------- ---------
       xpect: (that) ->
         n = this.n + that.n
         this.n/n * this.var() + that.n/n * that.var()

    @Col = Col
