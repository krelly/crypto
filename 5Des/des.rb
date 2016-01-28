require 'openssl'
# puts OpenSSL::Cipher.ciphers
require 'optparse'

args = {}

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: des [options] text"

  opts.on("-d", "--decrypt") do |_|
    args[:decrypt] = true
  end

  opts.on("-o", "--out FILE", "write output to file") do |n|
    args[:output] = n
  end

  opts.on("-i FILE", "read input from file") do |n|
    args[:input] = n
  end

  opts.on("--key string") do |n|
    args[:key] = n
  end

  opts.on("--iv string", "initialization vector") do |n|
    args[:iv] = n
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

unless args[:key] || args[:iv]
  abort 'key and initialization vector must be provided'
end

digest = OpenSSL::Digest::SHA256.new
cipher = OpenSSL::Cipher.new('des')
salt = "salt ssslsdlre09439p0 9p 5p44"
iter = 20000
key_len = cipher.key_len
key = OpenSSL::PKCS5.pbkdf2_hmac(args[:key], salt, iter, key_len, digest)

if args[:decrypt]
  input = File.read(args[:input])
  cipher = OpenSSL::Cipher.new('des')
  cipher.decrypt
  cipher.key = key
  cipher.iv = args[:iv]
  output = cipher.update(input) + cipher.final
  output.force_encoding("UTF-8")
else
  input = File.read(args[:input])
  digest = OpenSSL::Digest::SHA256.new
  cipher.encrypt
  cipher.key = key
  cipher.iv = args[:iv]
  #key = cipher.random_key #Digest::SHA1.hexdigest("yourpass")
  # iv = cipher.random_iv

  output = cipher.update(input) + cipher.final
end

if args[:output]
  File.open(args[:output], 'w') {|f| f.write(output)}
else
  puts output
end
