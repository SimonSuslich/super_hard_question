##
# Klassen Num_base representerar ett tal i en specifik talbas och ger funktionalitet 
# för att konvertera det till en annan bas.
#
class Num_base
  attr_reader :num, :base

  ##
  # Initierar ett nytt Num_base-objekt.
  # @param [String] num Det numeriska värdet som en sträng.
  # @param [Integer] base Den ursprungliga talbasen.
  #
  def initialize(num, base)
    @num = num  
    @base = base
  end

  ##
  # Konverterar numret från dess nuvarande bas till en ny bas.
  # @param [Integer] new_base Den nya basen att konvertera till.
  # @return [String] Det konverterade numret i den nya basen.
  #
  def convert_base(new_base)
      integer_part, fractional_part = @num.split('.')
      converted_int = convert_integers(integer_part, new_base)
      converted_frac = fractional_part ? convert_fractional(fractional_part, new_base) : nil
      return converted_frac.nil? ? converted_int.sub(/^0+/, '') : "#{converted_int}.#{converted_frac}".sub(/^0+/, '').sub(/\.?0+$/, '')
  end

  ##
  # Konverterar heltalsdelen av numret till den nya basen.
  # @param [String] integer_part Heltalsdelen av numret.
  # @param [Integer] new_base Den nya basen.
  # @return [String] Heltalsdelen i den nya basen.
  #
  def convert_integers(integer_part, new_base)
    result = ''
    int_value = 0
    numerals = get_available_digits(@base)
    
    integer_part.chars.reverse.each_with_index do |char, index|
      digit_value = numerals.index(char)
      raise "Invalid character '#{char}' for base #{@base}" if digit_value.nil?
      int_value += digit_value * (@base**index)
    end
    
    return '0' if int_value == 0
    return int_value.to_s if new_base == 10
    
    numerals_new_base = get_available_digits(new_base)
    
    while int_value > 0
      remainder = int_value % new_base
      result = numerals_new_base[remainder] + result
      int_value /= new_base 
    end
    
    result
  end

  ##
  # Konverterar den fraktionella delen av numret till den nya basen.
  # @param [String] fractional_part Den fraktionella delen av numret.
  # @param [Integer] new_base Den nya basen.
  # @param [Integer] precision Antalet decimaler i resultatet (default: 10).
  # @return [String] Fraktionella delen i den nya basen.
  #
  def convert_fractional(fractional_part, new_base, precision = 10)
    result = ''
    fraction_value = 0.0
    numerals = get_available_digits(@base)
    
    fractional_part.chars.each_with_index do |char, index|
      digit_value = numerals.index(char)
      raise "Invalid character '#{char}' for base #{@base}" if digit_value.nil?
      fraction_value += digit_value / (@base.to_f**(index + 1))
    end
    return fraction_value.to_s if new_base == 10
    
    numerals_new_base = get_available_digits(new_base)

    while precision > 0
      fraction_value *= new_base
      digit = fraction_value.to_i
      result += numerals_new_base[digit]
      fraction_value -= digit
      precision -= 1
    end
    
    result
  end
end

##
# Returnerar en lista av tillgängliga siffror för en given bas.
# @param [Integer] base Den bas som siffrorna ska hämtas för.
# @return [Array<String>] En array av tillgängliga siffror.
#
def get_available_digits(base=0)
  available_digits = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
  available_digits[0..base-1]
end

##
# Skapar ett nytt nummer genom att be användaren mata in en bas och ett värde.
#
def new_number
  num, base = number_input_validatoin()
  @my_num = Num_base.new(num, base)
end

##
# Validerar användarens input av talbas och nummer.
# @return [Array] En array med numret som sträng och dess bas som heltal.
#
def number_input_validatoin
  base = 10
  num = "0"
  available_digits = get_available_digits()
  largest_base = available_digits.length
  
  loop do 
    puts "Skriv in talbasen du valt:"
    base = gets.chomp.to_i
    break if base >= 2 && base <= largest_base
    puts "Talbasen måste vara mellan 2 och #{largest_base}"
  end

  available_chars = available_digits[0..(base-1)] + ['.', ',']
  
  loop do 
    puts "Skriv in ett tal:"
    num = gets.chomp.to_s
    break if num.chars.all? { |char| available_chars.include?(char) }
    puts "Talet får bara innehålla följande tecken: #{available_chars}"
  end
  
  return num, base
end

##
# Validerar input för en ny bas att konvertera till.
# @return [Integer, String] Den nya basen eller 'exit' om användaren vill avbryta.
#
def new_base_input_validation
  largest_base = get_available_digits.length
  new_base = 2
  
  loop do 
    puts "(Skriv 'exit' för att avbryta)"
    puts "Skriv talbasen du vill konvertera till (mellan 2 och #{largest_base}):"
    new_base = gets.chomp
    break if new_base == 'exit' || new_base.to_i.between?(2, largest_base)
    puts "Ogiltig inmatning, försök igen."
  end
  
  return new_base
end

##
# Konverterar användarens nummer till en ny bas.
#
def convert_number
  loop do 
    new_base = new_base_input_validation()
    break if new_base == 'exit'
    puts "Resultatet är #{@my_num.convert_base(new_base.to_i)}"
  end
end

##
# Huvudfunktionen för att starta programmet.
#
def main
  puts "Välkommen till TALBAS CONVERTER 3000!!!"
  new_number()
  
  loop do
    puts "Ditt tal är #{@my_num.num} av talbasen #{@my_num.base}"
    puts "Skriv 'convert' för att konvertera, 'edit' för att ändra tal, 'exit' för att avsluta."
    user_input = gets.chomp.to_s
    break if user_input == 'exit'
    convert_number() if user_input == 'convert'
    new_number() if user_input == 'edit'
  end
  puts "Lämnar programmet..."
end

main()
