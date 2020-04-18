    {the}   = require './the'
    {Ok}    = require './ok'
    {Some}  = require './some'
    {Table} = require './table'
    {id,int,any,soy,say,last,zero1,Order} = require './fun'

Recursive clustering

    class FastMap
      constructor: (t, @n=128, @p=2, @far=0.9,
                       @lvl=0, @debug=false,
                       @cols= (t1) -> t1.y,
                       @min= t.rows.length**0.5,
                       @depth=15) ->
        [ @t,@wests,@mid,@easts,@use ]  = [ t,null,0.5,null,true ]

      # --------- --------- --------- ---------
      dist: (row1,row2) -> 
         row1.dist(row2,@cols(@t),@p)
      # --------- --------- --------- ---------
      kid:(t) ->
        x=new FastMap(t,
                      @n,@p,@far,@lvl+1,@debug,@cols,@min,@depth-1)
        x.split()
        x
      # --------- --------- --------- ---------
      leaves: (f) ->
         if @wests? and @easts?
           @wests.leaves f
           @easts.leaves f
         else
           f( @t)
      # --------- --------- --------- ---------
      split: () ->
        if @debug
            report =  (c.show() for c in @t.y).join(", ")
            say s4(report,35)+ ' |..'.n(@lvl) + " (" +@t.rows.length+')'
        if @t.rows.length > 2*@min
          [ below,after ] = @divide()  
          t= @t.rows.length 
          a= after.rows.length
          b= below.rows.length
          if b< t and b > @min and a<t and a>@min
            @wests = @kid(below) 
            @easts = @kid(after) 
        @
      # --------- --------- --------- ---------
      divide: () ->
        tmp   = any(@t.rows)
        @east = @farFrom(tmp)
        @west = @farFrom(@east)
        @c    = @dist(@east, @west) + the.tiny
        dists = new Some
        cache = []
        for row in @t.rows
          a = @dist(row, @east)
          b = @dist(row, @west)
          x = zero1( (a**2 + @c**2 - b**2) / (2*@c) )
          cache[ id(row) ] = x 
          dists.add x
        @mid = dists.mid()
        [ below,after ] = [ @t.clone(),@t.clone() ]
        for row in @t.rows
          what = cache[ id(row) ] <= @mid and below or after
          what.add row.cells,row.id
        [ below, after ]
      # --------- --------- --------- ---------
      farFrom: (row1, l=[], j=int(@n*@far)) ->
        for i in [1 .. @n]
          row2 = any(@t.rows)
          l.push {r: row2, d: @dist(row1,row2)}
        l = l.sort(Order.fun (x) -> x.d)
        l[j].r

Test cases

    Ok.all.fmap = {}
    Ok.all.fmap.fastmap = (f= the.data + 'auto93.csv') ->
       the.seed= 1
       fastmap=(u) ->
         f = new FastMap(u)
         f.debug = false
         f.split()
         l=[]
         f.leaves((t) -> l.push t)
         for t1 in l
           t1.dom = 0
           for t2 in l
             if t1.mid().dominates( t2.mid(), u.y)
               t1.dom += 1
         l = l.sort(Order.fun (x) -> x.dom)
         best = last(l)
         worst= l[0]
         Ok.if best.mid().dominates(u.mid(), u.y)
         f.leaves((t) ->  soy " ",t.rows.length)
         say ""
       t = (new Table).from(f,fastmap)

    Ok.all.fmap.xfastmap = (f= the.data + 'auto93.csv') ->
       the.seed= 1
       fastmap=(u) ->
         f = new FastMap(u)
         f.debug = false
         f.cols = (t1) -> t1.x
         f.split()
         f.leaves((t) ->  soy " ",t.rows.length)
         say ""
       t = (new Table).from(f,fastmap)

    Ok.all.fmap.dominates = (f= the.data + 'auto93-10000.csv') ->
       dominates = (u) ->
          cache = {}
          for row1 in u.rows
            d=0
            for i in [1..64]
              row2 = any(u.rows)
              if row1.dominates(row2,u.y) 
                d+=1
            cache[ row1.id ] = d
          u.rows = u.rows.sort(Order.fun (x) -> cache[x.id])
          worst  = u.rows[0]
          best   = last(u.rows)
          Ok.if best.dominates(worst, u.y)
       t = (new Table).from(f,dominates)

Main.

    Ok.go "fmap" if require.main is module
    @NFastMap = FastMap
