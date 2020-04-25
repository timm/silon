<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>


Imports

    src = "../../src"
    {the} = require src+'/lib/the'
    {rand,say} = require src+'/lib/fun'
    {Ok} = require src+'/lib/ok'
    {Num}= require src+'/cols/num'

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

    Ok.all.num.inc = ->
      same = (a,b) -> Math.abs(a-b) < 0.0001
      the.seed=1
      n =new Num
      [ l,v,mid ] = [ [],{},{} ]
      for j in [1.. 100]
         x = rand()
         l.push x
         n.add x
         v[j] = n.var()
         mid[j] = n.mid()
      j = l.length 
      while j > 5
         j--
         x = l[j]
         n.sub x
         Ok.if  same(v[j],  n.var())
         Ok.if  same(mid[j],n.mid())

    Ok.go "num"
