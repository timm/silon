<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>

# Sym

Storing info about symbolic  columns.

    src   = '../../src/'
    {the} = require src+'lib/the'
    {say} = require src+'lib/fun'
    {Col} = require src+'cols/col'

Code:

    class Sym extends Col
       constructor: (args...) ->
         super args...
         @counts = {}
         @most   = 0
         @mode   = null
         @_ent   = null
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
       like: (x,prior,m=2) ->
         f = x in @count and @count[x] or 0
         (f + m*prior) /(@n + m)
       # ---------  --------- --------- ---------
       ent: (e=0)->
         if  not @_ent?
           @_ent = 0
           for x,y of @counts
             p      = y/@n
             @_ent -= p*Math.log2(p)
         @_ent

Exports:

    @Sym = Sym
