<a name=top>&nbsp;</a><p>       
&nbsp;&nbsp;[home](http://tiny.cc/silon#top) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://tiny.cc/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>, Tim Menzies <<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br> [<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://tiny.cc/silon)<br>


    {Ok} = require "../src/ok"
    {clone,id,last,p2,d2,Order,rand} = require "../src/fun"

    Ok.all.fun = {}
    Ok.all.fun.id  = ->
       [a,b] = [{},{}]
       a1id = id(a)
       b1id = id(b)
       a2id = id(a)
       Ok.if a1id is a2id and a1id isnt b1id

    Ok.all.fun.clone= ->
       b4  = [[1,2], {a: 10, b: 20, c: [3,4,[5,6]]}]
       now = clone(b4)
       b4[1].c[2][1] = 100
       Ok.if  b4[ 1].c[2][1] isnt  now[1].c[2][1]

    Ok.all.fun.sort= ->
       x = [10000,-100,3,1,2,-10,30,15]
       x = x.sort(Order.it)
       Ok.if x[0]  == -100
       Ok.if last(x)   ==   10000

    Ok.all.fun.random = ->
       l= (p2 rand() for _ in [1..100])
       l= l.sort(Order.it)
       Ok.if  2 == l[0]
       Ok.if 98 == last(l)

    Ok.all.fun.bsearch = ->
       l= (d2(rand(),2) for _ in [1..100])
       l.sort(Order.it)
       for i in [0.. l.length - 1] by 20
          j = Order.search(l,l[i])
          Ok.if Math.abs( j - i ) <= 3

    Ok.all.fun.before = ->
       Ok.if  2 == Order.before  0,[2,4,8,12]
       Ok.if  8 == Order.before 10,[2,4,8,12]
       Ok.if 12 == Order.before 99,[2,4,8,12]

Main

    Ok.go "fun"
