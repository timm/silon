<a name=top>&nbsp;<p></a>       
[home](http://tiny.cc/silon#top) |
[src](https://github.com/timm/silon/raw/master/src) | 
[issues](http://tiny.cc/silon) |
<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>
<br> [<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://tiny.cc/silon)<br>


    readline  = require 'readline'
    fs        = require 'fs'
    {the}     = require '../src/the'
    {last}    = require '../src/fun'
    {Ok}      = require '../src/ok'
    {Csv}     = require '../src/csv'
    
    Ok.all.csv = {}
    Ok.all.csv.linesDo= (f= the.data + 'weather2.csv',n=0) ->
       Csv.linesDo f,(-> ++n),(-> n is 20)

    Ok.all.csv.rows = (f = the.data + 'weather2.csv',n=0) ->
       new Csv f, (-> ++n), (-> Ok.if n ==15,"bad rows length")

    Ok.go "csv"
