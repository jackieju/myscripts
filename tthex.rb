#!/usr/bin/env ruby

# convert string representing decimal number to hex (text to hex)
s = ""
$*.each{|t|
b = t.to_i(10).to_s(16)
p "#{t}=>#{b}"
s += "#{b} "

}
p s
