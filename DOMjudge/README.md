#23.11.22   

---
#DOMjudge 8.2.2 stable auto installation   
<https://www.domjudge.org/>   

#Prerequisite
- Ubuntu 22.04 LTS Server/Desktop installed (AWS OK)   

#Auto installation commands and steps...
<pre><code>wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj822dj.sh</code></pre>
<pre><code>bash dj822dj.sh</code></pre>

<pre><code>
Select Web-server for DOMjudge!   
apache2 or nginx? [apache2/nginx]:                    // <- apache2 or nginx   
...   
...                                                   // select timezone   
...   
Enter current password for root (enter for none) :    // <- enter   
...   
Switch to unix_socket autentication [Y/n] :           // <- n   
...   
Change the root password? [Y/n] :                     // <- y      //You must! change mariaDB's root password!    
New password:                                         // <- ????   //Enter your password!!    <- #1    
RE-enter new password:                                // <-        //Repeat your password!!    
...   
Remove anonymous user? [Y/n] :                        // <- y   
...   
Disallow root login remotely? [Y/n] :                 // <- y   
...   
Remove test database and access to it? [Y/n] :        // <- y   
...   
Reload privilege tables now? [Y/n] :                  // <- y   
...   
Press [ENTER] to continue or Ctrl-c to cancel.        // <- enter   
...   
Press [ENTER] to continue or Ctrl-c to cancel.        // <- enter   
...   
Database credentials read from '/opt/domjudge/domserver/etc/dbpasswords.secret'.   
Enter password:                                       // <- ????   //Enter your (#1) password!!    
DOMjudge database and user(s) created.   
Enter password:                                       // <- ????   //Enter your (#1) password!!    
...   
Sytem will be rebooted in 20 seconds!    
20    
19   
.     
.    
.    
3    
2    
1   
</code></pre>
    
    
    
---    
#After rebooted, judgehosts must be started by manually!   
#To start judgehosts...
<pre><code>bash dj822start.sh</code></pre>
Judgehosts will be automatically started depending on the number of CPU cores...   
<pre><code>

 // Clearing the cache for the prod environment with debug false                     
                                                                                
 [OK] Cache for the "prod" environment (debug=false) was successfully cleared.  
                                                                                
DOMjudge cache cleared!
DOMjudge webserver cache cleared!

CPU(s):                          ?
Thread(s) per core:              ?

Starting create cgroups...
create cgroups started!

Starting judgedaemon...
start judgedaemon-run-0...
judgedaemon-run-0 started!
    
    
CPU information
CPU(s):                          ?
Thread(s) per core:              ?
? judgedamons started!
    
</code></pre>

---
#To login DOMjudge as admin, admin password needed.
#DOMjudge admin password saved in domjudge.txt    
#To check DOMjudge admin password...    
<pre><code>cat domjudge.txt</code></pre>

<pre><code>
...    
http://localhost/domjudge/    
admin ID : admin    
admin PW : ????????????????    
...    
</code></pre>    
    
---
#To domserver http web cache clearing    
<pre><code>bash dj822clear.sh</code></pre>
    
<pre><code>
 // Clearing the cache for the prod environment with debug false    
                                                                                
 [OK] Cache for the "prod" environment (debug=false) was successfully cleared.  
    
DOMjudge cache cleared!
DOMjudge webserver cache cleared!
</code></pre>
    
---
#To kill some judgedaemon processe    
<pre><code>ps -ef, and find pid# of judgedaemon, run : kill -9 pid#</code></pre>
    
    
---
#To clear domserver web cache    
<pre><code>sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*</code></pre>
    
#To clear DOMjudge cache    
<pre><code>sudo /opt/domjudge/domserver/webapp/bin/console cache:clear</code></pre>
    
---
#To use korean interface for korean middle & high students participants    
#To replace participants interface, english to korean...    
<pre><code>wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj822kr.sh</code></pre>
<pre><code>bash dj822kr.sh</code></pre>
    
<pre><code>
...
Rename DOMjudge logo name? [y/n]:      // <- y/n    //If you want to change DOMjudge name, enter y.
...
Enter  DOMjudge NAME : ????            // <- ????   //Enter  new contest short name!!
Repeat DOMjudge NAME : ????            // <-        //Repeat
...
DOMjudge 8.2.2 stable 23.10.20
DOMjudge participants' korean interface installed!
For korean middle & high school students.

Check DOMserver's web interface!
------
http://localhost/domjudge/
</code></pre>
        
---
#spotboard for DOMjudge   
<https://github.com/spotboard/spotboard>

#Prerequisite   
- DOMjudge(server + judgehost) installed   

#Installation commands to install spotboard for DOMjudge   

<pre><code>wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/sb070.sh</code></pre>
<pre><code>bash sb070.sh</code></pre>
    
    
#After judgehosts installed.
<pre><code>
Check spotboard!
------
http://localhost/spotboard/dist/

configuration for spotboard
check & edit /var/www/html/spotboard/dist/config.js

Next step : install spotboard-converter

</code></pre>
    
    
---
#spotboard-converter for spotboard   
<https://github.com/spotboard/domjudge-converter>

#Prerequisite   
- DOMjudge(server + judgehost) installed server   
- spotboard installed    
- spotboard account with 'Jury User' Roles : added with DOMjudge web interface   
    ex)   
    ID: spotboard   
    PW: spotboard   
    Roles: Jury User    

#Installation commands to install spotboard-converter for domjudge   

<pre><code>wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/sbc070.sh</code></pre>
<pre><code>bash sbc070.sh</code></pre>

#After spotboard-converter installed.
<pre><code>
domjudge-converter for domjudge installed!!
Ver 2020.10.19

------ npm start every reboot ------
run : cd dcm
run : setsid npm start &
Check spotboard!

------
http://localhost/spotboard/dist/

configuration for domjudge-converter
check and edit ~/dcm/config.js
</code></pre>



---   

#2021.10.20   
#How to make spotboard's Awards Ceremony data    
    
<pre>
0. Stop spotboard npm    
  - After Contest's 'End time', stop npm.    
  ; Just DOMjudge server reboot? OK!    
  ; ex)
  ; sudo reboot
  ; + do not start DOMjudge judgehosts
  ; + do not start spotboard npm
     
1. Find submission id number after freeze time.    
  - Login to admin page.
  - Find the 'ID' number just after 'Scoreboard freeze time' at admin Submissions page.    
  ; ex) 563 <- s563   
     
2. Set freeze time to end time temporarily.    
  - Set 'Scoreboard freeze time' to 'End time' temporarily, and save contest at admin Contest edit page.   
  ; ex) 2021-10-16 12:00:00 Asia/Seoul -> 2021-10-16 12:30:00 Asia/Seoul    
     
3. Run npm start once.    
  - At spotboard domjudge-converter directory, run npm start.
  ; ex)
  ; cd dcm    
  ; npm start   
  ; ctrl+c (just wait... 1 or more refresh cycle time would be OK!)    
  (This makes contest.json & runs.json files to .../spotboard/dist/ directory.)    
     
4. Set freeze time to original freeze time.    
  - Set 'Scoreboard freeze time' to original freeze time at admin Contest edit page.   
  ; ex) 2021-10-16 12:30:00 Asia/Seoul -> 2021-10-16 12:00:00 Asia/Seoul   
  (This makes DOMjudge scoreboard freezing)
     
5. Copy award_slide.json sample file.
  - Copy sample award_slide.json file from .../spotboard/dist/sample/ to .../spotboard/dist/  
  ; ex)
  ; cd /var/www/html/spotboard/dist/sample    
  ; sudo cp award_slide.json ../award_slide.json.   
     
6. Edit award_slide.json file to the contest.    
  ; meaning)
  ; "id"    : team ID at admin's Teams page
  ; "rank"  : prize name to display
  ; "icon"  : ... not working... but I don't know why now.  icon(*.png) path : .../spotboard/dist/img/award/
  ; "group" : teamname to show
  ; "name"  : member names to show
     
  ; award_slide editing ex)

[
    {
        "id": 21,
        "rank": "456억 상",
        "icon": "crown_gold",
        "group": "쑥쑥코딩",
        "name": "정00 박00"
    },
    {
        "id": 25,
        "rank": "오징어게임 상",
        "icon": "crown_silver",
        "group": "밤마니",
        "name": "임00 정00"
    },
    {
        "id": 33,
        "rank": "무궁화꽃이 피었습니다 상",
        "icon": "crown_bronze",
        "group": "꼴찌-1",
        "name": "이00 강00 장00"
    },
    {
        "id": 15,
        "rank": "달고나 상",
        "icon": "crown_gold",
        "group": "Sheep_Coding",
        "name": "성00 이00"
    },
    {
        "id": 23,
        "rank": "구슬치기 상",
        "icon": "award_star_gold_green",
        "group": "벌써3년",
        "name": "문00 송00 김00"
    },
    {
        "id": 9,
        "rank": "줄다리기 상",
        "icon": "draw_star",
        "group": "team-yul",
        "name": "박00 신00"
    }
]
</pre>
    
#2021.10.20   
#How to make spotboard's Awards Ceremony    
<pre>
0. Open web browser and clear spotboard's cache
    
1. Open spotboard's Awards Ceremony URL
  ; ex)
  ; http://gtpc.kr/spotboard/dist/?r=563&award=true

2. Use enter & ESC key
  ; Use 'enter' or ';' or '→' key to next team opening.
  ; Use 'ESC' key to escape award screen.
  ;    (When awarded screen passed by mistake, just click the teamname at leftside of spotboard.)
  

X. Spotboard scoreboard options & variations
- usage
../spotboard/dist/?q                              <- query

- visual effect
../spotboard/dist/?animation=false                <— flip/move animation off   

- award ceremony
../spotboard/dist/?award=true                     <— Awards Ceremony start   
../spotboard/dist/?award=true&award_rank_begin=3  <— Awards Ceremony start from top rank 3, use with award=true   

- contest simulation
../spotboard/dist/?r=1                            <— Contest simulation start from 1(first) submission     
../spotboard/dist/?time=91                        <— Contest simulation start from 91 minutes after contest start time   

- one team trace
../spotboard/dist/?t=21                           <— trace #21 team   
../spotboard/dist/?t=21&r=1                       <— trace #21 team from submission 1 in simulation   
../spotboard/dist/?t=21&time=91                   <— trace #21 team from 91 minutes in sumulation


</pre>
     
     
---   
     
     
