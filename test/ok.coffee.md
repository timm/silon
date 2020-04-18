    {Ok} = require "../src/Ok"

# Test cases

    Ok.all.ok = {}
    Ok.all.ok.bad= ->
       Ok.if 1 is 2,"deliberate error to check test engine"
    Ok.all.ok.timing = ->
       j=0
       n=0.25*10**9
       for i in [1 .. n]
         j++
       Ok.if j == n

# Main

    Ok.go "ok" 

