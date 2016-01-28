require_relative 'gamma_cipher'
require 'optparse'


args = {
    shift: 12,
    shuffle: false
}

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: gamma [options] text"

  opts.on("-d", "--decrypt") do |_|
    args[:decrypt] = true
  end

  opts.on("-o", "--out FILE", "write output to file") do |n|
    args[:output] = n
  end

  opts.on("--alphabet STRING", "pass custom alphabet") do |n|
    args[:alphabet] = n
  end

  opts.on("-f FACTORS", "4 numbers delimited with space") do |n|
    args[:factors] = n
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

raise ArgumentError.new '-f is required' unless args[:factors]


if args[:alphabet]
  z = GammaCipher.new(args[:alphabet])
else
  z = GammaCipher.new
end


factors = args[:factors].split.map(&:to_f)


if args[:decrypt]
  output = z.decrypt(ARGV.first, *factors)
elsif args[:input]
  output = z.encrypt(File.read(args[:input]), *factors)
else
  output = z.encrypt(ARGV.first, *factors)
end


if args[:output]
  File.open(args[:output], 'w') {|f| f.write(output +'\n')}
else
  puts output
end
