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
    {the}              = require src+'lib/the'
    {Ok}               = require src+'lib/ok'
    {Table}            = require src+'data/table'
    {FastMap}          = require src+'apps/fastmap'
    {id,int,any,soy,say,s4,
     last,zero1,Order} = require src+'lib/fun'

Test cases

    Ok.all.fmap = {}
    Ok.all.fmap.fastmap = (f=  'auto93.csv',debug=false) ->
       the.seed= 1
       fastmap=(u) ->
         f = new FastMap(u)
         f.debug = debug
         f.split()
         l=[]
         f.leaves((t) -> l.push t)
         for t1 in l
           t1.dom = 0
           for t2 in l
             if t1.mid().dominates( t2.mid(), u.y)
               t1.dom += 1
         l = l.sort(Order.fun (x) -> x.dom)
         best = last(l)
         worst= l[0]
         Ok.if best.mid().dominates(u.mid(), u.y)
         #f.leaves((t) ->  soy " ",t.rows.length); say ""
       t = (new Table).from(the.data+f,fastmap)

    Ok.all.fmap.xfastmap = (f= the.data + 'auto93.csv') ->
       the.seed= 1
       fastmap=(u) ->
         f = new FastMap(u)
         f.debug = false
         f.cols = (t1) -> t1.x
         f.split()
         #f.leaves((t) ->  soy " ",t.rows.length); say ""
       t = (new Table).from(f,fastmap)

    Ok.all.fmap.dom1 = (f="auto93-10000.csv") ->
       dominates = (u) ->
          cache = {}
          for row1 in u.rows
            d=0
            for i in [1..64]
              row2 = any(u.rows)
              if row1.dominates(row2,u.y) 
                d+=1
            cache[ row1.id ] = d
          u.rows = u.rows.sort(Order.fun (x) -> cache[x.id])
          worst  = u.rows[0]
          best   = last(u.rows)
          Ok.if best.dominates(worst, u.y)
       t = (new Table).from(the.data+f,dominates)

###
    Ok.all.fmap.dom2 = ->
      Ok.all.fmap.fastmap("ailerons.csv")
    Ok.all.fmap.fastmap2 = ->
      Ok.all.fmap.fastmap("nasa93.csv",true)
###

    Ok.all.fmap.fastmap3 = ->
      say "\n\nfastmap3"
      Ok.all.fmap.fastmap("auto93.csv",true)

    Ok.go "fmap"
