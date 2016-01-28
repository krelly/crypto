require 'openssl'
require 'optparse'


args = {}

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: rsa [options] text
     You need a keypair to use RSA
     Either generate keypair using -g option
            or copy existing `public.pem` and `private.pem` into script folder"


  opts.on("-d PASSWORD", "decrypt with given PASSWORD") do |n|
    args[:decrypt_pass_phrase] = n
  end

  opts.on("-g PASSWORD", "generate keypair with given PASSWORD") do |n|
    args[:pass_phrase] = n
  end

  opts.on("-o", "--out FILE", "write output to file") do |n|
    args[:output] = n
  end

  opts.on("-i FILE", "read from FILE") do |n|
    args[:filename] = n
  end

  opts.on("-h", "--help", "prints this help") do
    puts opts
    exit
  end

  if ARGV.empty?
    puts opts
    exit 1
  end
end

opt_parser.parse!


private_key_file = 'private.pem'
public_key_file = 'public.pem'

if !File.exist?('public.pem') || !File.exist?('public.pem')
  puts opt_parser.help
  exit 1
end

# Generate keypair
if args[:pass_phrase]
  key = OpenSSL::PKey::RSA.new 2048

  cipher = OpenSSL::Cipher.new 'AES-128-CBC'

  key_secure = key.export(cipher, args[:pass_phrase])

  File.write(private_key_file, key_secure)
  File.write(public_key_file, key.public_key.to_pem)
  exit
end

if args[:filename]
  args[:input] = File.read(args[:filename])
else
  args[:input] = ARGV[0]
end

if args[:decrypt_pass_phrase]
  begin
    private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file), args[:decrypt_pass_phrase])
  rescue OpenSSL::PKey::RSAError
    fail 'Wrong password'
  end
  result = private_key.private_decrypt(args[:input])
else
  public_key = OpenSSL::PKey::RSA.new(File.read(public_key_file))
  result = public_key.public_encrypt(args[:input])
end

if args[:output]
  File.write(args[:output], result)
else
  puts result
end

