require 'optparse'
require_relative 'trithemius_cipher'

args = {}

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: trithemius [options] text"

  opts.on("-d", "--decrypt") do |n|
    args[:decrypt] = true
  end

  opts.on("-o", "--out FILE", "write output to file") do |n|
    args[:output] = n
  end

  opts.on("-i", "--input FILE", "read input from file") do |n|
    args[:input] = n
  end

  opts.on("--formula STRING", "pass formula to calculate shift ex: t+1 t**2+5t where `t` is variable") do |n|
    args[:formula] = n
  end

  opts.on("--slogan STRING", "specify a slogan") do |n|
    args[:slogan] = n
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
  z = TrithemiusCipher.new(args[:alphabet])
else
  z = TrithemiusCipher.new
end


if args[:formula]
  block = lambda do |t, letter|
    eval(args[:formula])
  end
elsif slogan = args[:slogan]
  while slogan.length < z.alphabet.size
    slogan += slogan
  end

  block = lambda do |t, letter|
    z.alphabet.index(slogan[t])
  end
else
  abort 'You should specify either formula or slogan to encrypt'
end


if args[:decrypt]
  output = z.decrypt(ARGV.first, &block)
elsif args[:input]
  output = z.encrypt(File.read(args[:input]), &block)
else
  output = z.encrypt(ARGV.first, &block)
end

if args[:output]
  File.open(args[:output], 'w') {|f| f.write(output +'\n')}
else
  puts output
end