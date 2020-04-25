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

     src = "../../src/"
     {the} = require src+"lib/the"
     {any,say} = require src+"lib/fun"
     {Ok} = require src+"lib/ok"
     {Sym}= require src+"cols/sym"
  
Tests

     Ok.all.sym = {}
     Ok.all.sym.adds = ->
       s= new Sym("<cost")
       Ok.if s.w == - 1
       s.adds ['a','b','b','c','c','c','c']
       Ok.if 1.378 < s.var() < 1.379

     Ok.all.sym.inc = ->
       same = (a,b) -> Math.abs(a-b) < 0.0001
       the.seed=1
       n =new Sym
       l = "silontestcolsymcoffeemd".split("")
       [ l,v,mid ] = [ [],{},{} ]
       for j in [1.. 100]
          x = any(l)
          l.push x
          n.add x
          v[j] = n.var()
          mid[j] = n.mid()
          say v[j],n.var()
       j = l.length 
       while j > 5
          j--
          x = l[j]
          n.sub x
          #@Ok/.if  same(v[j],  n.var())
          #@Ok.if  same(mid[j],n.mid())
 
     Ok.go "sym"
