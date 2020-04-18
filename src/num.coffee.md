    {the}   = require './the'
    {Ok}    = require './ok'
    {Order} = require './fun'
    {NumThing} = require './numthing'

Collection of numbers.

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
       # ---------  --------- --------- ---------
       bin1: (x) ->
         z = (x - @mu)/ (the.tiny + @sd0())
         z = Order.before(z,[-1.28,-.84,-.52,-.25,0,
                               .25, .52, .84,1.28])
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

Tests 

    Ok.all.num = {}
    Ok.all.num.num1 = ->
       n = new Num
       (n.add x for x in [9,2,5,4,12,7,8,11,9,
                           3,7,4,12,5,4,10,9,6,9,4])
       Ok.if n.mu==7

    Ok.all.num.num2 = ->
       n = new Num
       n.adds([9,2,5,4,12,7,8,11,9,3,
               7,4,12,5,4,10,9,6,9,4], (x) -> 0.1*x)
       Ok.if n.mu==0.7
       Ok.if .30 <= n.sd <=.31

    Ok.all.num.num3 = ->
       n = new Num
       n.adds([9,2,5,4,12,7,8,11,9,3,
               7,4,12,5,4,10,9,6,9,4], (x) -> 0.1*x)
       Ok.if 0.957 <= n.bin(1.05) <= 0.958
       Ok.if 1.09  <= n.bin(1.3)  <= 1.092

Main

Ok.go "num" if require.main is module
@Num = Num
