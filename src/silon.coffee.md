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
      test:
        tries: 0
        fails: 0
      ch:
        num: '$'
        more: '>'
        less: '<'
        klass: '!'
        ignore: '?'
    
## Standard Stuff

### Standard Constants

    ninf   = -1 * (Number.MAX_SAFE_INTEGER - 1)
    inf    = Number.MAX_SAFE_INTEGER
    tiny   = 10 ** (-32)

### Standard functions.

Misc

    same   = (x) -> x 
    today  = () -> Date(Date.now()).toLocaleString().slice(0,25)

Lists

    first = (a) -> a[0]
    last  = (a) -> a[ a.length - 1 ]

    keysort = (key) ->
      (x,y) -> funsort (z) -> z[key]

    funsort = (f) ->
      (x,y) -> sorter f(x), f(y)

    sorter = (x,y) -> switch
      when x <  y then -1
      when x == y then  0
      else 1
      
    bsearch = (lst,val,f=((z) -> z)) ->
      [lo,hi] = [0, lst.length - 1]
      while lo <= hi
        mid = Math.floor((lo+hi)/2)
        if f( lst[mid] ) >= val
          hi = mid - 1
        else
          lo = mid + 1
      Math.min(lo,lst.length-1) 

Strings

    String::last = -> this[ this.length - 1]
    String::n    = (m=40) -> Array(m+1).join(this)

    say = (l...) ->
      sep=""
      for x in l
        process.stdout.write sep+x
        sep=", "
      process.stdout.write "\n" 

Maths

    rand=  ->
        x = Math.sin(the.seed++) * 10000
        x - Math.floor(x)

     d2= (n,f=2) ->  n.toFixed(f)
     p2= (n,f=2) ->  Math.round(100*d2(n,f))
     s4= (n,f=4) ->
       s = n.toString()
       l = s.length
       pre = if l < f then " ".n(f - l) else ""
       pre + s

Unit tests

    assert = (f,t) -> throw new Error t or "" if not f

For each line do ...

    lines = ( file, action, done = (-> ) ) ->  
      stream = readline.createInterface
        input:    fs.createReadStream file
        output:   process.stdout
        terminal: false
      stream.on 'close',           -> done()
      stream.on 'error', ( error ) -> action error
      stream.on 'line',  ( line  ) -> action line 

Csv files

    class Csv
      constructor: (file, action, over) ->
        @use     = null
        @lines    = []
        @action  = action
        lines file, @line, over or ->
      line: (s) =>
        if s
          s = s.replace /\s/g,''
          s = s.replace /#.*/,''
          @merge s if s.length
      merge: (s) ->
        @lines.push s
        if s.last() isnt ','
          @act @lines.join().split ','
          @lines = []
      act: (cells) ->
        if cells.length
          @use or= (i for c,i in cells when the.ch.ignore not in c)
          @action (@prep cells[i] for i in @use)
      prep: (s) ->
        t = +s
        if Number.isNaN(t) then s else t

## Tables

### Columns

Storing info about a column.

    class Col
      constructor:(txt,pos,w=1) -> [@n,@w,@pos,@txt]=[0,w,pos,txt]
      norm: (x) -> if x isnt the.ch.ignore then @norm1 x else x
      #---------------------
      add: (x) ->
         if x isnt the.ch.ignore
           @n++
           @add1 x
         x
      #---------------------
      adds: (a,f=same) ->
         (@add f(x) for x in a)
         this
      #---------------------
      xpect: (that) ->
        n = this.n + that.n
        this.n/n * this.var() + that.n/n * that.var()

Storing info about symbolic  columns.

    class Sym extends Col
      constructor: (args...) ->
        super args...
        [ @counts,@most,@mode,@_ent ] = [ [],0,null,null ]
      #------------------------
      mid:    () -> @mode
      var:    () -> @ent()
      norm1: (x) -> x
      toString:  -> "Sym{#{@txt}:#{@mode}}"
      #-------------------------
      add1: (x) ->
        @_ent = null
        @counts[x] = 0 unless x of @counts
        n = ++@counts[x]
        [ @most,@mode ] = [ n,x ] if n > @most
      #-------------------------
      ent: (e=0)->
        unless @_ent?
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
        [ @hi, @lo ]    = [ ninf, inf ]
      #-------------------------
      mid:    () -> @mu
      var:    () -> @sd
      norm1: (x) -> (x - @lo) / (@hi - @lo +  _.tiny)
      toString:  -> "Num{#{@txt}:#{@lo}..#{@hi}}"
      #-------------------------
      add1: (x) ->
        @lo   = if x < @lo then x else @lo
        @hi   = if x > @hi then x else @hi
        delta = x - @mu
        @mu  += delta / @n
        @m2  += delta * (x - @mu)
        @sd   = @sd0()
      #-------------------------
      sd0: () -> switch
        when  @n < 2  then 0
        when  @m2 < 0 then 0
        else (@m2 / (@n - 1))**0.5

Storing info about numeric  columns (resevoir style):
    
    class Some extends Col
      constructor: (args...) ->
        super args...
        @good  = false # is @_all sorted?
        @_all  = []    # where to keep things
        @max   = 256   # keep no more than @max items
        @small = 0.147 # used in cliff's delta
        @magic = 2.564 # sd = (90th-10th)/@magic
                       # since 90th z-curve percentile= 1.282
      #----------------------
      mid: (j,k) -> @per(.5,j,k)
      var: (j,k) -> (@per(.9,j,k) - @per(.1,j,k)) / @magic
      iqr: (j,l) -> @per(.75,j,k) - @per(.25,j,k)
      toString:  -> "Some{#{@txt}:#{@mid()}}"
      norm1: (x) -> @all(); (x -  @_all[0])/
                            (@_all.last() - @_all[0]+10**(-32)) 
      #--------------------
      per: (p=0.5,j=0,k=(@_all.length)) ->
         @all()[ Math.floor(j+p*(k-j)) ]
      #----------------------
      all: ->
        @_all.sort(sorter) if not @good
        @good = true
        @_all
      #--------------------
      cuts: (debug=false) -> 
        b = new Bins(this)
        b.debug = debug
        b.cuts(this)
      #----------------------
      add1: (x) ->
        if @_all.length  <= @max
          @good = false
          @_all.push(x)
        else
          @all()
          if rand() < @max/@n
            @_all[ bsearch(@_all,x) ] = x

Unsupervised discretization.

    class Bins
      constructor: (s) ->
        s.all()
        @debug    = false # show debug information?
        @puny     =  1.05 # ignore puny improvements
        @min      =  0.5  # usually, divide into sqrt(n) size bins
        @cohen    =  0.3  # epsilon = @var()*@cohem
        @maxDepth = 15
        @min      = Math.floor(s._all.length**@min)
        @e        = s.var() * @cohen
        @entropy  = 0
      #-----------------------------------------------------
      cuts: (s, lo=0, hi=s._all.length-1, lvl=0, out=[]) ->
        if lvl < @maxDepth 
          if @debug
            say "| ".n(lvl)+"#{s._all[lo]} to #{s._all[hi]}: #{hi-lo+1}"
          cut = @argmin(s,lo,hi)
          if cut isnt null
            @cuts(s, lo,   cut, lvl+1, out)
            @cuts(s, cut+1, hi, lvl+1, out)
          else
            p = (hi - lo)/s._all.length
            @entropy -= p*Math.log2(p)
            out.push s._all[hi] 
        out
      #------------------------------
      argmin: (s,lo,hi,cut=null) ->
        if hi - lo > 2*@min 
          best = s.var(lo,hi)
          for j in [lo+@min .. hi-@min]
            x     = s._all[j]
            after = s._all[j+1]
            if x isnt after
              below = s.mid(lo,j)
              above = s.mid(j+1,hi)
              if (above - below) > @e
                now = @xpect(s,lo,j,hi)
                if now * @puny < best
                  best = now
                  cut  = j
        cut
      #-------------------------------------------------------
      xpect: (s,j, m, k) ->
        (tiny + (m-j)*s.var(j,m) + (k-m-1)*s.var(m+1,k))/(k-j+1)
            
## Rows

    class Row
      constructor: (l) -> [ @cells,@id ]=[ l,++the.id ]

## Table

    class Table
      constructor:      -> [ @cols,@x,@y,@rows ] = [[],[],[],[]]
      klass:            -> @y[0]
      from:(f,after=->) -> new Csv f,((row) => @add row),after
      add:          (l) -> @cols.length and @row(l) or @top(l)
      top:   (l, pos=0) -> @cols = (@col(txt,pos++) for txt in l)
      clone:         () -> t=new Table; t.add (c.txt for c in @cols); t
      #----------------------------------------------------------------
      row: (l) -> 
        l=(col.add( l[col.pos] ) for col in @cols)
        @rows.push(new Row(l))
      #----------------
      col: (txt,pos) ->
        what = if nump(txt) then Some else Sym
        also = if yp(txt)   then @y   else @x
        c    = new what(txt,pos)
        c.w  = -1   if the.ch.less  in txt
        also.push(c)
        c
      #---------------
      xnums: -> (c for c in @x when     nump(c.txt))
      xsyms: -> (c for c in @x when not nump(c.txt))

    nump= (txt) -> the.ch.num  in txt or
                   the.ch.less in txt or
                   the.ch.more in txt

    yp= (txt) -> the.ch.klass in txt or
                 the.ch.less  in txt or
                 the.ch.more  in txt
## Silo

    class @KOD # k-object-dimensional tree
      constructor: (t) ->
        @t = t
        @top = t.cols
        @split(@rank())
      rank: (l) ->
        l1 = ([c.var(),c] for c in l)
        l2 = l1.sort(sorter).reverse()
        (one[1] for one in l2)
      tree: () ->
        for col in @rank(@t.y)
          say col.txt, col.cuts()

## Test Engine

    oks = (lst = ok) ->
      okWorker = (name,f) ->
        fyi= () -> 
          a= the.test.tries
          b= the.test.fails
          c= Math.round(100*(a-b)/a)
          "#{s4(a)} #{s4(name,12)} #{s4(b,3)} 
           failed #{s4(c,3)} %passed"
        try
            the.test.tries++
            the.seed = 1
            await (f(); say fyi())
        catch error
            the.test.fails++
            l = error.stack.split('\n')
            say l[0]
            say l[2..5].join("\n")
            say fyi()
      (await okWorker name,f for name,f of lst)
 
Tests

    ok={}

    ok.bad= -> assert 1 is 2,"deliberate error to check test engine"

    ok.sort = ->
      x = [10000,-100,3,1,2,-10,30,15]
      y = x.sort(sorter)
      assert x[0]  == -100
      assert x[x.length-1]  ==   10000

    ok.keysort = ->
      l = ({a: n,b: -1*n} for n in [20..1])
      l.sort(keysort "b")
      assert first(l).b == -20
      assert last(l).a  == 1

    ok.random = ->
      l= (p2 rand() for _ in [1..100])
      l= l.sort(sorter)
      assert  2 == l[0]
      assert 98 == l[ l.length - 1 ]
    
    ok.bsearch = ->
      l= (d2(rand(),2) for _ in [1..100])
      l.sort(sorter)
      for i in [0.. l.length - 1] by 20
         j = bsearch(l,l[i])
         assert Math.abs( j - i ) <= 3

    ok.lines = (f= the.data + 'weather2.csv',n=0) -> 
      lines f,(-> ++n),(-> assert n==20) 
    
    ok.csv = (f = the.data + 'weather2.csv',n=0) ->
      new Csv f, (-> ++n), (-> assert n ==15)
   
    ok.num1 = ->
      n = new Num
      (n.add x for x in [9,2,5,4,12,7,8,11,9,
                          3,7,4,12,5,4,10,9,6,9,4])
      assert n.mu==7
     
    ok.num2 = ->
      n = new Num
      n.adds([9,2,5,4,12,7,8,11,9,3,
              7,4,12,5,4,10,9,6,9,4], (x) -> 0.1*x)
      assert n.mu==0.7
      assert .30 <= n.sd <=.31
    
    ok.sym = ->
      s= new Sym
      s.adds ['a','b','b','c','c','c','c']
      assert 1.3785 < s.var()<  1.379

     ok.some1 = ->
      s = new Some
      n = 100000
      for x in (d2(rand(),2) for _ in [1..n])
        s.add x
      for x in [0..99] by 10
        m = x/100
        x = s.all()[Math.floor(s.max *m)]
        y = s.per(m)
        assert  y-0.01 <= x <= y+0.01
      c= s.cuts()
      assert c.length == 7
      assert 0.375 <= c[2] <= 0.385
      assert 0.815 <= c[5] <= 0.825

    ok.some2 = ->
      s = new Some
      for i in [1..10]
        for j in [1..4]
          s.add j
      c= s.cuts()
      assert  c[0]==1 and c[3]==4 and c.length==4

    ok.table = (f= the.data + 'weather2.csv',n=0) ->
      pos=0

      worker=(u) ->
        for c in u.cols
          say c.pos, c.txt
      t=new Table
      t.from(f,same,-> worker t)
    #--------------------------------------------------
    #if "--test" in process.argv then oks()
    ok.table()
