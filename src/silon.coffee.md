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

     d2= (n,f=2) ->  n.toFixed(f)
     p2= (n,f=2) ->  Math.round(100*d2(n,f))
     s4= (n,f=4) ->
       s = n.toString()
       l = s.length
       pre = if l < f then " ".n(f - l) else ""
       pre + s

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
      bin1: (x)  -> x
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

    class Num extends Col
      constructor: (args...) ->
        super args...
        [ @mu,@m2,@sd ] = [ 0,0,0,0 ]
        [ @hi, @lo ]    = [ the.ninf, the.inf ]
      # ---------  --------- --------- ---------
      mid:    () -> @mu
      var:    () -> @sd
      norm1: (x) -> (x - @lo) / (@hi - @lo + the.tiny)
      toString:  -> "Num{#{@txt}:#{@lo}..#{@hi}}"
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
    
    class Some extends Col
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
      iqr: (j,l) -> @per(.75,j,k) - @per(.25,j,k)
      toString:  -> "Some{#{@txt}:#{@mid()}}"
      norm1: (x) -> @all(); (x -  @_all[0])/
                            (last(@_all) - @_all[0]+10**(-32)) 
      # --------- --------- --------- -----------------
      per: (p=0.5,j=0,k=(@_all.length)) ->
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
      constructor: (@cells) ->  

## Table

    class Table
      constructor:       -> [ @cols,@x,@y,@rows ] = [[],[],[],[]]
      klass:             -> @y[0]
      from:(f,after=same)-> new Csv f,((row) => @add row), (=> after(@))
      add:          (l)  -> @cols.length and @row(l) or @top(l)
      top:   (l, pos=0)  -> @cols = (@col(txt,pos++) for txt in l); l
      clone:         ()  -> t=new Table; t.add (c.txt for c in @cols); t
      names:             -> (col.txt for col in @cols)
      dump:              -> say @names(); (say row.cells for row in @rows)
      # --------- --------- --------- --------- ---------   -----------
      row: (l) -> 
        l=(col.add( l[col.pos] ) for col in @cols)
        @rows.push(new Row(l))
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

###

    class KdTree
      constructor: (t, colsfun,min=  t.rows.length**0.5, lvl=  0) ->
        [ @here,@min,@lvl,@kids ]  = [t,min.lvl,[] ]
        @div colsfun
      # --------- --------- --------- ---------
      wasNum: (txt) -> switch
        when the.ch.num  in txt then true
        when the.ch.less in txt then true
        when the.ch.more in txt then true
        else false
      another: (k) ->
        t     = @here.clone()
        t.key = k
        t
      div: (colsfun) ->
        pre  = "=".n(lvl)
        tmp  = {}
        cols = colsfun(@here)
        cols = cols.sort(Order.fun (x) -> -1*x.vars())
        col  = cols[0]
        for row in @here.rows
          k = row.cells[col.pos]
          if k isnt the.ch.skip
            tmp[k] = @another(k) unless k of tmp
            tmp[k].add row.cells
        l = (t for k,t of tmp).sort(Order.fun (z) -> z.key)
        if @wasNum()
          [ one,two ] = [ @another(0),@another(1) ]
          [ now,key ] = [ one,null ]
          for t,i in l
            if i>0
              if one.rows.length + t.rows.length > @here.rows.length /2
                key = t.key if not key?
                now = two
            for row in t.rows
              now.add row.cells
          # start .. stop
          one.use = ((row) -> row.cells[col.pos] <  key)
          two.use = ((row) -> row.cells[col.pos] >= key)
          @kids = [one, two]
        else
          # start .. stop
          # lowest one  start is ninf
          # highest is stop is inf
          # parent might be the end noode
          # running down keep start..stop
          # dont do tables till we divide the numbers
          for t in l # holes in the discrete
            if t.rows.length >= @min
              now = t
              now.use = ((row) -> row.cells[pos] <= t.key)
            else
              for row in t.rows
                now.use = ((row) -> row.cells[pos] <= t.key)
                now.add row.cells
          @kids = l
        for k,t of tmp
          if t.rows.length < @here.rows.length
            if t.rows.length >= @min
              @kids[k]= new KdTree(t,min=min,axes=axes,n=n-1,lvl=lvl+1)
 
    class Tree
      nodes: ->
        unless @here.rows.length < @min
          yield @
          for _,kid of @kids
            for x from  kid.nodes()
              yield x
      # --------- --------- --------- --------- 
      isLeaf: -> 
         Object.keys(@kids).length == 0
      # --------- --------- --------- ---------
      show: (pre="") ->
        unless @isLeaf()
          say s4(id(@))  + ": " + pre + "[#{@here.rows.length}]"
          for k,kid of @kids
            kid.show(pre + "|.. ")
###

     
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
          process.stdout.write "#{s4(a)}) #{s4(c,3)} 
                               %passed after failures= #{b} "
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
        #say ""
        #(say col.txt,col.var() for  \
        #   col in v.cols.sort(Order.fun (x) -> -1*x.var()))
      t=(new Table).from(f,worker)

    Ok.all.table2 = -> Ok.all.table1 the.data + 'auto93.csv'
    Ok.all.table3 = -> Ok.all.table1 the.data + 'auto93-10000.csv'

###
    Ok.all.kdtree = (f= the.data + 'auto93.csv') ->
      worker=(u) ->
        v = u.bins()
        k = new KdTree(v,min=20)
        k.show()
        for node from k.nodes() 
            say ("|.. ".n(node.lvl)), node.here.rows.length
      t=(new Table).from(f,worker)
###

    Ok.all.bad= -> Ok.if 1 is 2,"deliberate error to check test engine"

    # --------- --------- --------- --------- ---------
    #if "--test" in process.argv then Ok.go()
