require 'term/ansicolor'
include Term::ANSIColor
#LEDBulb represents a single LED bulb which can display one character
class LEDBulb

	attr_reader :ary_display

	def initialize(char,size)
	  @char = char
	  @size = size
	  @ary_display = []
	  #
	  case @char
          when "0" then
             @ary_light_seq = @@ary_0
	  when "1" then
             @ary_light_seq = @@ary_1
	  when "2" then
             @ary_light_seq = @@ary_2
	  when "3" then
             @ary_light_seq = @@ary_3
	  when "4" then
             @ary_light_seq = @@ary_4
	  when "5" then
             @ary_light_seq = @@ary_5
	  when "6" then
             @ary_light_seq = @@ary_6
	  when "7" then
             @ary_light_seq = @@ary_7
	  when "8" then
             @ary_light_seq = @@ary_8
	  when "9" then
             @ary_light_seq = @@ary_9
	  else
	     @ary_light_seq = @@ary_x
	  end
	  
	  lightBulb
	end
	
 public
	# display a single character
	def display
	  @ary_display.each{|line| $stdout.print(line + "\n")}
	end

 private
	def lightBulb
	  numRows = 3 + 2 * @size 	# number of rows the led display contains
	  numCols = 2 + @size 		# number of columns the led display contains
	  
	  # Generate Horizen String
	  horString = String.new
	  horStringNone  = String.new
	  
	  numCols.times{ horStringNone << " " }
	  @size.times{
		horString << "-"
	  }

	  (numCols - @size).times{
	        horString << " "
	  }
	  
	  # Generate Vertical Strings

	  verString = String.new
	  verStringL = String.new
	  verStringLR = String.new
	  verStringNone = String.new
	  verStringR = String.new

	  verStringL << "|"
	  (numCols - 1).times{ verStringL << " "}	# "|" left side

	  (numCols - 1).times{ verStringR << " "}	# "|" right side
	  verStringR << "|"

	  verStringLR << "|"
	  @size.times{ verStringLR << " "}		# "|" both sides
	  verStringLR << "|"

	  numCols.times{ verStringNone << " " }		# "|" absent
	  
	  # Generate string array which can display a character in led like format
	  for i in 0..(numRows - 1)
	     if i == 0 then
            if @ary_light_seq[0] != 0 then
                 @ary_display.push(horString)
            else
		         @ary_display.push(horStringNone)
		    end
	     elsif i == @size + 1 then
		    if @ary_light_seq[3] != 0 then
		         @ary_display.push(horString)
		    else
		         @ary_display.push(horStringNone)
            end
	     elsif i == numRows - 1 then
		    if @ary_light_seq[6] != 0 then
		         @ary_display.push(horString)
		    else
		         @ary_display.push(horStringNone)
            end
         elsif i < @size + 1 && i > 0 then
		    if @ary_light_seq[1] == 0 && @ary_light_seq[2] == 0 then
		         verString = verStringNone
		    elsif @ary_light_seq[1] != 0 && @ary_light_seq[2] == 0 then
		         verString = verStringL
		    elsif @ary_light_seq[1] ==0 && @ary_light_seq[2] != 0 then
		         verString = verStringR
            else 
		         verString = verStringLR
            end
            @ary_display.push(verString)
	     else
		    if @ary_light_seq[4] == 0 && @ary_light_seq[5] == 0 then
		        verString = verStringNone
            elsif @ary_light_seq[4] != 0 && @ary_light_seq[5] == 0 then
		        verString = verStringL
		    elsif @ary_light_seq[4] == 0 && @ary_light_seq[5] != 0 then
		        verString = verStringR
		    else 
		        verString = verStringLR
		    end
		
	        @ary_display.push(verString)
		
	     end # end if
	  end	# end for
	end


 @@ary_0 = [1,1,1,0,1,1,1]
 @@ary_1 = [0,0,1,0,0,1,0]
 @@ary_2 = [1,0,1,1,1,0,1]
 @@ary_3 = [1,0,1,1,0,1,1]
 @@ary_4 = [0,1,1,1,0,1,0]
 @@ary_5 = [1,1,0,1,0,1,1]
 @@ary_6 = [1,1,0,1,1,1,1]
 @@ary_7 = [1,0,1,0,0,1,0]
 @@ary_8 = [1,1,1,1,1,1,1]
 @@ary_9 = [1,1,1,1,0,1,1]
 @@ary_x = [0,0,0,1,0,0,0]	# Unknow
 @@ary_map={"0"=> @@ary_0,"1"=>@@ary_1,"2"=>@@ary_2,"3"=>@@ary_3,"4"=>@@ary_4,"5"=>@@ary_5,"6"=>@@ary_6,"7"=>@@ary_7,"8"=>@@ary_8,"9"=>@@ary_9}
end

# class LEDDisplayer represents a LED screen on which a string can be displayed with LED bulbs

class LEDDisplayer

  def initialize(sInput,size,color)
	@size = size
	@string_display = sInput
	@ary_Bulbs = []	# bulb array, each bulb element displays a character of the input string
	@ary_ledDisplay = []
	@color = color
	# built bulb array
  	for i in 0..(sInput.length - 1)
	  bulb = LEDBulb.new( sInput[i].chr,@size )
	  @ary_Bulbs.push(bulb)
  	end
  end

  public
  
  def Display()
	@ary_Bulbs[0].ary_display.length.times{ @ary_ledDisplay.push("") } # initialise led Display array

	@ary_Bulbs.each{|bulb|
	  for i in 0..(@ary_ledDisplay.length - 1)
	    @ary_ledDisplay[i] << ( " " + bulb.ary_display[i])	# concate all the bulb together seperated by a blankspace
	  end
	}

	@ary_ledDisplay.each{|line|
        if(@color == 1 ) then
            puts (line + "\n").red
        elsif(@color == 2)then
            puts (line + "\n").green
        elsif(@color == 3)then
            puts (line + "\n").yellow
        else
            puts (line + "\n")
        end
    }	# Show result on the LED screen
  end

end

# Smoke Test
l = LEDDisplayer.new(ARGV[0],ARGV[1].to_i, ARGV[2].to_i)
l.Display()
#puts "this is red".red
