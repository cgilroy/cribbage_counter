require_relative 'deck'
require_relative 'card'
require 'byebug'
class Game
    attr_reader :player1, :player2, :deck
    def initialize
        @player1 = Player.new
        @player2 = Player.new
        @crib_owner = :player1
        @deck = Deck.new
        @used_totals = []
    end

    def reset
        @player1 = Player.new
        @player2 = Player.new
        @crib_owner = :player1
        @deck = Deck.new
        @used_totals = []
    end

    def play
        self.reset
        self.deal_hands
        # self.check_player_hands
        self.render
    end

    def deal_hands
        @deck.shuffle
        4.times do
            player1.hand.cards.concat(@deck.take_card(1))
            player2.hand.cards.concat(@deck.take_card(1))
        end
    end

    def check_player_hands
        # debugger
        points1 = player1.hand.get_hand_points(@deck.cards[0])
        points2 = player2.hand.get_hand_points(@deck.cards[0])
        # player1.hand.cards.each { |card| puts card.value.to_s + " " + card.suit.to_s  }
        puts points1
        # player2.hand.cards.each { |card| puts card.value.to_s + " " + card.suit.to_s  }
        puts points2
    end

    def render
        
        # player1.hand.cards.each { |card| puts card.value.to_s + " " + card.suit.to_s  }
        # player2.hand.cards.each { |card| puts card.value.to_s + " " + card.suit.to_s  }
        puts "Player 1:"
        player1.hand.cards.each { |card| puts card.value.to_s + " " + card.suit.to_s  }
        puts
        puts "Player 2:"
        player2.hand.cards.each { |card| puts card.value.to_s + " " + card.suit.to_s  }
        puts
        puts "Starter"
        puts @deck.cards[0].value.to_s + " " + @deck.cards[0].suit.to_s
    end

end

class Player
    attr_accessor :hand
    def initialize
        @hand = Hand.new(false)
    end
end

class Hand
    VALUES = [:ace, :two, :three, :four, :five, :six, :seven, :eight, :nine, :ten, :jack, :queen, :king]
    attr_accessor :cards, :points
    def initialize(is_crib)
        @cards = []
        @points = nil
        @is_crib = is_crib
    end

    def get_hand_points(starter)
        # debugger
        cards_with_starter = @cards.dup
        cards_with_starter << starter
        permutations = permute(cards_with_starter)
        hand_points = 0
        total_description = []

        permutations.each do |cards|
            description = []
            points = 0
            cards.sort! { |a,b| a <=> b }
            sum = cards.inject(0) { |total,card| total + card_points_val(card.value) }
            if sum == 15 then
                total_description << "15 for 2"
                hand_points += 2
            end if

            counts = Hash.new(0)
            cards.each { |card| counts[card.value] += 1 }
            
            if cards.length == 2 && cards[0].value == cards[1].value
                total_description.push("two of a kind for 2");
                hand_points += 2  #2 of a kind.
            end

            straight_cards = [Card.new(:diamond,:two),Card.new(:heart,:four),Card.new(:spade,:five)]
            
            if cards.length >= 3 then
                isStraight = true
                first_pos = VALUES.index(cards[0].value)
                cards[1..-1].each_with_index do |card,index|
                    isStraight = false unless VALUES.index(card.value) == first_pos + index + 1
                end
                if isStraight then
                    last_card_index = VALUES.index(cards[-1].value)
                    prev_card_val = first_pos != 0 ? VALUES[first_pos-1] : nil
                    next_card_val = VALUES[last_card_index+1]
                    if cards_with_starter.none? { |card| card.value == next_card_val || card.value == prev_card_val } then
                        total_description << "straight for " + cards.length.to_s
                        hand_points+=cards.length
                    end
                end
            end

            if cards.length == 1 && cards.any? { |card| card.value == :jack && card.suit == starter.suit } then
                total_description << "nobs for 1"
                hand_points += 1
            end
            
        end
        suit = @cards[0].suit
        if @cards.all? { |card| card.suit == suit } then
            if starter.suit == suit then
                total_description << "flush for 5"
                hand_points += 5
            elsif !@is_crib then
                total_description << "flush for 4"
                hand_points += 4
            end
        end 
        output = {:points=>hand_points,:description=>total_description}
        @points = output
        return output

    end

    def card_points_val(value)
        points_hash = { :ace=>1,:two=>2,:three=>3,:four=>4,:five=>5, :six=>6,:seven=>7,:eight=>8,:nine=>9,:ten=>10,:jack=>10,:queen=>10,:king=>10 }
        points_hash[value]
    end

    def permute(items)
        # debugger
        perms = []
        (1..items.length).each do |arr_length|
            perms.concat(items.combination(arr_length).to_a)
        end
        perms
    end

end