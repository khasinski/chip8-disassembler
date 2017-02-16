require 'thor'

class Decompile < Thor
  desc 'decompile FILENAME', 'decompile FILENAME and print ASM to stdout'
  def decompile(filename)
    rom_memory = File.read(filename).unpack('n*').map{|v| "%04X" % v}
    puts 'start:'
    rom_memory.map do |value|
      value.gsub!(/00EE/, 'RET')
      value.gsub!(/00E0/, 'CLS')
      value.gsub!(/0([0-9A-F][0-9A-F][0-9A-F])/, 'SYS #\1')
      value.gsub!(/1([0-9A-F][0-9A-F][0-9A-F])/, 'JP #\1')
      value.gsub!(/2([0-9A-F][0-9A-F][0-9A-F])/, 'CALL #\1')
      value.gsub!(/3([0-9A-F])([0-9A-F][0-9A-F])/, 'SE V\1, #\2')
      value.gsub!(/4([0-9A-F])([0-9A-F][0-9A-F])/, 'SNE V\1, #\2')
      value.gsub!(/5([0-9A-F])([0-9A-F])0/, 'SE V\1, V\2')
      value.gsub!(/6([0-9A-F])([0-9A-F][0-9A-F])/, 'LD V\1, #\2')
      value.gsub!(/7([0-9A-F])([0-9A-F][0-9A-F])/, 'ADD V\1, #\2')
      value.gsub!(/8([0-9A-F])([0-9A-F])0/, 'LD V\1, V\2')
      value.gsub!(/8([0-9A-F])([0-9A-F])1/, 'OR V\1, V\2')
      value.gsub!(/8([0-9A-F])([0-9A-F])2/, 'AND V\1, V\2')
      value.gsub!(/8([0-9A-F])([0-9A-F])3/, 'XOR V\1, V\2')
      value.gsub!(/8([0-9A-F])([0-9A-F])4/, 'ADD V\1, V\2')
      value.gsub!(/8([0-9A-F])([0-9A-F])5/, 'SUB V\1, V\2')
      value.gsub!(/8([0-9A-F])([0-9A-F])6/, 'SHR V\1, V\2')
      value.gsub!(/8([0-9A-F])([0-9A-F])7/, 'SUBN V\1, V\2')
      value.gsub!(/8([0-9A-F])([0-9A-F])E/, 'SHL V\1, V\2')
      value.gsub!(/9([0-9A-F])([0-9A-F])0/, 'SNE V\1, V\2')
      value.gsub!(/A([0-9A-F][0-9A-F][0-9A-F])/, 'LD I, #\1')
      value.gsub!(/B([0-9A-F][0-9A-F][0-9A-F])/, 'JP V0, #\1')
      value.gsub!(/C([0-9A-F])([0-9A-F][0-9A-F])/, 'RND V\1, #\2')
      value.gsub!(/D([0-9A-F])([0-9A-F])([0-9A-F])/, 'DRW V\1, V\2, #\3')
      value.gsub!(/E([0-9A-F])9E/, 'SKP V\1')
      value.gsub!(/E([0-9A-F])A1/, 'SKNP V\1')
      value.gsub!(/F([0-9A-F])07/, 'LD V\1, DT')
      value.gsub!(/F([0-9A-F])0A/, 'LD V\1, K')
      value.gsub!(/F([0-9A-F])15/, 'LD DT, V\1')
      value.gsub!(/F([0-9A-F])18/, 'LD ST, V\1')
      value.gsub!(/F([0-9A-F])1E/, 'ADD I, V\1')
      value.gsub!(/F([0-9A-F])29/, 'LD F, V\1')
      value.gsub!(/F([0-9A-F])33/, 'LD B, V\1')
      value.gsub!(/F([0-9A-F])55/, 'LD [I], V\1')
      value.gsub!(/F([0-9A-F])65/, 'LD V\1, [I]')
      puts "\t" + value
    end
  rescue Errno::ENOENT
    puts 'Cannot find file '+filename
  end
end

Decompile.start(ARGV)