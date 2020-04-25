<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>

# Bins

Supervised discretization. Support code for `Table`.

    src = '../../src/'
    {the}             = require src+'lib/the'
    {n,int,say,Order} = require src+'lib/fun'

Code:
 
    class Bins
       constructor: (lst,x = (z) -> z[0],
                         y = (z) -> last(z),
                         debug=false) ->
         @debug    = debug # show debug information?
         @puny     =  1.05 # ignore puny improvements
         @min      =  0.5  # usually, divide into sqrt(n) size bins
         @cohen    =  0.3  # epsilon = @var()*@cohem
         @maxDepth = 15
         @breaks   = []
         @x        = (z) -> z[0[
         @y        = (z) -> last(z)
         @yis      = Num
         lst       = (z for z in lst when @good(z,x,y))
         @xall     = (new Num).add(lst,x)
         @yall     = (new @yis).add(lst.y)
         lst       = lst.sort(Order.fun x)
         @min      = int(@yall.n ** @min)
         @e        = ys.var() * @cohen
       # --------- --------- --------- ---------   ----------
       good: (z,x,y) ->
         x(z) isnt the.ch.ignore and y(z) isnt the.ch.ignore
       # --------- --------- --------- ---------   ----------
       bin: (x) -> Order.before(x,@breaks)
       # --------- --------- --------- ---------   ----------
       cuts: (lst, xr=xr0,yr=yr0,lo=0,hi=lst.length-1,lvl=0) ->
         if lvl < @maxDepth
           if @debug
             say "| ".n(lvl)+"#{x(lst[lo])} 
                              to #{x(lst([hi])}: #{hi-lo+1}"
           [cut,xr,yr,xl,yl,rhs] = @argmin(lst,xr0,yr0,lo,hi)
           if cut isnt null
             @cuts(lst, xl,yl,    lo, cut, lvl+1)
             @cuts(lst, xr,yr, cut+1,  hi, lvl+1)
           else
             # ignore cutting on last value (no point)
             @breaks.push x(lst[hi]) if hi < lst.length - 1
       # --------- --------- --------- --------- ----------
       argmin: (lst,xr,yr,lo,hi,     cut,xr1,yr1,xl1,yl1) ->
         [xl,xl] = [new Num, new @yis]
         if hi - lo > 2*@min   # enough here to cut in two?
           best = yr.var()     # status quo: what to beat
           for j in [lo .. hi]
             x  = @x( lst[j] ); xl.add x; xr.sub x
             y  = @y( lst[j] ); yl.add y; yr.sub x
             if xl.n > @min and yl.n > @min
               after = @x( lst[j+1] )
               if x isnt after   # only break on differences
                 if (xr.mid() - xl.mid()) > @e #no tiny diff
                   now = yl.xpect(yr)
                   if now * @puny < best   # no puny changes
                     best = now
                     cut  = j
                     [xr1,yr1,xl1,yl1] = \
                           (clone(z) for z in [xr,yr,xl,yl])
         cut,xr1,yr1,xl1,xl1

Exports:

    @Bins = Bins
