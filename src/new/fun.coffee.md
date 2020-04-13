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

