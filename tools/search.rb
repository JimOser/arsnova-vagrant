directory = "./*/*.txt"
searched_item = "not found"
Dir[directory].each do |item|  
#  next if item == "." or item == ".."
  File.open(item) do |f|
    while (line = f.gets) 
      if line =~  /not found/
        puts "#{item}\n#{line}"
      end
    end
  end
end
