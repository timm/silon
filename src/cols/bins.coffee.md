<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>

    src = '../../src/'
    {the}             = require src+'lib/the'
    {n,int,say,Order} = require src+'lib/fun'

Unsupervised discretization. Support code for `Some`.

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

Main 

    @Bins = Bins
