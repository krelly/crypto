require_relative 'literature_fragment_cipher'
require 'optparse'


args = {
    shift: 12,
    shuffle: false
}

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: trithemius [options] text"

  opts.on("-d", "--decrypt") do |n|
    args[:decrypt] = true
  end

  opts.on("-o", "--out FILE", "write output to file") do |n|
    args[:output] = n
  end

  opts.on("-i FILE", "read input from file instead of STDIN") do |n|
    args[:input] = n
  end

  opts.on("-f FILE", "File containing text fragment") do |n|
    args[:fragment] = n
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end

  if ARGV.empty?
    puts opts
    exit 1
  end
end

opt_parser.parse!

unless args[:fragment]
  abort 'File containing text fragment is required'
end

contents = File.read(args[:fragment])

z = LiteratureFragmentCipher.new(contents)


if args[:input]
  text = File.read(args[:input])
else
  text = ARGV.first
end


if args[:decrypt]
  output = z.decrypt(text)
else
  output = z.encrypt(text)
end

if args[:output]
  File.open(args[:output], 'w') {|f| f.write(output)}
else
  puts output
end