module Identifiable
  def self.included(base)
    base.before_validation :ensure_id
    base.primary_key = 'id'
    base.validates :id, presence: true, uniqueness: true, format: {with: /[A-Za-z0-9]{7}/}
  end
  
  def ensure_id
    self.id ||= IdentityTag.new.value
  end
  

  class IdentityTag
    Chars = %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9]
    NumChars = Chars.size

    attr_reader :value

    def initialize(size = 7)
      @size = size
      @value = generate_value
    end

    def generate_value
      (1..@size).map {|i| Chars[rand(NumChars).to_i].to_s}.join ""
    end
  end
end
