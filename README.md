# Etheroulette

    Rules of our Roulette :
        BetTypes are as follow:
            0: color
            1: modulus
            2: number

    Depending on the BetType, number will be:
        color: 0 for black, 1 for red
        modulus: 0 for even, 1 for odd
        number: number
            
    A bet is valid when:
        the value of the bet is correct (=betPrice)
        betType is known (between 0 and 2)
        the option betted is valid (don't bet on 37!)
        the bank has sufficient funds to pay the bet
