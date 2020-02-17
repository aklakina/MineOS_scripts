#!/bin/bash

IFS=$'\n'
for server_name in $(ps -eo rss,ppid,pid,comm | grep "java")
do
namee=$(ps -eo pid,args | grep $(echo $server_name | tr -s ' ' | cut -d ' ' -f2) | perl -pe 's/^\s+//' | tr -s ' ' | cut -d ' ' -f10 | perl -pe 's/^\s+//')
if [[ $namee == *forge*universal.jar* ]] || [[ $namee == *minecraft*server*.jar* ]]; then
name=$(ps -eo pid,args | grep $(echo $server_name | tr -s ' ' | cut -d ' ' -f2) | perl -pe 's/^\s+//' | tr -s ' ' | cut -d ' ' -f4 | cut -d '-' -f2)
memory=$(echo $server_name | tr -s ' ' | cut -d ' ' -f1 | awk '{ hr=$1/1024 ; printf("%13.0f",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' | perl -pe 's/^\s+//')
max_mem1=$(ps -eo pid,args | grep $(echo $server_name | tr -s ' ' | cut -d ' ' -f2) | perl -pe 's/^\s+//'  | tr -s ' ' | cut -d ' ' -f7 | cut -d 'x' -f2 | cut -d 'M' -f1)
memper=1
let "memper=$memory*100/$max_mem1"
let "max_mem=$max_mem1*93/100"
cd /usr/games/minecraft
(if [[ $memory -gt $max_mem ]]; then 
echo "$(date +%c) $name $memory/$max_mem1   $memper%" >> /var/games/minecraft/log.txt
./mineos_console.js -s $name stuff "say Memoria tultelitodes megelozese erdekeben 2 perc mulva uraindul a szerver, $memper%"
sleep 60
./mineos_console.js -s $name stuff "say 1 perc mulva ujraindul"
sleep 30
for i in {0..29}
do
let "a=30-$i"
./mineos_console.js -s $name stuff "say $a masodperc"
sleep 1
done
./mineos_console.js -s $name restart
fi)&
fi
done


#while [ $a -lt 1]
#do
#if cat "/var/games/minecraft/servers/$name/logs/latest.log" | grep -q ".*net.minecraft.server.dedicated.DedicatedServer.*: Done.*"; then
#let "a=$a+1"
#else
#sleep 1
#let "b=b+1"
#fi
#done
#mail -s "$name: Szerver újraindítás" tret2100@gmail.com <<< "A $name szerver 2 percen belül újraindul memória túltelítõdés megelõzése érdekében.
#Jelenlegi memória/max memória: $memory/$max_mem MiB $memper%.
#$(date +%c).
#Újrainduláshoz szükséges idõ: $b másodperc."
#cut -d " " -f 1 $(ps -eo rss,ppid | sort -b -k3 -r | head -n 1)
#ps -eo rss,ppid | sort -b -k3 -r | head -n 1 | tr -s ' ' | cut -d ' ' -f2 (vagy -f1)
#memory=$(ps -eo rss,ppid | sort -b -k3 -r | head -n 1 | tr -s ' ' | cut -d ' ' -f1 | awk '{ hr=$1/1024 ; printf("%13.0f",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }')
#server_name=$(ps -eo pid,args | grep $(ps -eo rss,ppid | sort -b -k3 -r | head -n 1 | tr -s ' ' | cut -d ' ' -f2) | tr -s ' ' | cut -d ' ' -f5 | cut -d '-' -f2)
