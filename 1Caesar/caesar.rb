require 'optparse'
require_relative 'caesar_cipher'


args = {
    shift: 12,
    shuffle: false
}

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: caesar [options] text"

  opts.on("-e", "--encrypt", "used by default if not specified") do |n|
    args[:encrypt] = true
  end

  opts.on("-d", "--decrypt") do
    args[:decrypt] = true
  end

  opts.on("-o", "--out FILE", "write output to file") do |n|
    args[:output] = n
  end

  opts.on("-i", "--input FILE", "read input from file instead of STDIN") do |n|
    args[:input] = n
  end

  opts.on("-s", "--shift SHIFT", Integer, "specify a shift for alphabet (defaults to 12)") do |n|
    args[:shift] = n
  end

  opts.on("--shuffle", "shuffle an alphabet (can be used only when encrypting text)") do |n|
    args[:shuffle] = n
  end

  opts.on("--alphabet STRING", "use custom alphabet") do |n|
    args[:alphabet] = n
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


if args[:alphabet]
  z = CaesarCipher.new(args[:shift], args[:shuffle], args[:alphabet])
else
  z = CaesarCipher.new(args[:shift], args[:shuffle])
end


if args[:shuffle]
  raise '--shuffle option can be used only when encrypting text' if args[:decrypt]
  puts "Generated alphabet: '#{z.alphabet}'"
end

if args[:decrypt]
  output = z.decrypt(ARGV.first)
elsif args[:input]
  output = z.encrypt(File.read(args[:input]))
else
  output = z.encrypt(ARGV.first)
end

if args[:output]
  File.open(args[:output], 'w') {|f| f.write(output +'\n')}
else
  puts output
end