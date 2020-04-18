    {the} = require '../src/the'
    {Ok} = require '../src/ok'
    {Table} = require '../src/table'
    {FastMap} = require '../src/fastmap'
    {id,int,any,soy,say,last,zero1,Order} = require '../src/fun'

Test cases

    Ok.all.fmap = {}
    Ok.all.fmap.fastmap = (f= the.data + 'auto93.csv') ->
       the.seed= 1
       fastmap=(u) ->
         f = new FastMap(u)
         f.debug = false
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
         f.leaves((t) ->  soy " ",t.rows.length)
         say ""
       t = (new Table).from(f,fastmap)

    Ok.all.fmap.xfastmap = (f= the.data + 'auto93.csv') ->
       the.seed= 1
       fastmap=(u) ->
         f = new FastMap(u)
         f.debug = false
         f.cols = (t1) -> t1.x
         f.split()
         f.leaves((t) ->  soy " ",t.rows.length)
         say ""
       t = (new Table).from(f,fastmap)

    Ok.all.fmap.dominates = (f= the.data + 'auto93-10000.csv') ->
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
       t = (new Table).from(f,dominates)

    Ok.go "fmap"