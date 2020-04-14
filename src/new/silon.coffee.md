say 11
<name=top>&nbsp;<p> </a>
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

SILON is a technology demonstrator: epsilon domination

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

## Stuff needed from elsewhere.

    readline  = require 'readline'
    fs        = require 'fs'

## My own config

    the =
      id: 0
      data: "../etc/data/"
      conf: 95
      seed: 1
      ch:
        num: '$'
        sym: ':'
        more: '>'
        less: '<'
        klass: '!'
        ignore: '?'
      ninf: -1 * (Number.MAX_SAFE_INTEGER - 1)
      inf:  Number.MAX_SAFE_INTEGER
      tiny: 10 ** (-32)
    
## Standard Stuff

Standard functions.

    same   = (x) -> x 
    today  = () -> Date(Date.now()).toLocaleString().slice(0,25)
    #abort  = throw new Error('bye')
    sum    = (l,f=same,n=0) -> (n+=f(x) for x in l); n

    int =  Math.floor
    id  = (x) ->  
      x.__id = ++the.id unless x.__id?
      x.__id

    rand=  ->
        x = Math.sin(the.seed++) * 10000
        x - int(x)

    any= (l) ->  l[ int(rand()*l.length) ] 
    d2= (n,f=2) ->  n.toFixed(f)
    p2= (n,f=2) ->  Math.round(100*d2(n,f))
    s4= (n,f=4) ->
       s = n.toString()
       l = s.length
       pre = if l < f then " ".n(f - l) else ""
       pre + s

    xray= (o) -> say ""; (say "#{k} = #{v}"  for k,v of o)

    zero1= (x) -> switch
       when x<0 then 0
       when x>1 then 1
       else x

    clone = (x) -> # deepCopy
      if not x? or typeof x isnt 'object'
        x
      else
        y = new x.constructor()
        for k of x
          y[k] = clone x[k]
        y

Strings

    String::last = @[ @.length - 1 ]
    String::n    = (m=40) -> Array(m+1).join(@)

    say = (l...) -> process.stdout.write l.join(", ") + "\n"

Lists

    last = (a) -> a[ a.length - 1 ]

    class Order
      @fun = (f)   -> ((x,y) -> Order.it  f(x), f(y))
      @key = (key) -> ((x,y) -> Order.fun (z) -> z[key])
      @it  = (x,y) -> switch
        when x <  y then -1
        when x == y then  0
        else 1
      @search = (lst,val,f=((z) -> z)) ->
        [lo,hi] = [0, lst.length - 1]
        while lo <= hi
          mid = int((lo+hi)/2)
          if f( lst[mid] ) >= val
            hi = mid - 1
          else
            lo = mid + 1
        Math.min(lo,lst.length-1)
      @before = (x,lst, y=lst[0]) ->
        for z in lst
          if z>x then break else y=z
        y

Csv

    class Csv
      constructor: (file, action, done) ->
        @use     = null
        @lines    = []
        @action  = action
        Csv.linesDo file, @line, (done or ->)
      line: (s) =>
        if s
          s = s.replace /\s/g,''
          s = s.replace /#.*/,''
          @merge s if s.length
      merge: (s) ->
        @lines.push s
        if last(s) isnt ','
          @act @lines.join("").split ','
          @lines = []
      act: (cells) ->
        if cells.length
          @use or= (i for c,i in cells when the.ch.ignore not in c)
          @action (@prep cells[i] for i in @use)
      prep: (s) ->
        t = +s
        if Number.isNaN(t) then s else t
      @linesDo: ( file, action, done = (-> ) ) ->
        stream = readline.createInterface
          input:    fs.createReadStream file
          output:   process.stdout
          terminal: false
        stream.on 'close',           -> done()
        stream.on 'error', ( error ) -> action error
        stream.on 'line',  ( line  ) -> action line

## Tables

Storing info about a column.

    class Col
      constructor:(txt,pos,w=1) -> [@n,@w,@pos,@txt]=[0,w,pos,txt]
      # ---------  --------- --------- ---------
      norm: (x) ->  if x is   the.ch.ignore then x else @norm1 x
      bin:  (x) ->  if x is   the.ch.ignore then x else @bin1  x
      add:  (x) -> (if x isnt the.ch.ignore then (@n++; @add1 x)); x
      # ---------  --------- --------- ---------
      adds: (a,f=same) ->
         (@add f(x) for x in a)
         @
      # ---------  --------- --------- ---------
      xpect: (that) ->
        n = this.n + that.n
        this.n/n * this.var() + that.n/n * that.var()

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

Storing info about numeric columns.

    class NumThing extends Col
      dist:(x,y) ->
        if x is the.ch.ignore and y is the.ch.ignore
          return 1
        if x is the.ch.ignore
          y1 = @norm1 y
          x1 = y1 > 0.5 and 0 or 1
        else
          if y is the.ch.ignore
             x1 = @norm1 x
             y1 = x1 > 0.5 and 0 or 1
          else
            x1 = @norm1 x
            y1 = @norm1 y
        Math.abs(x1-y1)

    class Num extends NumThing
      constructor: (args...) ->
        super args...
        [ @mu,@m2,@sd ] = [ 0,0,0,0 ]
        [ @hi, @lo ]    = [ the.ninf, the.inf ]
      # ---------  --------- --------- ---------
      mid:    () -> @mu
      var:    () -> @sd
      norm1: (x) -> (x - @lo) / (@hi - @lo + the.tiny)
      toString:  -> "Num{#{@txt}:#{@lo}..#{@hi}}"
      big:   (n) -> (@hi - @lo) > n
      # ---------  --------- --------- ---------
      bin1: (x) ->
        z = (x - @mu)/ (the.tiny + @sd0())
        z = Order.before(z,[-1.28,-.84,-.52,-.25,0,.25,.52,.84,1.28])
        @mu + z * @sd0()
      # ---------  --------- --------- ---------
      add1: (x) ->
        @lo   = if x < @lo then x else @lo
        @hi   = if x > @hi then x else @hi
        delta = x - @mu
        @mu  += delta / @n
        @m2  += delta * (x - @mu)
        @sd   = @sd0()
      # ---------  --------- --------- ---------
      sd0: () -> switch
        when  @n < 2  then 0
        when  @m2 < 0 then 0
        else (@m2 / (@n - 1))**0.5

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

Unsupervised discretization.

    class Bins
      constructor: (s,debug=false) ->
        s.all()
        @debug    = debug # show debug information?
        @puny     =  1.05 # ignore puny improvements
        @min      =  0.5  # usually, divide into sqrt(n) size bins
        @cohen    =  0.3  # epsilon = @var()*@cohem
        @maxDepth = 15
        @min      = int(s._all.length**@min)
        @e        = s.var() * @cohen
        @breaks   = []
      # --------- --------- --------- ---------   ----------
      bin: (x) -> Order.before(x,@breaks)
      # --------- --------- --------- ---------   ----------
      cuts: (s, lo=0, hi=s._all.length-1, lvl=0) ->
        if lvl < @maxDepth 
          if @debug
            say "| ".n(lvl)+"#{s._all[lo]} to #{s._all[hi]}: #{hi-lo+1}"
          cut = @argmin(s,lo,hi)
          if cut isnt null
            @cuts(s, lo,   cut, lvl+1)
            @cuts(s, cut+1, hi, lvl+1)
          else
            # ignore cutting on last value (no point)
            @breaks.push s._all[hi] if hi < s._all.length - 1
      # --------- --------- ---------
      argmin: (s,lo,hi) ->
        cut =  null                     # default result. null==no break found
        if hi - lo > 2*@min             # is there enough here to cut in two?
          best = s.var(lo,hi)           # the status quo that we want to beat
          for j in [lo+@min .. hi-@min] # (start,end) needs at least @min
            x     = s._all[j]
            after = s._all[j+1]
            if x isnt after             # only break between different values
              below = s.mid(lo,j)
              above = s.mid(j+1,hi)
              if (above - below) > @e   # ignore breaks with small median diff
                now = @xpect(s,lo,j,hi)
                if now * @puny < best   # ignore puny small improvements
                  best = now
                  cut  = j              # update the best cut found so far
        cut # return the best cut found
      # --------- --------- --------- ---------   ------------
      xpect: (s,j, m, k) ->
        (the.tiny + (m-j)*s.var(j,m) + (k-m-1)*s.var(m+1,k))/(k-j+1)
            
## Rows

    class Row
      constructor: (@cells,@id) ->
        @id or=  id(@)
      dist: (that, cols,  p=2, n=0, d=0) ->
        for c in cols
          n++
          x  = this.cells[c.pos]
          y  = that.cells[c.pos]
          d0 = c.dist(x,y)
          d += d0**p
        (d / n) ** (1/p)

## Table

    class Table
      constructor:       -> [ @cols,@x,@y,@rows ] = [[],[],[],[]]
      klass:             -> @y[0]
      from:(f,after=same)-> new Csv f,((row) => @add row), (=> after(@))
      add:          (l,id) -> @cols.length and @row(l,id) or @top(l,id)
      top:   (l, id,pos=0)  -> @cols = (@col(txt,pos++) for txt in l); l
      names:             -> (col.txt for col in @cols)
      dump:              -> say @names(); (say row.cells for row in @rows)
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
       constructor: (t, @n=32, @p=2, @far=0.9,
                        @lvl=0, @debug=false,
                        @cols= "y",
                        @min= t.rows.length**0.5,
                        @depth=15) ->
         @t = t
       # --------- --------- --------- ---------
       kid:(t) ->
         x=new FastMap(t,@n,@p,@far,@lvl+1,\
                         @debug,@cols,@min,@depth-1)
         x.split()
         x
       # --------- --------- --------- ---------
       split: () ->
         if @t.rows.length > 2*@min
           say '|.. '.n(@lvl) + @t.rows.length  if @debug
           [ below,after ] = @divide()
           @wests = @kid(below) if below.rows.length < @t.rows.length
           @easts = @kid(after) if after.rows.length < @t.rows.length
         else
           if @debug
             say '|.. '.n(@lvl) + @t.rows.length  +  \
                " : "+(c.mid() for c in @t.y)
       # --------- --------- --------- ---------
       divide: () ->
         cols = @t[@cols]
         tmp   = any(@t.rows)
         @east = @farFrom(tmp,    cols)
         @west = @farFrom(@east,  cols)
         @c    = @east.dist(@west,cols) + the.tiny
         dists = new Some
         all = []
         for row in @t.rows
           a = row.dist(@east, cols)
           b = row.dist(@west, cols)
           d = zero1( (a**2 + @c**2 - b**2) / (2*@c) )
           d  = d.toFixed(3)
           all[ id(row) ] = d
           dists.add d
         mid = dists.mid() 
         [ below,after ] = [ @t.clone(),@t.clone() ]
         for row in @t.rows
           what = all[ id(row) ] <= mid and below or after
           what.add row.cells
         [ below, after ]
       # --------- --------- --------- ---------
       farFrom: (row1, cols, l=[], j=int(@n*@far)) ->
         for i in [1 .. @n]
           row2 = any(@t.rows)
           l.push {r: row2, d: row1.dist(row2, cols, @p)}
         l = l.sort(Order.key("d")) 
         l[j].r 
 
## Test Engine

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
          process.stdout.write "#{s4(a)} #{s4(c,3)} 
                               %passed after failures= #{b} "
          console.timeEnd(name)
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

    Ok.all.timing = ->
      j=0
      n=0.25*10**9
      for i in [1 .. n]
        j++
      Ok.if j == n

    Ok.all.id= ->
      [a,b] = [{},{}]
      a1id = id(a)
      b1id = id(b)
      a2id = id(a)
      Ok.if a1id is a2id and a1id isnt b1id

    Ok.all.clone= ->
      b4  = [[1,2], {a: 10, b: 20, c: [3,4,[5,6]]}]
      now = clone(b4)
      b4[1].c[2][1] = 100
      Ok.if  b4[ 1].c[2][1] isnt  now[1].c[2][1]

    Ok.all.sort= ->
         x = [10000,-100,3,1,2,-10,30,15]
         y = x.sort(Order.it)
         Ok.if x[0]  == -100
         Ok.if last(x)   ==   10000

    Ok.all.keysort = ->
      l = ({a: n,b: -1*n} for n in [20..1])
      l.sort(Order.key "b")
      Ok.if l[0].b == -20
      Ok.if last(l).a  == 1

    Ok.all.random = ->
      l= (p2 rand() for _ in [1..100])
      l= l.sort(Order.it)
      Ok.if  2 == l[0]
      Ok.if 98 == last(l)
    
    Ok.all.bsearch = ->
      l= (d2(rand(),2) for _ in [1..100])
      l.sort(Order.it)
      for i in [0.. l.length - 1] by 20
         j = Order.search(l,l[i])
         Ok.if Math.abs( j - i ) <= 3

    Ok.all.before = ->
      Ok.if  2 == Order.before  0,[2,4,8,12]
      Ok.if  8 == Order.before 10,[2,4,8,12]
      Ok.if 12 == Order.before 99,[2,4,8,12]

    Ok.all.linesDo = (f= the.data + 'weather2.csv',n=0) -> 
      Csv.linesDo f,(-> ++n),(-> Ok.if n==20) 

    Ok.all.csv = (f = the.data + 'weather2.csv',n=0) ->
      new Csv f, (-> ++n), (-> Ok.if n ==15,"bad rows length")

    Ok.all.num1 = ->
      n = new Num
      (n.add x for x in [9,2,5,4,12,7,8,11,9,
                          3,7,4,12,5,4,10,9,6,9,4])
      Ok.if n.mu==7
     
    Ok.all.num2 = ->
      n = new Num
      n.adds([9,2,5,4,12,7,8,11,9,3,
              7,4,12,5,4,10,9,6,9,4], (x) -> 0.1*x)
      Ok.if n.mu==0.7
      Ok.if .30 <= n.sd <=.31

    Ok.all.num3 = ->
      n = new Num
      n.adds([9,2,5,4,12,7,8,11,9,3,
              7,4,12,5,4,10,9,6,9,4], (x) -> 0.1*x)
      Ok.if 0.957 <= n.bin(1.05) <= 0.958
      Ok.if 1.09  <= n.bin(1.3)  <= 1.092
     
    Ok.all.sym = ->
      s= new Sym
      s.adds ['a','b','b','c','c','c','c']
      Ok.if 1.3785 < s.var()<  1.379

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
      worker=(u) ->
        v = u.bins()
        (Ok.if "Sym"==c.constructor.name for c in v.cols)
        v.dump() if dump
      t=(new Table).from(f,worker)

    Ok.all.table2 = -> Ok.all.table1 the.data + 'auto93.csv'
    Ok.all.table3 = -> Ok.all.table1 the.data + 'auto93-10000.csv'

    Ok.all.nearfar = (f=the.data + 'weather4.csv') ->
      worker = (u) ->
        cols = u.x
        for row1 in u.rows
          row2 = u.nearest( row1,cols)
          row3 = u.furthest(row1,cols)

          say ""
          say row1.cells
          say row2.cells, row1.dist(row2, cols)
          say row3.cells, row1.dist(row3, cols)
      t = (new Table).from(f, worker) 

    Ok.all.dist1 = (f=the.data + 'weather4.csv') ->
      worker = (u) ->
        cols = u.x 
        a = u.rows[0]
        b = u.rows[1]
        #say a.dist(b,u.x)
      t = (new Table).from(f, worker)

    Ok.all.fastmap = (f= the.data + 'auto93.csv') ->
      the.seed= 1
      say 222
      worker=(u) ->
        say 111,u.rows[0].id
        f = new FastMap(u)
        f.debug = true
        f.split()
      t = (new Table).from(f,worker)

    Ok.all.bad= -> Ok.if 1 is 2,"deliberate error to check test engine"

    # --------- --------- --------- --------- ---------
    #if "--test" in process.argv then Ok.go()
    #Ok.all.fastmap()
