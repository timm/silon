<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>

# FastMap

Recursive clustering

Includes:

    src = "../../src/"
    {the}            = require src+'lib/the'
    {Some}           = require src+'cols/some'
    {Table}          = require src+'data/table'
    {id,int,any,soy,say,s4,
    last,zero1,Order,sayr} = require src+'lib/fun'

Code:

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

Exports:

    @FastMap = FastMap
