<a name=top>&nbsp;<p></a>       
&nbsp;&nbsp;[home](http://tiny.cc/silon#top) :::
[src](https://github.com/timm/silon/raw/master/src) :::
[issues](http://tiny.cc/silon) :::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>, Tim Menzies <<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br> [<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://tiny.cc/silon)<br>


    {the}      = require '../src/the'
    {Bins}     = require '../src/bins'
    {NumThing} = require '../src/numthing'
    {Order,last,int,rand,d2} = require '../src/fun'

Storing info about numeric  columns (resevoir style):

    class Some extends NumThing
       constructor: (args...) ->
         super args...
         @good  = false   # is @_all sorted?
         @_all  = []      # where to keep things
         @max   = 256     # keep no more than @max items
         @small =   0.147 # used in cliff's delta
         @magic =   2.564 # sd = (90th-10th)/@magic
                          # since 90th z-curve percentile= 1.282
         @bins  =  null
       # ---------   ---------
       mid: (j,k) -> @per(.5,j,k)
       var: (j,k) -> (@per(.9,j,k) - @per(.1,j,k)) / @magic
       iqr: (j,k) -> @per(.75,j,k) - @per(.25,j,k)
       toString:  -> "Some{#{@txt}:#{@mid()}}"
       big:   (n) -> (last(@all()) - @all()[0]) > n
       norm1: (x) -> 
         @all()
         Order.search(@_all,x) / @_all.length
       # --------- --------- --------- -----------------
       per: (p=0.5, j=0, k=@_all.length) ->
          n= @all()[ int(j+p*(k-j)) ]
          n
       # --------- --------- --------- -----------------
       all: ->
         @_all.sort(Order.it) if not @good
         @good = true
         @_all
       # --------- --------- --------- -----------------
       bin1: (x,debug=false) -> 
         if  @bins?
           Order.before(x, @bins.breaks)
         else
           @bins = new Bins(@,debug)
           @bins.cuts(@)
           @bin1(x,debug)
       # --------- --------- --------- -----------------
       add1: (x) ->
         if @_all.length  <= @max
           @_cuts = null
           @good = false
           @_all.push(x)
         else
           @all()
           if rand() < @max/@n
             @_cuts = null
             @_all[ Order.search(@_all,x) ] = x

Exports

    @Some = Some
