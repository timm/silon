Imports

     {Ok} = require "../src/ok"
     {Sym}= require "../src/sym"
  
Tests

     Ok.all.sym = {}
     Ok.all.sym.adds = ->
       s= new Sym("<cost")
       Ok.if s.w == - 1
       s.adds ['a','b','b','c','c','c','c']
       Ok.if 1.378 < s.var() < 1.379

     Ok.go "sym"
