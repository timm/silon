Imports

    {the} = require "./the"

Standard functions

    @same   = (x) -> x 
    @today  = () -> Date(Date.now()).toLocaleString().slice(0,25)
    #abort  = throw new Error('bye')
    @sum    = (l,f=@same,n=0) -> (n+=f(x) for x in l); n

    @int =  Math.floor
    @id  = (x) ->
      x.__id = ++the.id unless x.__id?
      x.__id

    @rand=  ->
        x = Math.sin(the.seed++) * 10000
        x - @int(x)

    @any= (l) ->  l[ @int(@rand()*l.length) ] 
    @d2= (n,f=2) ->  n.toFixed(f)
    @p2= (n,f=2) ->  Math.round(100*d2(n,f))
    @s4= (n,f=4) ->
       s = n.toString()
       l = s.length
       pre = if l < f then " ".n(f - l) else ""
       pre + s

    @xray= (o) -> @say ""; (@say "#{k} = #{v}"  for k,v of o)

    @zero1= (x) -> switch
       when x<0 then 0
       when x>1 then 1
       else x

    @clone = (x) -> # deepCopy
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

    @say = (l...) -> process.stdout.write l.join(", ") + "\n"

Lists

    @last = (a) -> a[ a.length - 1 ]

    class @Order
      @fun = (f)   -> ((x,y) -> @Order.it  f(x), f(y))
      @key = (key) -> ((x,y) -> @Order.fun (z) -> z[key])
      @it  = (x,y) -> switch
        when x <  y then -1
        when x == y then  0
        else 1
      @search = (lst,val,f=((z) -> z)) ->
        [lo,hi] = [0, lst.length - 1]
        while lo <= hi
          mid = @int((lo+hi)/2)
          if f( lst[mid] ) >= val
            hi = mid - 1
          else
            lo = mid + 1
        Math.min(lo,lst.length-1)
      @before = (x,lst, y=lst[0]) ->
        for z in lst
          if z>x then break else y=z
        y

    x=  [10,20,30]
    x.sort(@Order.fun((x) -> -1*x))
    @say x

