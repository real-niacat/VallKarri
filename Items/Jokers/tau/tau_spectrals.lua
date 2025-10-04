SMODS.Atlas {
    key = "tauspec",
    px = 71,
    py = 95,
    path = "tauic_spectrals.png"
}

--[[



familiar - destroy ALL cards held in hand, create an enhanced face card for each destroyed card, then give all cards held-in-hand a random edition
grim - destroy ALL cards held in hand, create an enhanced ace for each destroyed card, then give all cards held-in-hand a random seal
incantation - destroy ALL cards held in hand, create an enhanced numbered card for each destroyed card, then *balance* the suit and rank of all cards held in hand 
talisman - add a Gold Seal to 3 selected cards in hand, if card already has a Gold Seal, upgrade it to a Gilded Seal
aura - Add a random edition to all selected cards, debuff a random card in deck for every 2 editioned cards
wraith - Create a random renowned Joker, disable money for 1 round
sigil - Convert all cards in deck to a random suit, then randomize the suit of all cards which have the most common suit
ouija - Convert all cards in deck to a random rank, then randomize the rank of all cards which have the most common rank
ectoplasm - Select up to 5 cards, destroy selected cards, then convert hand size to joker slots equal to the amount of cards destroyed
immolate - Select 1 card, destroy all cards in deck that share any properties with this card, earn $2 for each destroyed card
ankh - Select 1 joker, destroy all jokers, then create a new version of the selected joker for each joker destroyed
deja vu - add a Red Seal to 3 selected cards in hand, if card already has a Red Seal, upgrade it to an Entropic Seal
hex - apply Cosmic, R.G.B. or Lordly to a random joker, destroy all other jokers
trance - add a Blue Seal to 3 selected cards in hand, if card already has a Blue Seal, upgrade it to an Galactic Seal
medium - add a Purple Seal to 3 selected cards in hand, if card already has a Purple Seal, upgrade it to a Vibrant Seal
cryptid - create 1 copy of each card held in hand, then randomly destroy half of the cards held in hand
soul - create a random legendary joker from vallkarri

black hole:
Level up all hands once, the hand with the lowest level has its level doubled
repeat this until all hands have the same amount of digits as your highest level hand,
multiply all hand levels by the amount of jokers owned, then divide it by the amount of consumables owned
then banish half of all planet cards randomly, x1.5 chips and mult per level on all hands for each planet card banished



related objects:

gilded seal - +$5 when scored, then gives chips equal to money
entropic seal - retrigger once for every card in hand, 1 in 3 chance to self-destruct when triggered, increase denominator by 1 for each safe trigger
galactic seal - when held in hand, level all hands but the played hand, when played, convert 1 level from all other hands to levels for the played hand
vibrant seal - creates a tarot card when discarded, creates a spectral card when played
]]--

SMODS.ConsumableType {
    key = "Spectral_tau",
}