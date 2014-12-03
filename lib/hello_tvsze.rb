class Hello_tvsze
  def self.hi(language = "english")
    translator = Translator.new(language)
    translator.hi
  end
end

require 'hello_tvsze/translator'
