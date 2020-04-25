<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>


# Col

Root class for all columns.

    src = '../../src/'
    {the}  = require src+'lib/the'
    {same,p2} = require src+'lib/fun'

Code:

    class Col
       constructor:(@txt="",@pos=0,@w=1) -> 
         @n = 0
         @w = -1 if the.ch.less in @txt

       # ---------  --------- --------- ---------
       norm: (x) ->  if x is   the.ch.ignore then x else @norm1 x
       bin:  (x) ->  if x is   the.ch.ignore then x else @bin1  x
       add:  (x) -> (if x isnt the.ch.ignore then (@n++; @add1 x)); x
       show:     -> (@w>0 and ">" or "<")+ p2(@norm(@mid()))
       # ---------  --------- --------- ---------
       adds: (a,f=same) ->
          (@add f(x) for x in a)
          @
       # ---------  --------- --------- ---------
       xpect: (that) ->
         n = this.n + that.n
         this.n/n * this.var() + that.n/n * that.var()

Exports:

    @Col = Col
