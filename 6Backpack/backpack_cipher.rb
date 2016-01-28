class BackpackCipher
  def initialize(private_key, b, t, t_inverted)
    @alphabet = [*('a'..'z'), *('A'..'Z'), *('а'..'я'), *('А'..'Я'), *('0'..'9')].join + ' ,.?!іїґ'
    @private_key = private_key
    @b = b
    @t = t
    @t_inverted = t_inverted
    raise "#{t_inverted} is not modular inverse of #{t}" if t * t_inverted % b != 1
  end

  def encrypt(text)
    # superincreasing sequence
    pub_key = @private_key.map {|e| e * @t % @b}

    binary_codes = char_to_binary(text, @private_key.size)

    c = binary_codes.map do |binary|
      raise "sequence is too short" if binary.length > pub_key.size
      # split binary to separate bits
      bits = binary.each_char.map(&:to_i)
      # convert bits to integer, using the pub key
      bits.each_with_index.inject(0) do |prev, (bit, i)|
        # puts "#{bit.to_i} * #{pub_key[i]}"
        # multiply each respective bit by the corresponding number in β
        prev += bit.to_i * pub_key[i]
      end
    end
    c.join(' ')
  end

  def decrypt(encrypted_string)
    result = encrypted_string.split.map do |num|
      n = num.to_i * @t_inverted % @b
      # puts "#{num} * #{@t_inverted} % #{@b}"
      index = knapsack(@private_key, n)
      @alphabet[index]
    end
    result.join
  end

  private

  def char_to_binary(string, binary_length)
    string.chars.map do |char|
      num = @alphabet.index(char)
      raise "no #{char.inspect} in alphabet" if num.nil?
      # format binary with given length
      '%0*b' % [binary_length, num]
    end
  end


  def knapsack(sequence, num)
    b = sequence.subset_sum(num)
    to_binary_sequence(sequence, b)
  end

  def to_binary_sequence(a, b)
    binary_sequence = ''
    a.each {|el| binary_sequence << (b.include?(el) ? '1' : '0')}
    binary_sequence.to_i(2)
  end
end

class Array
  def subset_sum(value)
    subsets = {0 => []}
    self.each do |elem|
      old_subsets = subsets
      subsets = Hash.new

      old_subsets.each do |prev_sum, subset|
        subsets[prev_sum] = subset

        new_sum = prev_sum + elem
        new_subset = subset.dup << elem
        if new_sum == value
          return new_subset
        else
          subsets[new_sum] = new_subset
        end
      end
    end
    []
  end
end
