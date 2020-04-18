    readline  = require 'readline'
    fs        = require 'fs'
    {the}     = require '../src/the'
    {last}    = require '../src/fun'
    {Ok}      = require '../src/ok'
    {Csv}     = require '../src/csv'
    
    Ok.all.csv = {}
    Ok.all.csv.linesDo= (f= the.data + 'weather2.csv',n=0) ->
       Csv.linesDo f,(-> ++n),(-> n is 20)

    Ok.all.csv.rows = (f = the.data + 'weather2.csv',n=0) ->
       new Csv f, (-> ++n), (-> Ok.if n ==15,"bad rows length")

    Ok.go "csv"
