#!/usr/local/bin/ruby
require 'find'
$g_count = 0
$g_count_comment = 0
$g_count_files = 0
$g_match_count = []
$ref = []

def do_find(fname)
    
   
    
        p "filename=#{fname}"
        # read out content
        content = ""
        file=File.open(fname,"r")  
        t = nil      
        
        count = 0
        file.each_line do |line|
            if line =~ /^\s*\/\//
               next 
            end
            content += line
        end

        content.gsub!(/\/\*(.*?)\*\//m, "")
#p "content:#{content}"
        content.scan(/#include\s*?['"]([a-zA-Z\._-]+)['"]/im){|m|
            p "incl->#{m[0]}"
        }
    
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
            end
            arg_wait_for_parse = 0

            next
            
        end
        
        if a == "-e"
            arg = a
            arg_wait_for_parse = 1
            next
        elsif a == "-d"
            arg = a
            arg_wait_for_parse = 1
        end
        
        
        
        params.push(a)
    }
    p params.inspect
    p "params2 size #{params.size}"
    

    for a in params[0..params.size-1]
        do_find(a)
    end

else
    p "no file specified"
    p "usage: ruby cc.rb <c source file>"
    p  " example: ruby cc.rb xiaolu.c dak.c"
    p  '           find . -type file -name "*.c" -o -name "*.h" -o -name "*.cpp" |xargs ruby cc.rb'
    
end
# find . -type file -name "*.c" -o -name "*.h" -o -name "*.cpp" |xargs cc.rb