[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/YxXKqIeT)

# The Board Walkers - Monopoly Replica 

**Team Members:** Ardian Agoes & Stephen Chen <br>
**Period:** 3
**VIDEO LINK:** [Video](https://drive.google.com/file/d/13f0Wje4lkenofAnXdwp5caaSzM6CQU9O/view?usp=sharing) 

# Project Description

This project is a replica of the classic board game Monopoly, but CS themed.

For our MVP, the game will include:
* A game board with CS-related property names.
* Player tokens that move around the board.
* Dice rolling 
* UI displaying each player's current money, owned properties, and whose turn it is.
* Core gameplay mechanics:
    * Landing on an unowned property prompts the current player with an option to buy it.
    * Landing on an owned property automatically deducts rent from the lander and pays it to the owner.
    * A player loses if their money drops below $0.
* The MVP will not include: houses/hotels, property sets, auctions, mortgaging, trading, a complex jail system, or complex animations.
* For additions after MVP, we were able to accomplish property sets, mortgaging and selling, jail system. We also added overrides for testing and demo purposes. 

# Intended usage:

1.  **Main Game View:**
    * **Game Board:** A visual representation of the Monopoly board will be at the center of the screen. Properties will visually indicate which player owns them, or if no one owns them.
    * **Player Tokens:** Simple circles will represent each player on the board, visually updating their position as they move.

2.  **Information & Action Panel:**
    * **Turn Indicator:** Text clearly stating whose turn it is.
    * **Player Stats:** For each player, their current money will be displayed.
    * **Dice Roll Area:**
        * A clickable "Roll Dice" Button will be present.
        * After clicking, the results of the two dice and their sum will be communicated through the message log.
    * **Buying Properties:** When a player lands on an unowned, purchasable property, a Buy and a     Pass button will appear for the player to make a decision. 
    * **Mortgaging & Selling:**    
        * If a player goes into debt, they will be forced to sell/mortgage any property they have in order to get out of debt. They will be prompted with a list of their properties that they can go on to choose which ones they want to mortgage/sell. **NOTE/WARNING: mortgaging and selling is irreversible in this game. For example, if a player is -100 in debt, and they have a property that they can mortgage for 60, or sell for 120, and they click mortgage in stead of selling, they will still remain in debt with -40 dollars, and therefore lose / get locked out even though they could've sold the property to get out of debt. Players therefore need to be careful on what they chose to do on the mortgaging/selling screen.**
    * **Un-mortgaging:**    
        * If a player has enough money to mortgage any of their properties, they will get a pop up at the end of their turn asking if they want to buy back one of their properties. If they click yes, they will get a pop up of all the properties they can afford to buy back.
    * **Event Pop Up**    
        * If a player lands on an event (ie, community, chest, tax, jail), they will get a pop up of the event. No further action will be needed. 
    
3.  **Gameplay Interaction:**
    * The current player initiates their turn by clicking the "Roll Dice" button.
    * The UI will update the player's token to its new position on the board.
    * Game messages will update to reflect the roll and landing spot.
    * Events like chance, tax, community, and jail occur automatically. 
    * If a property purchase decision is required, the "Buy" and "Pass" buttons become active. 
    * If rent is due, it will be automatically deducted and paid; the UI will reflect the updated money totals for both players involved and display a message.
    * if a player goes into debt through rent or through events, they will be prompted to sell or mortgage properties to get money back. If they do the later, they can buy back the property after collecting enough moeny at the end of their turn. 
    * If the player rolled a double, then the player gets another turn. Else, the turn indicator will then switch to the next player.

4.  **Game End:**
    * When a player's money drops below zero and the player can't make up that debt with properties to mortgage and sell, a game message will declare them bankrupt and the game ends.

  
# Controls

* Mostly involves clicking with the mouse on the different popups on screen (roll, purchase, etc)
* Dice Roll Override --> To override the dice roll, press the key "o" when the "Roll Dice" popup is on screen. Then input a number between 2 and 12 and press "enter".
* Jail Override --> To send the current player to jail instantly, press the key "j" when the "Roll Dice" popup is on screen.
* Mortgage/Selling Override --> To sell/mortgage properties without going into debt, press the "m" key to open the mortgaging popup. Press "m" again to close the popup,
* Cash Override --> To manually set how much money the player currently has, press "c" when the "Roll Dice" popup is on screen. Then input a number at least $0 and press "enter". 