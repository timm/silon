    {the}                 = require './the'
    {Ok}                  = require './ok'
    {Bins}                = require './bins'
    {NumThing}            = require './numthing'
    {Order,last,int,rand,d2} = require './fun'

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

Test cases

    Ok.all.some = {}
    Ok.all.some.some1 = ->
       s = new Some
       n = 100000
       for x in (d2(rand(),2) for _ in [1..n]) 
         s.add x
       for x in [0..99] by 10
         m = x/100
         x = s.all()[ int(s.max *m) ]  
         y = s.per(m)
         Ok.if  y-0.01 <= x <= y+0.01
       
    Ok.all.some.some2 = ->
       s = new Some
       n = 100000
       for x in (d2(rand(),2) for _ in [1..n]) 
         s.add x
       b = new Bins(s)
       b.cuts(s)
       Ok.if b.breaks.length == 6
       Ok.if  0.55 <= b.bin(0.6)                 <=  0.56,  .6
       Ok.if 0.82  <= Order.before(200,b.breaks) <=  .825, 200
       Ok.if 0     <= Order.before(-1, b.breaks) <= 1.131,  -1

    Ok.all.some.some3 = ->
       s = new Some
       for i in [1..10]
         for j in [1..4]
           s.add j
       b = new Bins(s)
       b.cuts(s)
       c=  b.breaks
       Ok.if  c[0]==1 and c[2]==3 and c.length==3

    Ok.go "some" if require.main is module
    @Some = Some
