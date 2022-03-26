#!/usr/bin/env ruby

s = ""
$*.each{|t|
b = t.to_i(10).to_s(16)
p "#{t}=>#{b}"
s += "#{b} "

}
p s
