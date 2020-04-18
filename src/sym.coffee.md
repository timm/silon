<a name=top></a><p>       
&nbsp;&nbsp;[home](http://tiny.cc/silon#top) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://tiny.cc/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>, Tim Menzies <<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br> [<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://tiny.cc/silon)<br>


    {the} = require '../src/the'
    {say} = require '../src/fun'
    {Col} = require '../src/col'

Storing info about symbolic  columns.

    class Sym extends Col
       constructor: (args...) ->
         super args...
         [ @counts,@most,@mode,@_ent ] = [ [],0,null,null ]
       # ---------  --------- --------- ---------
       mid:    () -> @mode
       var:    () -> @ent()
       norm1: (x) -> x
       toString:  -> "Sym{#{@txt}:#{@mode}}"
       bin1:  (x) -> x
       big:   (n) -> t
       dist:(x,y) ->
         if x is the.ch.ignore and y is the.ch.ignore
            return 1
         if x == y then  0 else  1

       # ---------  --------- --------- ---------
       add1: (x) ->
         @_ent = null
         @counts[x] = 0 unless x of @counts
         n = ++@counts[x]
         [ @most,@mode ] = [ n,x ] if n > @most
       # ---------  --------- --------- ---------
       ent: (e=0)->
         if  not @_ent?
           @_ent = 0
           for x,y of @counts
             p      = y/@n
             @_ent -= p*Math.log2(p)
         @_ent

Export

    @Sym = Sym
