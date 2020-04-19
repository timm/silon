<a name=top></a><p>       
&nbsp;[home](https://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](https://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](https://git.io/silon)<br>


Imports

     {Ok} = require "../src/ok"
     {Sym}= require "../src/sym"
  
Tests

     Ok.all.sym = {}
     Ok.all.sym.adds = ->
       s= new Sym("<cost")
       Ok.if s.w == - 1
       s.adds ['a','b','b','c','c','c','c']
       Ok.if 1.378 < s.var() < 1.379

     Ok.go "sym"
