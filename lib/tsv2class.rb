# = tsv2class.rb - Generate objects from the header of a TSV file, and populate a collection with each row.
#
# Carl Hicks mailto:carl.hicks@gmail.com
#

require 'rubygems'
require 'activesupport'
require 'ftools'

#
# TODO: Add argument to initialize to pass in header line.
#
class Tsv2Class
  attr :klass
  attr :eval_klass
  attr :header
  attr :rows

  def initialize(filename)
    File.open(filename, "r") do |file|
      @header = file.gets
      @klass  = File.basename(filename).split(/\./)[0].capitalize << "Csv"
      @rows   = Array.new
      new_class(@klass)

      while (line = file.gets)
        eval "@rows << #{@klass}.new(line)\n"
      end
    end
  end

  def new_class(klass)
    @eval_klass = "class #{klass}\n"
    csv_init  = "  def initialize(row)\n"
    csv_init << "    column = row.split(/\\t/)\n"
    csv_attrs = ""

    cols      = header.split(/\t/)
    cols.each do |col|
      index = cols.index(col)
      col.gsub!(/\s$/, '')
      col.gsub!(/\s/, '_')
      col.downcase!
      col.chomp!
      csv_attrs << "  attr :#{col}, true\n"
      csv_init  << "    @#{col} = strip! column[#{index}]\n"
    end

    csv_init  << "  end\n"

    attr_array   = cols.inject("") { |result,element| result << "@#{element}," }
    attr_array.gsub! /\,$/, '' 
    csv_to_tsv   = "  def to_tsv\n"
    csv_to_tsv  << "    return [#{attr_array}].join(\"\\t\")\n"
    csv_to_tsv  << "  end\n"


    csv_protect  = "  protected\n"
    csv_strip    = "    def strip!(s)\n"
    csv_strip   << "      if s.class == String\n"
    csv_strip   << "        s.chomp!\n"
    csv_strip   << "        s.gsub! /^\\s+/, ''\n"
    csv_strip   << "        s.gsub! /\\s+$/, ''\n"
    csv_strip   << "        s.gsub! /\\t/, ' '\n"
    csv_strip   << "        s.gsub! /\"/, ''\n"
    csv_strip   << "      end\n"
    csv_strip   << "      s = \"\" if s.nil?\n"
    csv_strip   << "      s = \"\" if s == \"x\"\n"
    csv_strip   << "      return s\n"
    csv_strip   << "    end\n"

    @eval_klass << csv_attrs << "\n"
    @eval_klass << csv_init
    @eval_klass << csv_to_tsv
    @eval_klass << csv_protect
    @eval_klass << csv_strip
    @eval_klass << "end\n"

    #klass_to_s

    eval @eval_klass
  end

  def klass_to_s
    index = 0
    @eval_klass.split("\n").each do |line|
      index = index.next
      puts "#{index}:\t#{line}\n"
    end
  end


end

