<a name=top>&nbsp;</a><p>       
&nbsp;&nbsp;[home](http://tiny.cc/silon#top) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://tiny.cc/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>, Tim Menzies <<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br> [<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://tiny.cc/silon)<br>


    {the}   = require '../src/the'
    {Order} = require '../src/fun'
    {NumThing} = require '../src/numthing'

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

Exports

    @Num = Num
