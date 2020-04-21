<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>


    src = "../../src/"
    readline  = require 'readline'
    fs        = require 'fs'
    {the}     = require src+'lib/the'
    {last}    = require src+'lib/fun'
    {Ok}      = require src+'lib/ok'
    {Csv}     = require src+'data/csv'
    
    Ok.all.csv = {}
    Ok.all.csv.linesDo= (f= the.data + 'weather2.csv',n=0) ->
       Csv.linesDo f,(-> ++n),(-> n is 20)

    Ok.all.csv.rows = (f = the.data + 'weather2.csv',n=0) ->
       new Csv f, (-> ++n), (-> Ok.if n ==15,"bad rows length")

    Ok.go "csv"
