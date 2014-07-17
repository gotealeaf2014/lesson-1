require 'pry'
# deck of cards contains 52 cards
# - 4 suits of Ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, jack, queen, king
# - suits are club, diamond, heart, and spade
# - each card is worth the face value except all suit cards are worth 10 and aces can be worth 1 or 11
# - There are two players, player and dealer
# - Each player is dealt 2 cards randomly from the deck
# - Player chooses to hit with random card from deck or stay to keep existing cards
# - Dealer must hit until sum of 17
# - If dealer busts, player won, if dealer hits 21, dealer wins, else dealer stays, higher sum between players wins

player = {}
dealer = {}
players = {"player" => "", "dealer" => ""}

clubs = { "clubs_ace" =>10, "clubs_2" => 2, "clubs_3" => 3, "clubs_4" => 4, "clubs_5" => 5, "clubs_6" =>6, "clubs_7" => 7, "clubs_8" => 8, "clubs_9" =>9, "clubs_10" => 10, "clubs_jack" => 10, "clubs_queen" => 10, "clubs_king" =>10}
diamonds = { "diamonds_ace" =>10, "diamonds_2" => 2, "diamonds_3" => 3, "diamonds_4" => 4, "diamonds_5" => 5, "diamonds_6" =>6, "diamonds_7" => 7, "diamonds_8" => 8, "diamonds_9" =>9, "diamonds_10" => 10, "diamonds_jack" => 10, "diamonds_queen" => 10, "diamonds_king" =>10}
hearts = { "hearts_ace" =>10, "hearts_2" => 2, "hearts_3" => 3, "hearts_4" => 4, "hearts_5" => 5, "hearts_6" =>6, "hearts_7" => 7, "hearts_8" => 8, "hearts_9" =>9, "hearts_10" => 10, "hearts_jack" => 10, "hearts_queen" => 10, "hearts_king" =>10}
spades = { "spades_ace" =>10, "spades_2" => 2, "spades_3" => 3, "spades_4" => 4, "spades_5" => 5, "spades_6" =>6, "spades_7" => 7, "spades_8" => 8, "spades_9" =>9, "spades_10" => 10, "spades_jack" => 10, "spades_queen" => 10, "spades_king" =>10}

deck = clubs.merge(diamonds).merge(hearts).merge(spades)

def deal(card, hand)
  card_select = card.to_a.sample
  hand[card_select[0]] = card_select[1]
  card.delete(card_select.first)
end

def start_game(start, player, dealer, players)
	2.times { deal(start, player) }
	2.times { deal(start, dealer) }
  puts "Player hand: #{player.keys}"
  eval_hand(player, players, "player")
  check_winner(players)
end

def eval_hand(hand, players, player)
  if hand.values.inject(:+) == 21
    players[player] = "blackjack"
    return nil
  elsif hand.values.inject(:+) > 21
    players[player] = "bust"
    return nil
  else return nil
  end
end

def aces(hand)
  if hand.values.inject(:+) > 21
    hand.each do |key, value|
      if key =~ /.*ace/
        hand[key] = 1
      end
    end
  end
end

def dealer_turn(card, hand, players)
  while hand.values.inject(:+) < 17
    deal(card, hand)
    aces(hand)
    eval_hand(hand, players, "dealer")
  end
  if hand.values.inject(:+) < 21
    players["dealer"] = "stay"
  elsif hand.values.inject(:+) == 21
    players["dealer"] = "blackjack"
elsif hand.values.inject(:+) > 21
    players["dealer"] = "bust"
  end
end

def check_winner(players)
  if status = players.invert["bust"]
    puts "#{status} busts!"
  elsif status = players.invert["blackjack"]
    puts "Blackjack! #{status} wins!"
  end
end

def compare_values(players, player, dealer)
    hands = {"player" => player.values.inject(:+), "dealer" => dealer.values.inject(:+)}
    max = [player.values.inject(:+), dealer.values.inject(:+)].max
    puts "#{hands.invert[max]} wins!"
end

start_game(deck, player, dealer, players)
#player = {"spades_queen" => 10, "clubs_ace" => 10, "clubs_two" => 2}

#until check_winner(player)
until players["player"] != ""
  puts "Hit or Stay?"
  choice = gets.chomp.downcase
    if choice == "hit"
      deal(deck, player)
      puts "Players hand: #{player.keys}"
      aces(player)
#      puts player.values.inject(:+)
      eval_hand(player, players, "player")
      check_winner(players)
    elsif choice == "stay"
      players["player"] = "stay"
    end
end
    dealer_turn(deck, dealer, players)

if players["dealer"] = "stay" && players["player"] == "stay"
    puts "Player hand: #{player.keys}"
    puts "Dealer hand: #{dealer.keys}"
    compare_values(players, player, dealer)
end
