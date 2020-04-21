<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>


    src="../../src/"
    {the}     = require src+'lib/the'
    {Ok}      = require src+'lib/ok'
    {Nb}      = require src+'apps/nb'
    {id,say}  = require src+'lib/fun'

Test cases

    Ok.all.nb = {}
    Ok.all.nb.one = (f = 'weather4.csv') ->
      nb = (u) ->
        Ok.if 2==Object.keys(u.klasses).length
      t = (new Nb).from(the.data + f, nb)

    Ok.go "nb"
