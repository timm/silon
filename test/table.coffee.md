<a name=top></a><p>       
&nbsp;[home](https://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](https://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](https://git.io/silon)<br>


    {the} = require '../src/the'
    {say,xray} = require '../src/fun'
    {Ok} = require '../src/ok'
    {Table} = require '../src/table'

Tests

    Ok.all.tab = {}
    Ok.all.tab.tab1 = (f= the.data + 'weather2.csv',dump=false,n=0) ->
       tab1=(u) ->
         v = u.bins()
         (Ok.if "Sym"==c.constructor.name for c in v.cols)
         v.dump() if dump
       t=(new Table).from(f,tab1)

    Ok.all.tab.tab2 = -> Ok.all.tab.tab1 the.data + 'auto93.csv'
    Ok.all.tab.tab3 = -> Ok.all.tab.tab1 the.data + 'auto93-10000.csv'

    Ok.all.tab.nearfar = (f=the.data + 'weather4.csv') ->
       nearfar = (u) ->
         cols = u.x
         for row1 in u.rows
           row2 = u.nearest( row1,cols)
           row3 = u.furthest(row1,cols)
           d12   = row2.dist(row1, u.x)
           d13   = row3.dist(row1, u.x)
           Ok.if  d13 > d12
       t = (new Table).from(f, nearfar) 

    Ok.all.tab.dist1 = (f=the.data + 'weather4.csv') ->
       dist1 = (u) ->
         cols = u.x 
         a = u.rows[0]
         b = u.rows[1]
       t = (new Table).from(f, dist1)

    Ok.go "tab"
