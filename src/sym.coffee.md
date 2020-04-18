    {the} = require './the'
    {Ok}  = require './ok'
    {Col} = require './col'

Storing info about symbolic  columns.

    class Sym extends Col
       constructor: (args...) ->
         super args...
         [ @counts,@most,@mode,@_ent ] = [ [],0,null,null ]
       # ---------  --------- --------- ---------
       mid:    () -> @mode
       var:    () -> @ent()
       norm1: (x) -> x
       toString:  -> "Sym{#{@txt}:#{@mode}}"
       bin1:  (x) -> x
       big:   (n) -> t
       dist:(x,y) ->
         if x is the.ch.ignore and y is the.ch.ignore
            return 1
         if x == y then  0 else  1

       # ---------  --------- --------- ---------
       add1: (x) ->
         @_ent = null
         @counts[x] = 0 unless x of @counts
         n = ++@counts[x]
         [ @most,@mode ] = [ n,x ] if n > @most
       # ---------  --------- --------- ---------
       ent: (e=0)->
         if  not @_ent?
           @_ent = 0
           for x,y of @counts
             p      = y/@n
             @_ent -= p*Math.log2(p)
         @_ent

Tests

    Ok.all.sym = {}
    Ok.all.sym.adds = ->
       s= new Sym("<cost")
       Ok.if s.w == - 1
       s.adds ['a','b','b','c','c','c','c']
       Ok.if s.var() == 1.375

Main

    Ok.go "sym" if require.main is module
    @Sym = Sym

