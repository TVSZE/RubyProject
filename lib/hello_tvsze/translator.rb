# encoding: utf-8

class Translator
  def initialize(language)
    @language = language
  end

  def hi
    case @language
      when "hungarian"
        "Szia világ"
      else
        "hello world"
    end
  end
end