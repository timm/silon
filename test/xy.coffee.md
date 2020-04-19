<a name=top></a><p>       
&nbsp;[home](https://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](https://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](https://git.io/silon)<br>


    {the}   = require '../src/the'
    {Ok}    = require '../src/ok'
    {Xy}    = require '../src/xy'
    {Sym}   = require '../src/sym'
    {Table} = require '../src/table'
    {id,int,any,soy,say,
     last,zero1,Order,show} = require '../src/fun'

Test cases

    Ok.all.xy = {}
    Ok.all.xy.xy1 = (f= 'auto93.csv') ->
      xy1=(u) ->
        xy = new Xy(u)
        xy.split()
        [xs,ys] = [{},{}]
        xy.x.leaves((x1) -> (xs[r.id] = id(x1) for r in x1.rows))
        xy.y.leaves((y1) -> (ys[r.id] = id(y1) for r in y1.rows))
        [xc,yc] = [{},{}]
        for i,xcluster of xs
          xc[xcluster] = new Sym unless xcluster in xc
          xc[xcluster].add ys[i]
        for i,ycluster of ys
          yc[ycluster] = new Sym unless ycluster in yc
          yc[ycluster].add xs[i]
        for ycluster,ySome of yc
          for xcluster,v of ySome.counts
            say f,"yWithX", ycluster, xcluster,v
        say ""
        for xcluster,xSome of xc
          for ycluster,v of xSome.counts
            say f,"xWithY", xcluster, ycluster,v
      t = new Table
      t.from(the.data+f, xy1)

    Ok.all.xy.xy2 = (f=  'auto93.csv') ->
      xy2=(u) ->
        say ""
        xy = new Xy(t)
        xy.split().doms()
        for zid1,o1 of xy.split().doms()
          say o1.z.rows.length, o1.doms,\
             (o1.rule.cells[c.pos] for c in o1.z.y),f
      t = new Table
      t.from(the.data+f,xy2)

    Ok.all.xy.xy3 = () ->
      Ok.all.xy.xy1 'nasa93.csv'
      Ok.all.xy.xy2 'nasa93.csv'

    Ok.all.xy.xy4 = () -> 
      Ok.all.xy.xy1  'china.csv'
      Ok.all.xy.xy2 'china.csv'

    Ok.go "xy"
