#!/usr/local/bin/ruby
require 'find'
$g_count = 0
$g_count_comment = 0
$g_count_files = 0
$g_match_count = []
$ref = []
$file_pattern = Regexp.new("\\.(c|cpp|h|hpp)$", true)   
$file_pattern = Regexp.new("\\.(php)$", true)   
 
def do_count(fname, re = nil)
    
    _count_comment = 0 # comments
    _match_count = [] # number of lines match re
    _count = 0 # code line
    
        p "filename=#{fname}"
        # read out content
        content = ""
        file=File.open(fname,"r")  
        t = nil      
        
        count = 0
        file.each_line do |line|
            if line =~ /^\s*\/\//
		        _count_comment +=1
               next 
            end
#p $g_count
            count +=1
#p "line=#{line}"
            content += line
        end
        # process /* */
        content.scan(/\/\*(.*?)\*\//m){|m|
           # p "==>"+m.inspect
	       m[0].each_line do |ln|
		       count -= 1
               _count_comment +=1
	       end
        }
        content.gsub!(/\/\*(.*?)\*\//m, "")
        if re &&re != ""
        #    re = /<div class="conBox_c"> <span class="name"><a title=".*?" uid="(.*?)" href/
        content.each_line{|ln|
    	    ln.scan(re){|m|
    	        p "match:#{m.inspect}"
    	        _match_count.push({
    	            :file=>fname,
    	            :line=>ln
    	        })
    	    }
	    }
        end
	    
	    $g_match_count += _match_count
	    
	    _count += count
        p "#{count} lines" 

        $g_count_files += 1
        $g_count += _count 
        $g_count_comment += _count_comment  
        
        return [_count_comment, _match_count.size, _count]
    
end
def scan_count(dir, r)
    ret = {
        :path=>dir,
        # :line =>0,
        :code =>0,  
        :comment =>0,
        :match=>0,
        :subs => {},
        :tcode=>0,
        :fcount=>0,
        :tfcount=>0,
    }
    p "search #{dir}..."
    p "$file_pattern: #{$file_pattern}"
    fcount = dcount = 0
    Dir.foreach("#{dir}") do |item|
    # Find.find("#{dir}/*") do |item|
        # p "item #{item}"
      next if item == '.' or item == '..'
      fname = "#{dir}/#{item}"
      if File.file?(fname)
         p "file  #{fname}"
         fcount +=1 
         if item =~ $file_pattern 
         #if item =~ /\.(c|cpp|h|hpp)$/i      
             comments,match,code = do_count(fname, r)
             # ret[:line] += code
                ret[:code] +=  code
                ret[:comment] += comments
                ret[:match] += match
                
         end
      elsif File.directory?(fname)
          dcount +=1
          p "dir >> #{fname}"
          _ret = scan_count("#{fname}", r)
          if _ret[:tcode] > 0
              ret[:subs][item.to_s] = _ret 
              _ret[:parent] = ret
              
              ret[:tfcount] += _ret[:fcount]
              ret[:tcode] += _ret[:tcode]
              # _p = ret
              # while _p[:parent]
              #     _p[:parent][:tcode] += _ret[:tcode]
              #     _p = _p[:parent]
              #     
              # end
              # 
          end
      end
    end
    
    ret[:tcode] += ret[:code]
    # _p = ret
    # while _p[:parent]
    #     _p[:parent][:tcode] += ret[:code]
    #     _p = _p[:parent]
    # end
    
    p "Directory #{dir}"
    p "#{fcount} file"
    p "#{dcount} directory"
    
    ret[:fcount] = fcount
    ret[:tfcount] += fcount
    ret[:dcount] = dcount
    
    return ret

end
$g_tab_number = 0
def print_scan_result(_ret, name)
  
    space = ""
    space2 = ""
    for i in 0..$g_tab_number
        # space+="----"
        space   += "    |"
        space2  += "    "
    end
    s = "#{space}-#{name} ==>file:#{_ret[:fcount]}/#{_ret[:tfcount]}   code:#{_ret[:code]}/#{_ret[:tcode]}"
    s += " match:#{_ret[:match]}" if $has_re
    p s
    #p "#{space2}#{_ret[:dcount]} dir"
     $g_tab_number+= 1
    _ret[:subs].each{|n, d|
        print_scan_result(d, n)
    }
     $g_tab_number-=1 
end
# main
p $*.inspect
p "params size #{$*.size}"
# $*.each{|a|
#     p "para #{a}"
# }
params = []
arg = ""
arg_wait_for_parse = 0
reg_exp = nil
search_dir = nil
$has_re = false
if $*.size >0
    $*.each{|a|
        p "arg = #{a}"
        if arg_wait_for_parse > 0
            if arg == "-e"
                reg_exp = a
                has_re = true
            elsif arg == "-d"
                search_dir = a
            elsif arg == "-f"
                $file_pattern = Regexp.new("\\.(#{a})$", true)  
            end
            arg_wait_for_parse = 0

            next
            
        end
        
        if a == "-e" # use regexp
            arg = a
            arg_wait_for_parse = 1
            next
        elsif a == "-d"
            arg = a
            arg_wait_for_parse = 1
        elsif a == "-f"
            arg = a
            arg_wait_for_parse = 1
            next
        end
        
        
        
        params.push(a)
    }
    p params.inspect
    p "params2 size #{params.size}"
    
    if search_dir
        _ret = scan_count(search_dir, reg_exp)
        print_scan_result(_ret, search_dir)
    else
        for a in params[0..params.size-1]
            do_count(a, reg_exp)
        end
    end
    p "====> count done ! <===="
    p "files:      #{$g_count_files} files"
    p "code:       #{$g_count} lines  "
    p "comments:   #{$g_count_comment} lines"
    p "#{$g_match_count.size} match #{reg_exp}" if reg_exp && reg_exp != ""
    $g_match_count.each{|m|
        p "file:#{m[:file]}||#{m[:line]}"
    }
else
    p "no file specified"
    p "usage: ruby cc.rb <c source file> <option>"
    p "  -e <regular express>"
    p "  -f <regular express for file name>"
    p "  -d <diretory>"
    p  " example: ruby cc.rb xiaolu.c dak.c"
    p  '           find . -type file -name "*.c" -o -name "*.h" -o -name "*.cpp" |xargs ruby cc.rb'
    p  '           cc.rb -d . -f js'
    p  '           cc.rb -d . -f \"js|php|html\"'
    
end
# find . -type file -name "*.c" -o -name "*.h" -o -name "*.cpp" |xargs cc.rb