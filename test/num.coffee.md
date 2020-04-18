Imports

    {Ok} = require "../src/ok"
    {Num}= require "../src/num"

Tests 

    Ok.all.num = {}
    Ok.all.num.num1 = ->
       n = new Num
       (n.add x for x in [9,2,5,4,12,7,8,11,9,
                           3,7,4,12,5,4,10,9,6,9,4])
       Ok.if n.mu==7

    Ok.all.num.num2 = ->
       n = new Num
       n.adds([9,2,5,4,12,7,8,11,9,3,
               7,4,12,5,4,10,9,6,9,4], (x) -> 0.1*x)
       Ok.if n.mu==0.7
       Ok.if .30 <= n.sd <=.31

    Ok.all.num.num3 = ->
       n = new Num
       n.adds([9,2,5,4,12,7,8,11,9,3,
               7,4,12,5,4,10,9,6,9,4], (x) -> 0.1*x)
       Ok.if 0.957 <= n.bin(1.05) <= 0.958
       Ok.if 1.09  <= n.bin(1.3)  <= 1.092

    Ok.go "num"
