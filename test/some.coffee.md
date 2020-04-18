<a name=top>&nbsp;<p></a>       
&nbsp;&nbsp;[home](http://tiny.cc/silon#top) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://tiny.cc/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>, Tim Menzies <<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br> [<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://tiny.cc/silon)<br>


    {Ok} = require '../src/ok'
    {Bins} = require '../src/bins'
    {Some} = require '../src/some'
    {d2,int,rand,Order} = require '../src/fun'

Test cases

    Ok.all.some = {}
    Ok.all.some.some1 = ->
       s = new Some
       n = 100000
       for x in (d2(rand(),2) for _ in [1..n]) 
         s.add x
       for x in [0..99] by 10
         m = x/100
         x = s.all()[ int(s.max *m) ]  
         y = s.per(m)
         Ok.if  y-0.01 <= x <= y+0.01
       
    Ok.all.some.some2 = ->
       s = new Some
       n = 100000
       for x in (d2(rand(),2) for _ in [1..n]) 
         s.add x
       b = new Bins(s)
       b.cuts(s)
       Ok.if b.breaks.length == 6
       Ok.if  0.55 <= b.bin(0.6)                 <=  0.56,  .6
       Ok.if 0.82  <= Order.before(200,b.breaks) <=  .825, 200
       Ok.if 0     <= Order.before(-1, b.breaks) <= 1.131,  -1

    Ok.all.some.some3 = ->
       s = new Some
       for i in [1..10]
         for j in [1..4]
           s.add j
       b = new Bins(s)
       b.cuts(s)
       c=  b.breaks
       Ok.if  c[0]==1 and c[2]==3 and c.length==3

    Ok.go "some"
