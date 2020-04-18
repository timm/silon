    {the}  = require './the'
    {say,id}  = require './fun'
    {Ok}   = require './ok'
    {Row}  = require './row'
    {Csv}  = require './csv'
    {Sym}  = require './sym'
    {Some} = require './some'

Table

    class Table
       constructor:        -> [ @cols,@x,@y,@rows ] = [[],[],[],[]]
       klass:              -> @y[0]
       from:(f,after=same) -> new Csv f,((row) => @add row), (=> after(@))
       add:         (l,id) -> @cols.length and @row(l,id) or @top(l,id)
       top:  (l, id,pos=0) -> @cols = (@col(txt,pos++) for txt in l); l
       names:              -> (col.txt for col in @cols)
       dump:               -> say @names(); (say row.cells for row in @rows)
       # --------- --------- --------- --------- ---------  -----------
       mid: -> new Row (c.mid() for c in @cols)
       # --------- --------- --------- --------- ---------  -----------
       clone: (rows=[]) ->
         t=new Table
         t.add (c.txt for c in @cols)
         for row in rows
           t.add row.cells
         t
       # --------- --------- --------- --------- ---------   
       furthest:  (row1,cols,best=0, better=(x,y) -> x>y) ->
         for row2 in @rows
           if id(row1) isnt id(row2)
             tmp = row1.dist(row2,cols)
             if better(tmp,best)
               [ best,out ] = [ tmp,row2 ]
         out
       # --------- --------- --------- --------- ---------   
       nearest: (row1,cols) ->
         @furthest(row1, cols, 10**32, (x,y) -> x < y)
       # --------- --------- --------- --------- ---------   
       row: (l,id) -> 
         l=(col.add( l[col.pos] ) for col in @cols)
         @rows.push(new Row(l,id))
       # --------- --------- --------- ---------
       col: (txt,pos) ->
         what   = if Table.isNum(txt)   then Some else Sym
         where  = if Table.isY(txt)     then @y   else @x
         weight = if the.ch.less in txt then -1   else 1
         c      = new what(txt,pos,weight)
         where.push(c)
         c
       # --------- --------- --------- ---------
       @isNum= (txt) -> switch
         when the.ch.sym  in txt then false
         when the.ch.num  in txt then true
         when the.ch.less in txt then true
         when the.ch.more in txt then true
         else false
       # --------- --------- --------- ---------
       @isY= (txt) -> 
         the.ch.klass in txt or the.ch.less in txt or the.ch.more in txt
       # --------- --------- --------- ---------
       bins: () ->
         t = new Table
         t.add ((the.ch.sym + name) for name in @names())
         for row in @rows
           t.add ( col.bin(row.cells[col.pos]) for col in @cols )
         t

Tests

    Ok.all.tab = {}
    Ok.all.tab.tab1 = (f= the.data + 'weather2.csv',dump=false,n=0) ->
       tab1=(u) ->
         v = u.bins()
         (Ok.if "Sym"==c.constructor.name for c in v.cols)
         v.dump() if dump
         if u.cols[0].counts?
           say u.cols[0].counts
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

Main

    Ok.go "tab" if require.main is module
    @Table = Table
