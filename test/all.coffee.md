<a name=top>&nbsp;<p></a>       
[home](http://tiny.cc/silon#top) |
[src](https://github.com/timm/silon/raw/master/src) | 
[issues](http://tiny.cc/silon) |
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>, Tim Menzies <a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>
<br> [<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://tiny.cc/silon)<br>


    {Ok} = require "../src/ok"
    require "./ok"
    require "./csv"
    require "./fun"
    require "./num"
    require "./sym"
    require "./some"
    require "./fastmap"
    require "./table"
    for k,v  of Ok.all
      Ok.go k
