require("json")
#p $*

fname = $*[0]

if !fname
	print "convert ruby hash to json\n"
	return 
end

data= nil  

if FileTest::exists?(fname) 
   
    open(fname, "r") {|f|
           data = f.read
    }
    
else
	p "file #{fname} not exists"
end

#p "data:#{data}"
a = eval("#{data}")

#p a.inspect
print a.to_json
