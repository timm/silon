
    {the} = require './the'
    {Col} = require './col'

Storing info about numeric columns.

    class NumThing extends Col
       dist:(x,y) ->
         if x is the.ch.ignore and y is the.ch.ignore
           return 1
         if x is the.ch.ignore
           y1 = @norm1 y
           x1 = y1 > 0.5 and 0 or 1
         else
           if y is the.ch.ignore
              x1 = @norm1 x
              y1 = x1 > 0.5 and 0 or 1
           else
             x1 = @norm1 x
             y1 = @norm1 y
         Math.abs(x1-y1)

    @NumThing = NumThing
