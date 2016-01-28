gem 'gtk3', '3.2.0'

require 'gtk3'
require_relative 'backpack_cipher'

class HelloGlade
  attr_reader :glade

  def initialize
    if __FILE__ == $PROGRAM_NAME
      Gtk.init
      @glade = Gtk::Builder.new
      @glade.add_from_file('layout.glade')
      @glade.connect_signals {|handler| method(handler)} # (I don't have any handlers yet, but I will have eventually)
      window = @glade.get_object('window1')
      window.signal_connect('delete-event') {Gtk.main_quit}
      @result_text_view = @glade['result']
      @input_text_view = @glade['input']
      window.show
      Gtk.main
    end
  end

  def encrypt
    z = init
    @result_text_view.buffer.text = z.encrypt(text)
  rescue => e
    error_dialog e
  end

  def decrypt
    z = init
    @result_text_view.buffer.text = z.decrypt(text)
  rescue => e
    error_dialog e
  end

  def init
    private_key = @glade['private-key'].text.split.map(&:to_i)
    t = @glade['t'].text.to_i
    t_inverted = @glade['t-inverted'].text.to_i
    b = @glade['b'].text.to_i
    # private_key = [2,3,6,13,27,52] #[2, 3, 6, 15, 30] #[1,3,6,13,27,52]
    BackpackCipher.new(private_key, b, t, t_inverted)
  end

  private

  def text
    @input_text_view.buffer.text
  end

  def error_dialog(msg)
    msg = msg.to_s
    dialog = Gtk::MessageDialog.new nil,
                                    Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT,
                                    Gtk::MessageDialog::ERROR, Gtk::MessageDialog::BUTTONS_OK, msg
    dialog.run
    dialog.destroy
  end
end

HelloGlade.new


## Example how to use this library directly in ruby code
=begin
  private_key = [2, 3, 6, 13, 27, 52]
  z = BackpackCipher.new(private_key, 60, 13, 37)

  encrypted = z.encrypt("plsztkjqahgwbrovixfudeymcn")
  puts "encrypted #{encrypted}"
  puts z.decrypt(encrypted)
=end


# require "test/unit"
# class TestCipher < Test::Unit::TestCase
#   def test_string
#     z = BackpackCipher.new([2,3,6,13,27,52],105,31,61)
#     original_string = "plsztkjqahgwbrovixfudeymcn"
#     encrypted = z.encrypt(original_string)
#     decrypted = z.decrypt(encrypted)
#     assert_equal(original_string,decrypted)
#   end
# end
