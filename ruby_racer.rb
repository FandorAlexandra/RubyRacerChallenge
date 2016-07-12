require_relative 'racer_utils'

class RubyRacer
  attr_reader :players, :length

  def initialize(players, length = 30, landmines = 0)
    @status = Hash.new
    players.each {|player| @status[player] = 1}
    @length = length
    @landmines = Array.new(landmines) { |index| 1 + rand(@length - 1)}
  end

  # Returns +true+ if one of the players has reached
  # the finish line, +false+ otherwise
  def finished?
    if !@status
      return false
    end
    @status.each do |player, place|
      if place == @length
        return true
      end
    end
    return false
  end

  # Returns the winner if there is one, +nil+ otherwise
  def winner
    @status.each do |player, place|
      if place == length
       return player
      end
    end
    return nil
  end

  # Rolls the dice and advances +player+ accordingly
  def advance_player!(player)
    roll = Die.new.roll
    @status[player] += roll

    #check for landmine
    if @landmines.include? @status[player]
      @status[player] = 1
    end

    if @status[player] > length
      @status[player] = length
    end
  end

  # Prints the current game board
  # The board should have the same dimensions each time
  # and you should print over the previous board
  def print_board
    move_to_home!
    clear_screen!
    @status.each do |player, place|
      (1..@length).each do |space|
        if space == place
          print "|#{player}"
        elsif @landmines.include? space
          print "|*"
        else
          print "| "
        end
      end
      puts "|"
    end
  end
end

players = ['a', 'b']

game = RubyRacer.new(players, 30, 3)

# This clears the screen, so the fun can begin
clear_screen!

until game.finished?
  players.each do |player|
    # This moves the cursor back to the upper-left of the screen
    move_to_home!

    # We print the board first so we see the initial, starting board
    game.print_board
    game.advance_player!(player)

    # We need to sleep a little, otherwise the game will blow right past us.
    # See http://www.ruby-doc.org/core-1.9.3/Kernel.html#method-i-sleep
    sleep(0.2)
  end
end

# The game is over, so we need to print the "winning" board
game.print_board

puts "Player '#{game.winner}' has won!"