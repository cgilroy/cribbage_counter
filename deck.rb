require_relative 'card'

class Deck
    SUITS = [:diamond,:spade,:club,:heart]
    VALUES = [:ace, :two, :three, :four, :five, :six, :seven, :eight, :nine, :ten, :jack, :queen, :king]
    attr_accessor :cards
    def initialize
        cards = []
        SUITS.each do |suit|
            VALUES.each { |val| cards << Card.new(suit,val) }
        end
        @cards = cards
    end

    def shuffle
        @cards.shuffle!
    end

    def take_card(qty)
        raise "Can't take that many cards!" if qty > @cards.length
        return @cards.slice!(0,qty)
    end
end