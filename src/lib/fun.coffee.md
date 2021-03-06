<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>

# Fun

All my fun little coffeescript tricks

    {the} = require '../../src/lib/the'

Misc

    same   = (x) -> x 
    today  = () -> Date(Date.now()).toLocaleString().slice(0,25)
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
       s = "#{n}"
       l = s.length
       pre = if l < f then " ".n(f - l) else ""
       pre + s

    show= (o) -> ("#{k}: #{v}" for k,v of o).join(", ")
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

    say  = (l...) -> process.stdout.write l.join(", ") + "\n"
    soy  = (l...) -> process.stdout.write l.join(", ")
    sayr = (x, pre="", depth=7,top=true) ->
      if top
        say "" 
      if depth > 0
        if x is null or typeof(x) isnt 'object'
          say pre+x
        else
          for k,v of x
            if k[0] isnt "_"
              if typeof(v) isnt 'object'
                say pre+k+': '+v
              else
                say pre+k+':'
                sayr(v, pre + '|  ', depth-1,false)

    saym = (m, max={})->
      for col,l of transpose((("#{x}".length for x in t) for t in m))
        max[col] = Math.max(...l) 
      for line,t of  m
        say " "+(s4(x,max[col])    for col,x  of t).join(', ')
        if +line == 0
          say "#"+("-".n(max[col]) for col,x of t). join(', ')
 
    transpose = (m) ->
        ((t[i] for t in m) for i in [0...m[0].length])

Lists

    last = (a) -> a[ a.length - 1 ]

    class Order
      @fun = (f)   -> ((x,y) -> Order.it  f(x), f(y))
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

Exports:

    @d2    = d2;    @p2    = p2;    @s4    = s4;   @id    = id;
    @int   = int;   @any   = any;   @say   = say;  @soy   = soy;
    @last  = last;  @rand  = rand;  @same  = same; @xray  = xray;
    @zero1 = zero1; @clone = clone; @Order = Order
    @show  = show;  @sayr  = sayr;  @saym  = saym
