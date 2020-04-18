    {id} = require '../src/fun'

# Row

    class Row
       constructor: (@cells,@id) ->
         @id or= id(@)
       dist: (that, cols, p=2, n=0, d=0) ->
         for c in cols
           n++
           x  = this.cells[c.pos]
           y  = that.cells[c.pos]
           d0 = c.dist(x,y)
           d += d0**p
         (d / n) ** (1/p)
       dominates: (that, cols) ->
         [ s1,s2,n ] = [ 0,0,cols.length ]
         for c in cols
           x   = this.cells[c.pos]
           y   = that.cells[c.pos]
           x1   = c.norm(x)
           y1   = c.norm(y)
           s1 -= 10**(c.w*(x1-y1)/n)
           s2 -= 10**(c.w*(y1-x1)/n)
         s1/n < s2/n

     @Row = Row