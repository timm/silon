<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>


    {Ok} = require "../../src/lib/ok"

# Test cases

    Ok.all.ok = {}
    Ok.all.ok.bad= ->
       Ok.if 1 is 2,"deliberate error to check test engine"
    Ok.all.ok.timing = ->
       j=0
       n=0.25*10**9
       for i in [1 .. n]
         j++
       Ok.if j == n

# Main

    Ok.go "ok" 
