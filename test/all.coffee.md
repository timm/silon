    {Ok} = require "../src/ok"
    require "./ok"
    require "./csv"
    require "./fun"
    require "./num"
    require "./sym"
    require "./some"
    require "./fastmap"
    require "./table"
    for k,v  of Ok.all
      Ok.go k
