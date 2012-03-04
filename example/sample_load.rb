require './sample'

io = File.open('./sample.csv')
Sample.load(io)

puts 'load all'
puts Sample.all.map(&:name)

puts 'select tokyo'
puts Sample.where(address: 'tokyo').map(&:name)
