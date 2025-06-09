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
    * **Decision Buttons:** When a player lands on an unowned, purchasable property, a Buy and a Pass button will appear for the player to make a decision. 

3.  **Gameplay Interaction:**
    * The current player initiates their turn by clicking the "Roll Dice" button.
    * The UI will update the player's token to its new position on the board.
    * Game messages will update to reflect the roll and landing spot.
    * If a property purchase decision is required, the "Buy" and "Pass" buttons become active. 
    * If rent is due, it will be automatically deducted and paid; the UI will reflect the updated money totals for both players involved and display a message.
    * The turn indicator will then switch to the next player.

4.  **Game End:**
    * When a player's money drops below zero, a game message will declare them bankrupt and the game ends.

  
# Controls

* Mostly involves clicking with the mouse on the different popups on screen (roll, purchase, etc)
* Dice Roll Override --> To override the dice roll, press the key "o" when the "Roll Dice" popup is on screen. Then input a number between 2 and 12 and press "enter".
* Jail Override --> To send the current player to jail instantly, press the key "j" when the "Roll Dice" popup is on screen.
* Mortgage/Selling Override --> To sell/mortgage properties without going into debt, press the "m" key to open the mortgaging popup. Press "m" again to close the popup,
* Cash Override --> To manually set how much money the player currently has, press "c" when the "Roll Dice" popup is on screen. Then input a number at least $0 and press "enter". 