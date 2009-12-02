module TelephoneNumber

  class UnsupportedNumberException < Exception
  end

  class Parser

    attr :number, true
    attr :cc, true
    attr :delim, true
    attr :type, true
    attr :formatted, true

    def initialize(tn)
      # Convert everything into string
      @delim  = "-"
      @number = tn.to_s
      @number.gsub! /[^0-9]/, ''
      
      case @number
        # 353 1 640 1378 - Dublin
        when /(353)(\d)(\d{3})(\d{4})/
          @cc =$1 
          @number = $2 + $3 + $4
          @formatted = "+#{@cc} #{$2} #{$3} #{$4}"
        # German mobile phones are ten or elevent digits and may begin with a 0
        # e.g. +49 17 3665 3588
        when /(49)[0]*(\d{2})(\d{4})(\d{4,5})/
          @cc = $1
          @number = $2 + $3 + $4
          @formatted = "+#{@cc} #{$2} #{$3} #{$4}"
        # Chinese mobiles are 11 digits, starting with 1 and are written 1XX-XXXX-XXXX
        when /(86)(1\d{2})(\d{4})(\d{4})/
          @cc = $1
          @number = $2 + $3 + $4
          @type = "mobile"
          @formatted = "+#{@cc} #{$2} #{$3} #{$4}"
        # 214 263 8639
        when /[1]*(\d{3})(\d{3})(\d{4})/
          @cc = 1
          @formatted = "+#{@cc} #{$1} #{$2} #{$3}"
        when /(\d{4})(\d{4})/
          @cc = 86
          @number = "21" + $1 + $2
          @formatted = "+#{@cc} 21 #{$1} #{$2}"
        else
          raise UnsupportedNumberException, "\'#{@number}\' is not supported", caller
      end
    end

    def to_s
      @formatted
    end

  end
end
