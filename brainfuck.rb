#!/usr/bin/ruby

class Brainfuck
  def initialize str
    @code = str
    @codesize = @code.size
    reset
    # TODO: vyhodit vsechny nepotrebne znaky
  end

  def run
    reset
    while @codeloc < @codesize
      case @code[@codeloc].chr
        when "+" then plus
        when "-" then minus
        when ">" then right
        when "<" then left
        when "[" then loopBegin
        when "]" then loopEnd
        when "." then output
        when "," then input
      end
      @codeloc += 1
      #STDERR.print "#"
    end
    STDERR.puts "ERROR: unmatched [" unless @looparray.empty?
  end
  
private

  def reset
    @codeloc = 0
    @index = 0
    @array = Array.new 1, 0
    @looparray = Array.new
  end
  
  def left
    @index -= 1
    if @index < 0
      @index = @array.size - 1
    end
  end

  def right
    @index += 1
    @array[@index] = 0 unless @array[@index]
  end

  def plus
    if @array[@index] == 255
      @array[@index] = 0 #overflow
    else
      @array[@index] += 1
    end
  end

  def minus
    if @array[@index]
      @array[@index] -= 1
    else
      @array[@index] = 255 #overflow
    end
  end

  def input
    begin
      @array[@index] = STDIN.getc.ord
    rescue
      @array[@index] = 0
    end
  end
  
  def output
    print @array[@index].chr
  end
  
  def loopBegin
    if @array[@index] == 0
      loll = 1
      while loll > 0
        @codeloc += 1
        if @code[@codeloc].chr == "]"
          loll -= 1
        elsif @code[@codeloc].chr == "["
          loll += 1
        end
      end
    else
      @looparray.push @codeloc
    end
  end
  
  def loopEnd
    begin
      @codeloc = @looparray.pop - 1
    rescue
      STDERR.puts "", "ERROR: unmatched ]"
      #@codeloc = @codesize
      exit
    end
  end
end

if $*.empty?
  a = Brainfuck.new STDIN.read
else
  begin
    f = File.new $*[0], "r"
    a = Brainfuck.new f.read
    f.close
  rescue
    a = Brainfuck.new $*[0]
  end
end

a.run

puts
