require 'csv'

task default: %w[prep test]

task :prep do
    dict = File.readlines './english3.txt'
    ndict = dict.map {|w| w.gsub("\n",'') }.map {|w| w if w.length == 5 }.compact
    File.open("dict.txt", "w+") do |f|
        f.puts(ndict)
    end
    
    data = CSV.read('lemma.csv', col_sep: ' ')
    words = data.map{|row| row[2] if row[2].length == 5}.compact    
    File.open("words.txt", "w+") do |f|
        f.puts(words)
    end
end

task :test do
    ruby "tests.rb"
end

task :play do
    ruby "play.rb"
end

task :server do
    ruby "index.rb"
end
task :s => :server