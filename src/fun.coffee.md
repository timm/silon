    {the} = require "./the"
    {Ok}  = require "./ok"

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
    soy = (l...) -> process.stdout.write l.join(", ")

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

# Test cases

    Ok.all.fun = {}
    Ok.all.fun.id  = ->
       [a,b] = [{},{}]
       a1id = id(a)
       b1id = id(b)
       a2id = id(a)
       Ok.if a1id is a2id and a1id isnt b1id

    Ok.all.fun.clone= ->
       b4  = [[1,2], {a: 10, b: 20, c: [3,4,[5,6]]}]
       now = clone(b4)
       b4[1].c[2][1] = 100
       Ok.if  b4[ 1].c[2][1] isnt  now[1].c[2][1]

    Ok.all.fun.sort= ->
       x = [10000,-100,3,1,2,-10,30,15]
       x = x.sort(Order.it)
       Ok.if x[0]  == -100
       Ok.if last(x)   ==   10000

    Ok.all.fun.random = ->
       l= (p2 rand() for _ in [1..100])
       l= l.sort(Order.it)
       Ok.if  2 == l[0]
       Ok.if 98 == last(l)

    Ok.all.fun.bsearch = ->
       l= (d2(rand(),2) for _ in [1..100])
       l.sort(Order.it)
       for i in [0.. l.length - 1] by 20
          j = Order.search(l,l[i])
          Ok.if Math.abs( j - i ) <= 3

    Ok.all.fun.before = ->
       Ok.if  2 == Order.before  0,[2,4,8,12]
       Ok.if  8 == Order.before 10,[2,4,8,12]
       Ok.if 12 == Order.before 99,[2,4,8,12]

Main

    Ok.go "fun" if require.main is module
    @same  =same
    @int   = int
    @rand  = rand
    @any   = any
    @d2    = d2
    @p2    = p2
    @s4    = s4
    @xray  = xray
    @zero1 = zero1
    @clone = clone
    @say   = say
    @soy   = soy
    @last  = last
    @Order = Order
