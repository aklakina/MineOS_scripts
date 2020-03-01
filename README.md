# MineOS_scripts
This repository contains my self-made scripts for MineOS node for linux made by hexparrot
These scripts are my self-made linux shell scripts to make server owners' life easier and more comfortable.
# A few words about my scripts:
  So first of all if you decided to clone this repo then please run the installer as root. It asks for everything you need to run my scripts perfectly. ***Everything can be changed later on!*** From later on you just need to run the updater if you want to update the clone.

  The data.txt is used in the start script and the starts is a command with arguments based editor for the data.

  mc_command_handler should be started when the server starts up (but i couldn't get it to work that way so the user needs to start it manually as root which the installer asks if you want to) and it is safe for common usage since it runs every command in the name of the actual user who sends it to the console. If that user does not exist it simply writes he don't have permission to give commands to the main server.

  memory_out just writes out the current memory usage of the mc servers and the max and the percent of course.

  Starts is the argument based editor for the data.txt while start is the script that uses the data from the data.txt.
  
  Memory_controller is a script that prevents memory overflow (by restarting the server after a 2 minutes default countdown).
  
  Auto_backup is a configurable .tar.gz maker.

  Server_prop_changer changes the properties file of every server so the user do not have to do it manually. Configurable.  
  
# How do they work?
memory_controller.sh is a simple script that checks the server processes and the actual memory usage compared to the max memory given in the webui's java arguments. If it hits 93% (it is configurable in the script by editing the line let "max_mem=$max_mem1*93/100" with changing the 93), then it writes out a 2 minutes countdown. After the 2 minutes countdown it restarts the server.

start is a script which reads the data.txt (which you should create in the /var/games/minecraft/ directory and it should contain the servers' names divided by enter) and checks if they are up and running. If not this scripts starts them. This is only a failsafe because as i observed memory_controller.sh is not restarting them properly all the time and it rarely fails. ***the server names should not contain space***

starts is the data.txt handler which reads and writes the **data.txt at /var/games/minecraft**. It has argument configuration where no arguments lists all the items of the data.txt, first argument should be a name of an already existing server (which by itself gives back if it is a part of the table or not), second should be add or remove to add the server to the table or delete it from it respectively. Remove argument needs a confirmation which could be given by a force argument as 4th argument which should be y or Y.

memory_out should be run by the actual user. It writes out current memory usage by servers/given in the argument and the usage percent

mc_command_handler is used to make life "easier" in the view of server owners. This script tails the mc server log and if it catches any precise line that happens if you write #... in the minecraft chat then it tries to run the text after it as a linux command in the server and after that it pumps the output back to the minecraft chat. It does every command in your linux account name but because of that you have to log in to your minecraft server with your linux account name so this would work. I had to configure it that way so this script won't leave a black hole in your security system to like anyone who wants your server to their own. If you try to run a linux-side command as a non-linux user in mc then it will just drop back the text "you do not have the permission to run linux-side commands". Of course you can't give commands which waits for another input 'cause it simply will bug out and you will have to kill and restart the tailing process. If you are an expert enough then you could actually write a whole linux script using touch command. (**try it on your own responsibility**)

status_checker is just controlling mc_command handler so it won't overflow your server with background jobs with infinite tailing processes. ***Trust me it is better to keep this thing crontabbed...***

Schedule a restart on change is exactly does that. If you change anything in the server.properties then this script checks for the default_timer.txt... well for time. You can give it as hh:mm 24-hour format or seconds. If everybody leaves the server the script will restart it automatically.

Timer is the child script of the restart scheduler.

Updater is exactly that... it updates everything and runs everything you need.

Installer is again... an installer which makes everything for the user so my scripts run perfectly.

Security is a script for solving the root security issue with the mc_commands_handler. In an offline-mode server this bans the root player so you can't sign in to the server with it and that way it protects your server. ***Believe me it would be bad if someone would sign in with root.***

Auto_backup is again... that. Well seems like i am bad at naming things. ***May God have mercy on my future child.*** So anyway. Anyway this little script helps you with keeping a backup about all your servers at a cosutme directory. You can also define how many backups you want to keep and which day interval should it ran by the crontab.

Backup_config is asking for the default path and the default amount of saves for auto_backup.

Server_prop_changer is a script the automates your port distribution (randomly generates a port for each server in the range of 25500 and 25600) and after that sets your iptable config to do not drop any connection on that port. It logs everything and you can use the Ports script to get this log.

Ports writes out which server use which port and controls the iptable.

# crafty (it is in the crafty branch)
Crafty is another project i am currently working on with the main team. It is similar to MineOS i just made an installer for it with a GUI based on internet explorer. The .exe has a few security issues so if you would not want to risk it then run the .ps1. It does the same you just need 1 more click to run it.
Crafty wiki is linked in the installer.
