# Roblox Movement System
A simple movement system that currently features wall mantle and a player sling ability.

# Current Movement Systems
1) Wall mantle / climb. Players can climb walls that are too tall to be jumped over / on. Works similarly to a wall mantle in FPS games.
2) Sling. Players can sling to a desired position based on their camera look direction. Momentum is carried over if the sling does not hit a wall. 

# Wall Mantle Demo
https://github.com/user-attachments/assets/d4f540a5-7188-40b1-b1f2-860668c0eafc

# Sling Demo
https://github.com/user-attachments/assets/6ad62d86-1fe2-49d0-a611-c131157a570a

# Installation Directions
For simplicity, install all Module_Scripts, Server_Scripts, and Remote Events as the local scripts will utilize them.
Scripts under the Local_Scripts are optional and feel free to pick which system you would like to install.

## Installing Local_Scripts
1) Paste the local scripts from the GitHub "Local_Scripts" folder into the Roblox Studio "StarterPlayerScripts" folder. These scripts must be Local Scripts.
## Installing Module_Scripts
1) Create a folder named "ModuleScripts" in the Roblox Studio "ReplicatedStorage" folder.
2) Create Module Scripts with the same names as the files under the Module_Scripts (GitHub). Then paste the relevant code into each script under the Roblox Studio ModuleScripts folder.
## Installing Server_Scripts
1) Paste all scripts under the "Server_Scripts" GitHub folder into the Roblox Studio "ServerScriptService" folder. 
## Installing Remote Events
Create and name the following Remote Events under the Roblox Studio "ReplicatedStorage" folder. Feel free to find and remove remote events that are not being used by certain MovementSystems, or just install all of them. 
1) TweenClimb
2) BulletSling
3) Run
