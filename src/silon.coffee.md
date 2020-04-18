<a name=top>&nbsp;<p> </a>
[home](http://tiny.cc/silon#top) | 
[&copy; 2020](https://github.com/timm/silon/blob/master/LICENSE.md#top), Tim Menzies, <a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>
<br> [<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://tiny.cc/silon#top)<br> 
[src](http://github.com/timm/silon/blob/master/src) | 
[issues](https://github.com/timm/silon/issues) |
[news](https://github.com/timm/silon/docs/news.md#top) 


<hr>

<img width=700 src="http://yuml.me/diagram/scruffy;dir:lr;scale:200/class/[the(global)|data='.../etc/data';seed=1;ch=num,more,less,klass,ignore{bg:orange}],[Table],[Col|n=0;pos=0;txt=''|mid();var();norm(x);add(x)],[Some|max=256;magic=2.56;small=0.147;_all=()|all();iqr()],[Num|mu;sd;lo;hi|var()],[Row|id;cells],[Sym|mode;most|ent()],[Bins|puny=1.05;min=0.5;cohen=0.3{bg:cornsilk}],[Table]-from[note:CSV{bg:cornsilk}],[Col]^-[Sym],[Col]^-[Num],[Col]^-[Some],[Table]-rows*[Row],[Table]-cols*[Col],[Table]-x*[Col],[Table]-y*[Col],[Some]-cuts[Bins],[Table]-usedby[lines(){bg:cornsilk}]">

# SILON

## What is SILON?

aSILON is a technology demonstrator: epsilon domination

SILON is a teaching tool:

-  DUO
- multi-objective optimization
-  RE-code it, look at the options for each part, implement those options, eval results.


SILON is an experiment: optimization for all. V&V for ai is increasingly about optimization. Traditional optimization is all numeric. Here, 
we explore problems spaces with numbers _and_ symbols.

SILON is a reverse engineering of a decade of research in my lab on ethical AI.

SILON is a response

- Need to simpler AI. need for more folks to undersarnd what is going on, under the hood
- Deep learning. no exploration of structure. people need explicable AI.

## Install

```
sudo -H npm -g install coffee-script
```

To test the install::

```
coffee silon.coffee.md --test
 ```

## Challenges

Much of V&V is "optimize", especially for AI systems.

- Too much data. So use sumamries. Counts for symbols, resoveroir
   sampling for numbers. The bsearch trick. Cluster, then keep jsut a few
- Pravacy problem. dont track individuals. Track populations.
- Certification problem. Track what was seen before. Complain if new
   is alien
- Heterogenous data (symbols and numbers). So work with entropy, not variance.
- Parametric distributions may not occur in real world data.
   Use the Some trick.
- High dimensionality. So reduce space whenever can. Exploit that there
   are usually far more "x" dimensions that "y" goals.
- Labelling problems. SMO. not done yet.

Stuff needed from elsewhere.

    {the}     = require  "./the"

    #{same, today, sum, int, id, rand, any, d2, p2, s4, xray, zero1, clone, say,soy,last, Order}    = require "./fun"

    #{Csv} = require './csv'

Tables

Rows

    class Row
       constructor: (@cells,@id) ->
         @id or= id(@)
       dist: (that, cols,  p=2, n=0, d=0) ->
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
           #say "x #{x} y #{y} x1 #{x1} y1 #{y1} s1 #{s1} s2 #{s2}"
         s1/n < s2/n

Table

    class Table
       constructor:       -> [ @cols,@x,@y,@rows ] = [[],[],[],[]]
       klass:             -> @y[0]
       from:(f,after=same)-> new Csv f,((row) => @add row), (=> after(@))
       add:    (l,id)  -> @cols.length and @row(l,id) or @top(l,id)
       top:   (l, id,pos=0)  -> @cols = (@col(txt,pos++) for txt in l); l
       names:             -> (col.txt for col in @cols)
       dump:              -> say @names(); (say row.cells for row in @rows)
       # --------- --------- --------- --------- ---------  -----------
       mid: -> new Row (c.mid() for c in @cols)
       # --------- --------- --------- --------- ---------  -----------
       clone: (rows=[]) ->
         t=new Table
         t.add (c.txt for c in @cols)
         for row in rows
           t.add row.cells
         t
       # --------- --------- --------- --------- ---------   
       furthest:  (row1,cols,best=0, better=(x,y) -> x>y) ->
         for row2 in @rows
           if id(row1) isnt id(row2)
             tmp = row1.dist(row2,cols)
             if better(tmp,best)
               [ best,out ] = [ tmp,row2 ]
         out
       # --------- --------- --------- --------- ---------   
       nearest: (row1,cols) ->
         @furthest(row1, cols, 10**32, (x,y) -> x < y)
       # --------- --------- --------- --------- ---------   
       row: (l,id) -> 
         l=(col.add( l[col.pos] ) for col in @cols)
         @rows.push(new Row(l,id))
       # --------- --------- --------- ---------
       col: (txt,pos) ->
         what   = if Table.isNum(txt)   then Some else Sym
         where  = if Table.isY(txt)     then @y   else @x
         weight = if the.ch.less in txt then -1   else 1
         c      = new what(txt,pos,weight)
         where.push(c)
         c
       # --------- --------- --------- ---------
       @isNum= (txt) -> switch
            when the.ch.sym  in txt then false
            when the.ch.num  in txt then true
            when the.ch.less in txt then true
            when the.ch.more in txt then true
            else false
       # --------- --------- --------- ---------
       @isY= (txt) -> 
         the.ch.klass in txt or the.ch.less in txt or the.ch.more in txt
       # --------- --------- --------- ---------
       bins: () ->
         t = new Table
         t.add ((the.ch.sym + name) for name in @names())
         for row in @rows
           t.add ( col.bin(row.cells[col.pos]) for col in @cols )
         t

REcursive clustering

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

    class Learn
       constructor: (t, @n=128,@p=2,@far=0.9,
                        @min=t.rows.length**0.5) ->
         [ lvl,debug ] = [ 0,false ]
         y = new FastMap(t,@n,@p,@far,lvl,debug,cols=((t1)->t1.y),@min)
         x = new FastMap(t,@n,@p,@far,lvl,debug,cols=((t1)->t1.x),@min)
         x = x.split()
         y = y.split()
         [ ys,xs ] = [ [],[] ]
         y.leaves((yt) -> ys.push yt)
         x.leaves((xt) -> xs.push xt)
         say ">", xs.length, ys.length
         r2c = {}
         for yt in ys
            for row in yt.rows
              say row.id, id(yt)
              r2c[row.id] = id(yt)
         for xt in xs
           s= new Sym
           for row in yt.rows
             s.add r2c[row.id]
           for k,v of  s.counts
             say ">", k,v
           say 1000,s.var()

Test Engine

    class Ok
      @tries = 0
      @fails = 0
      @all   = {}
      @if    = (f,t) -> throw new Error t or "" if not f
      @go:  ->
        say "\n# " + "-".n() + "\n# " + today() + "\n"
        (Ok.run name,f for name,f of Ok.all)
      @fyi: (name) ->
          a= Ok.tries
          b= Ok.fails
          c= int(0.5 + 100*(a-b)/a)
          process.stdout.write "#{s4(a)}) #{s4(c,3)} %passed after failures= #{b} "
          process.stdout.write console.timeEnd(name)
      @run: (name,f) ->
         try
           Ok.tries++
           the.seed = 1
           console.time(name)
           await (f(); Ok.fyi(name))
         catch error
           Ok.fails++
           l = error.stack.split('\n')
           say l[0]
           say l[2]
           Ok.fyi(name)

Tests

    Ok.all.some1 = ->
       s = new Some
       n = 100000
       for x in (d2(rand(),2) for _ in [1..n]) 
         s.add x
       for x in [0..99] by 10
         m = x/100
         x = s.all()[ int(s.max *m) ]  
         y = s.per(m)
         Ok.if  y-0.01 <= x <= y+0.01
       b = new Bins(s)
       b.cuts(s)
       Ok.if b.breaks.length == 6
       Ok.if  0.55 <= b.bin(0.6)                 <= 0.56 ,    .6
       Ok.if 0.82  <= Order.before(200,b.breaks) <=  .825, 200
       Ok.if 0     <= Order.before(-1, b.breaks) <= 1.131,  -1

    Ok.all.some2 = ->
       s = new Some
       for i in [1..10]
         for j in [1..4]
           s.add j
       b = new Bins(s)
       b.cuts(s)
       c=  b.breaks
       Ok.if  c[0]==1 and c[2]==3 and c.length==3

    Ok.all.table1 = (f= the.data + 'weather2.csv',dump=false,n=0) ->
       table1=(u) ->
         v = u.bins()
         (Ok.if "Sym"==c.constructor.name for c in v.cols)
         v.dump() if dump
       t=(new Table).from(f,table1)

    Ok.all.table2 = -> Ok.all.table1 the.data + 'auto93.csv'
    Ok.all.table3 = -> Ok.all.table1 the.data + 'auto93-10000.csv'

    Ok.all.nearfar = (f=the.data + 'weather4.csv') ->
       nearfar = (u) ->
         cols = u.x
         for row1 in u.rows
           row2 = u.nearest( row1,cols)
           row3 = u.furthest(row1,cols)
           d12   = row2.dist(row1, u.x)
           d13   = row3.dist(row1, u.x)
           Ok.if  d13 > d12
       t = (new Table).from(f, nearfar) 

    Ok.all.dist1 = (f=the.data + 'weather4.csv') ->
       dist1 = (u) ->
         cols = u.x 
         a = u.rows[0]
         b = u.rows[1]
       t = (new Table).from(f, dist1)

    Ok.all.fastmap = (f= the.data + 'auto93.csv') ->
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

    Ok.all.xfastmap = (f= the.data + 'auto93.csv') ->
       the.seed= 1
       fastmap=(u) ->
         f = new FastMap(u)
         f.debug = false
         f.cols = (t1) -> t1.x
         f.split()
         f.leaves((t) ->  soy " ",t.rows.length)
         say ""
       t = (new Table).from(f,fastmap)

    Ok.all.dominates = (f= the.data + 'auto93-10000.csv') ->
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

    Ok.all.js = (f= the.data + 'auto93.csv') ->
       the.seed= 1 
       js=(u) ->
         true  #f = new Learn(u)
       t = (new Table).from(f,js)

    # --------- --------- --------- --------- ---------
    #if "--test" in process.argv then Ok.go()
    #Ok.go()

End.
