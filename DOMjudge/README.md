#24.10.24   
    
---    
DOMjudge 8.3.1 + apache2(with IP address for small contest) + Ubuntu 24.04 <== OK   
DOMjudge 8.3.1 + nginx(with domain name for big contest) + Ubuntu 24.04    <== OK

This scripts works only Ubuntu 24.04 now.

But, this works for PC, AWS EC2, GCE(Google Compute Engine).

Making english PDF manual is scheduled.
    
    
    
File Descripstion    
- dj831server24.sh      : DOMjudge server installation script    
- dj831judgehost24.sh   : DOMjudge judgehost installation script    
    
- dj831servermas24.sh   : auto-scaling php(fpm) processes according to H/W memory size    
- dj831serverclear24.sh : DOMjudge server/webserver cache clearing    
- dj831serverhttps.sh   : DOMJudge server Secured HTTPS installation script    
    
- dj831start24.sh       : judgehost starting script (auto scaling the number of judgehosts)    
    
... etc ...    
    
    
    
    
    
    
Out dated below...  but please refer to below until I make PDF manual.    
    
With changing ...    
dj831server.sh    to dj831server24.sh    
dj831judgehost.sh to dj831judgehost24.sh    
dj831judgehoststart.sh to dj831judgehoststart24.sh    
would be OK.    
    
    

#24.10.25   
    
---    
    
#It is recommended to separate main server and dedicated judgehost server.    
#https://www.domjudge.org/docs/manual/8.3/overview.html#features    
#Each judgehost should be a dedicated (virtual) machine that performs no other tasks.    
#For example, although running a judgehost on the same machine as the domserver is possible,    
#it’s not recommended except for testing purposes.    
#Judgehosts should also not double as local workstations for jury members.    
#Having all judgehosts be of uniform hardware configuration helps in creating a fair, reproducible setup;    
#in the ideal case they are run on the same type of machines that the teams use.    
    
<pre>    
--- For DOMjudge server ---    
    
#DOMjudge 8.3.1 stable    
https://www.domjudge.org/ 
    
   
#DOMjudge server auto installation   
   
#Prerequisite    
- Ubuntu 24.04 LTS PC/AWS EC2/GCE   
    
#Auto installation commands and steps...    
At console terminal    
</pre>
<pre><code>wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj831server24.sh</code></pre>
<pre><code>bash dj831server24.sh</code></pre>
<pre>    
   
Select webserver for DOMjudge!    
apache2 : testing, small contest    
nginx   : big contest    
    
apache2 or nginx? [apache2/nginx]:                    // <- apache2 //apache2 or nginx    
   
...   
    
Please select a continent, ocean, "coord", or "TZ".    
 1) Africa    
    
 ...    
 9) Pacific Ocean    
10) coord - I want to use geographical coordinates.    
11) TZ - I want to specify the timezone using the Posix TZ format.    
#?                                                    // Select your timezone   
    
...   
Enter current password for root (enter for none) :    // Just enter   
    
...   
Switch to unix_socket autentication [Y/n] :           // <- n   
    
...   
Change the root password? [Y/n] :                     // <- y      //You must! change mariaDB's 
root password!    
New password:                                         // <- ????   //Input your own password!! <- Take note PW #1    
Re-enter new password:                                // <-        //Repeat ...    
    
...   
Remove anonymous user? [Y/n] :                        // <- y   
    
...   
Disallow root login remotely? [Y/n] :                 // <- y   
    
...   
Remove test database and access to it? [Y/n] :        // <- y   
    
...   
Reload privilege tables now? [Y/n] :                  // <- y   
    
...    
Enter password:                                       // <- ????   //Use your own PW #1    
DOMjudge database and user(s) created.   
Enter password:                                       // <- ????   //Use your own PW #1    
    
...    
10    
.     
.    
.    
3    
2    
1    
0   
rebooted!    
    
...    
Saved as readme.txt       
      
    
    
</pre>    
---    
<pre>
#After rebooted, check DOMjudge server's web page first!    
    
#To login DOMjudge as admin, password needed.    
#DOMjudge admin password saved in readme.txt    
At console terminal    
</pre>
<pre><code>cat readme.txt</code></pre>
<pre>
    
...    
DOMjudge server(apache2) 8.3.1 stable (2024.09.13) installed!!    
    
Check DOMjudge server's web page    
------    
*Use appopriate URL, according to the server's network connection.    
Private IP URL: http://xxx.xxx.xxx.xxx    
Public  IP URL: http://xxx.xxx.xxx.xxx    
ID : admin    
PW : ????????????????                              // Take note this PW #2    
    
    
Use this URL & PW at the other DOMjudge judgehost
------
*Use appopriate URL, according to the server's network connection.
Private IP URL: http://xxx.xxx.xxx.xxx
Public  IP URL: http://xxx.xxx.xxx.xxx            // Take note this URL(private/public IP  address) URL #1   
judgehost PW : ????????????????                   // Take note this PW #3    
    
---    
    
</pre>    
<pre>
--- For DOMjudge judgehost ---    
    
#DOMjudge 8.3.1 stable    
https://www.domjudge.org/    
    
   
#DOMjudge judgehost auto installation   
   
#Prerequisite    
- Ubuntu 24.04 LTS PC/AWS EC2/GCE   
    
#Auto installation commands and steps...    
At console terminal    
</pre>
<pre><code>wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj831judgehost24.sh</code></pre>
<pre><code>bash dj831judgehost24.sh</code></pre>
<pre>    
Before DOMjudge 8.3.1 stable (2024.09.13) judgehost installation!!!    
    
DOMjudge server must be installed at the other system!!    
    
Did you make Domjudge server? [y/n]:                  // <- y    
    
...       
Please select a continent, ocean, "coord", or "TZ".    
 1) Africa    
    
 ...    
 9) Pacific Ocean    
10) coord - I want to use geographical coordinates.    
11) TZ - I want to specify the timezone using the Posix TZ format.    
#?                                                    // Select your timezone   
    
...    
Input DOMjudge server's URL
Examples:
http://123.123.123.123
http://contest.domjudge.org
https://contest.domjudge.org

Input  server's URL: http://xxx.xxx.xxx.xxx          // Use DOMjudge server's URL #1    
Repeat server's URL: http://xxx.xxx.xxx.xxx          // Repeat...    
    
    
Input DOMjudge server's judgehost PW
You can find judgehost PW at DOMjudge server's /opt/domjudge/domserver/etc/restapi.secret
    
Input  judgehost PW : ????????????????               // Use PW #3    
Repeat judgehost PW : ????????????????               // Repeat...    
     

 
Sytem will be rebooted in 10 seconds!    
    
...    
10    
.     
.    
.    
3    
2    
1    
0   
rebooted!    
    
...    
Saved as readme.txt    
     
        
</pre>
<pre>
#After every DOMjudge judgehost rebooted, judgehost process must be started by manually!    
#Check saved readme.txt    
</pre>
<pre><code>cat readme.txt</code></pre>
    
#To start judgehosts...    
At console terminal    
</pre>
<pre><code>bash dj831start24.sh</code></pre>
<pre>
    
DOMjudge judgehosts starting ...    
    
    
X judgedamons started!    
    
DOMjudge judgehosts starting completed...    
    
            
</pre>
    
    
    
    2024.10.26. Out dated below: 
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
     
     
