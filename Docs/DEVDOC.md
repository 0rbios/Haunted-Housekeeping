# Haunted Housekeeping - DevDoc
__*An Arcade Cleaning Game with Ghosts*__
<br><br>

See Also:
<br>&nbsp;&nbsp;&nbsp;[**README**](./README.md) | [**Changelog**](./CHANGELOG.md) | [**Todo**](./TODO.md)

<br>

> DEVDOC - Current Version : 0.1

## Table of Contents
- [Game Structure](#game-structure)
- [Player Module](#player-module)
- [Ghost Module](#ghost-module)
- [Objects](#objects)
- [Dirt](#dirt)
- [Maps](#maps)
- [Servers](#servers)

## Game Structure
The game will be loaded through one main game node. This node will generate and direct to any supplied management nodes.

The main manager nodes of concern are:
* Data Manager - Stores, Updates and Shares global variables.
* Scene Manager - Loads and changes the active scenes (e.g. maps, HUD and menus).
* Network Manager - Sends and Recieves multiplayer signals between players and servers.

## Player Module
When a player enters a map, they create a player module which they can control.
A player module can move, pick up objects, interacts with ghosts and use objects.

Players can move up, down, left and right. Up and down move along the x axis. Left and right move along the z axis. Movement along the y axis will occur automatically by snapping the player to the nearest object to their feet.

If a player presses the opposite button while holding a direction (e.g. pressing up while moving down), they will move in the new direction until the key is released. At which point, if the original key is still being held, the player will begin moving in their original direction again.

Players can pick up an object by walking over it and pressing the interact button. They can switch between the objects in their inventory by pressing the next and previous item buttons. They can use an item by pressing the use button or drop by pressing the drop button.

Each player module can hold up to three items at once, one in their hands and two in their inventory.

## Ghost Module
Ghosts are NPCs which exists on maps. There are several different actions which a ghost can choose to do at random. They are as follows:

* Wait - Start a timer between 0.1 and 3.0 seconds.
* Move - Select a random unoccupied spot on the ground and move directly towards it in a straight line.
* Pick up item - Finds the nearest unheld item, moves to it in the same way as the move action, and put it in the ghost's hands. If the player is holding an item already, it will drop it at its feet before picking up the new item.
* Steal item - The same as the pick up item action but selects a held item that isn't in a player's inventory instead. If an item is dropped, instead of on the floor, it will be placed in the player's inventory to replace the stolen item.
* Grab player - Finds the nearest player, moves directly to them and grabs them. The player will no longer be able to move (they can still rotate) while being held and will follow the ghost whenever it moves.

A ghost will drop its held item if it wants to pick up a new item or if it is hit by a player.

## Objects
Objects are items which can be used to clean dirt. Both players and ghosts can pick up and hold objects, however, only players can use objects or hold more than one item.

Each object has different types of dirt which it can clean. Additionally, some objects have special impacts on the world around them.

## Dirt
Dirt is placed onto the map when it is loaded. The state of each dirt is stored and regularly updated. The dirt state will first be updated, with cleaned being the priority state over uncleaned. The dirt will then make sure its state is correct against the world state.

A map is complete when all dirt reports as cleaned.

There are several types of dirt. Dirt type is determined by location. The dirt types are as follows:

* Leaves - Spawn outside on the ground, within a given distance of a tree.
* Weeds - Spawn outside on the ground.
* Dust - Spawns inside on any surface.
* Grime - Spawns on any surface.
* Mold - Spawns on any surface near a water source.
* Mud - Spawns on the ground outside if raining. Can also spawn near doors and can be spread by players.
* Puddles - Spawn on the ground near water sources, or doors/windows if raining.
* Spiderwebs - Spawn inside in room corners.

## Maps
Every map uses a flat cube as its base with objects placed on top. The colour of this cube will default to green but is changed by the map details. The default size of the cube will be 10x10 but this can also be changed in the details to 1x1 or more.

Maps also store several pieces of data about a game area. Each map stores dirt, ghosts, a map model and the weather state.

If a map is loading and a part of the data is invalid or missing, it will fall back to a default value, usually 0 or null.

## Servers
Players log in to a server, and can then start or join a game. When starting a game, players can add a code to keep unwanted players out of their game. When a player creates or joins a game, they will then be taken to a game lobby, where they can ready up. When all players are ready a three second countdown will begin before the game begins. Once a game begins or the lobby is full, the game will no longer be visible to other players. However, players can leave a game at any time they wish with the caveat that they won't be able to rejoin.
