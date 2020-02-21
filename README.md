# MineOS_scripts
This repository contains my self-made scripts for MineOS node for linux made by hexparrot
These scripts are my self-made linux shell scripts to make server owners' life easier and more comfortable.
# A few words about my scripts:
  There are a few crontab based scripts.
    -memory_controller.sh
    -start
    -status_checker

  The data.txt is used in the start script and the starts is a command with arguments based editor for the data. (which needs some changes tho)

  mc_command_handler should be started when the server starts up (but i couldn't get it to work that way so the user needs to start it manually as root) and it is safe for common usage since it runs every command in the name of the actual user who sends it to the console. If that user does not exist it simply writes he don't have permission to give commands to the main server.

  memory_out just writes out the current memory usage of the mc servers and the max and the percent of course.

  starts and memory_out should be in /bin (or any other path) so the user can reach them easily.
  
#just to skip a header

# How do they work?
	memory_controller.sh is a simple script that checks the server processes and the actual memory usage compared to the max memory given in the webui's java arguments. If it hits 93% (it is configurable in the script by editing the line let "max_mem=$max_mem1*93/100" with changing the 93), then it writes out a 2 minutes countdown. After the 2 minutes countdown it restarts the server.
	start is a script which reads the data.txt (which you should create in the /var/games/minecraft/ directory and it should contain the servers' names divided by enter) and checks if they are up and running. If not this scripts starts them. This is only a failsafe because as i observed memory_controller.sh is not restarting them properly all the time and it rarely fails. ***the server names should not contain space***
	starts is the data.txt handler which reads and writes the data.txt. It has argument configuration where no arguments lists all the items of the data.txt, first argument should be a name of an already existing server (which by itself gives back if it is a part of the table or not), second should be add or remove to add the server to the table or delete it from it respectively. Remove argument needs a confirmation which could be given by a force argument as 4th argument which should be y or Y.
	memory_out should be run by the actual user. It writes out current memory usage by servers/given in the argument and the usage percent.
	mc_command_handler is used to make life "easier" in the view of server owners. This script tails the mc server log and if it catches any precise line that happens if you write #... in the minecraft chat then it tries to run the text after it as a linux command in the server and after that it pumps the output back to the minecraft chat. It does every command in your linux account name but because of that you have to log in to your minecraft server with your linux account name so this would work. I had to configure it that way so this script won't leave a black hole in your security system to like anyone who wants your server to their own. If you try to run a linux-side command as a non-linux user in mc then it will just drop back the text "you do not have the permission to run linux-side commands". Of course you can't give commands which waits for another input 'cause it simply will bug out and you will have to kill and restart the tailing process. If you are an expert enough then you could actually write a whole linux script using touch command. (try it on your own responsibility)
	status_checker is just controlling mc_command handler so it won't overflow your server with background jobs with infinite tailing processes. You should run this script first and schedule a crontab for it (HIGHLY RECOMMENDED).
# crafty
Crafty is another project i am currently working on with the main team. It is similar to MineOS i just made an installer for it with a GUI based on internet explorer. The .exe has a few security issues so if you would not want to risk it then run the .ps1. It does the same you just need 1 more click to run it.
Crafty wiki is linked in the installer.
