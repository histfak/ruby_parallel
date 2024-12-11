require 'parallel'

# Генерация файлов для примера
files = 5.times.map do |i|
  filename = "file_#{i}.txt"
  File.open(filename, 'w') { |f| f.puts(Array.new(100_000) { "Line from #{filename}" }) }
  filename
end

# puts Sequentially
def process_files_sequentially(files)
  files.each do |file|
    File.open(file, 'r') do |f|
      f.each_line { |line| puts line }
    end
  end
end

# puts in Parallel
def process_files_parallel(files)
  Parallel.map(files, in_threads: 5) do |file|
    File.open(file, 'r') do |f|
      f.each_line { |line| puts line }
    end
  end
end

# puts using threads
def process_files_threads(files)
  ts = files.map do |file|
    Thread.new do
      File.open(file, 'r') do |f|
        f.each_line { |line| puts line }
      end
    end
  end
  ts.each(&:join)
end

def measure_sequentially(files)
  start_time = Time.now
  process_files_sequentially(files)
  end_time = Time.now
  end_time - start_time
end

def measure_parallel(files)
  start_time = Time.now
  process_files_parallel(files)
  end_time = Time.now
  end_time - start_time
end

def measure_threads(files)
  start_time = Time.now
  process_files_threads(files)
  end_time = Time.now
  end_time - start_time
end

time_sequentially = measure_sequentially(files)
time_parallel = measure_parallel(files)
time_threads = measure_threads(files)

puts "Время выполнения Sequentially: #{time_sequentially} секунд"
puts "Время выполнения Parallel: #{time_parallel} секунд"
puts "Время выполнения Concurrently: #{time_threads} секунд"
