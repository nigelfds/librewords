dict = File.readlines './english3.txt'
ndict = dict.map {|w| w.gsub("\n",'') }.map {|w| w if w.length == 5 }.compact
File.open("dict.txt", "w+") do |f|
    f.puts(ndict)
end