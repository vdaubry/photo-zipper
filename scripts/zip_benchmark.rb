require 'benchmark'
require 'fileutils'
require 'zip'

def bench 
  GC::Profiler.enable
  nb_objects_before = ObjectSpace.count_objects
  puts Benchmark.measure { yield }
  nb_objects_after = ObjectSpace.count_objects
  puts "[GC Stats] #{nb_objects_after[:FREE] - nb_objects_before[:FREE]} new allocated objects."
end

#create 1000 images
1000.times do |i|
  FileUtils.cp "ressources/calinours.jpg", "tmp/calinours#{i}.jpg"
end

#zip with rubyzip
bench do
  Zip::File.open("tmp/zip1.zip", Zip::File::CREATE) do |zipfile|
    Dir.glob('tmp/*').each do |file|
      zipfile.add file, file
    end
  end
end

#zip with system zip
bench do
  `zip tmp/test.zip #{Dir.glob('tmp/*.jpg').join(" ")}`
end

#clean images
FileUtils.rm_r Dir.glob('tmp/*')