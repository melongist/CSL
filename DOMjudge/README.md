#21.09.24   

---
#DOMjudge 7.3.3 stable installation   
<https://www.domjudge.org/>   

#Prerequisite
- Ubuntu 20.04 LTS Server/Desktop installed (AWS OK)   

#Installation commands
<pre><code>
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj733dj.sh
bash dj733dj.sh
</code></pre>
#While installing...   
<pre><code>
...   
Enter current password for root (enter for none) :    // <- Enter   
...   
Switch to unix_socket autentication [Y/n] :           // <- n   
...   
Change the root password? [Y/n] :                     // <- y      //You must change mariaDB's root password!    
New password:                                         // <- ????   //Enter new password!!    <- #1    
RE-enter new password:                                // <-        //Repeat new password!!    
...   
Remove anonymous user? [Y/n] :                        // <- y   
...   
Disallow root login remotely? [Y/n] :                 // <- y   
...   
Remove test database and access to it? [Y/n] :        // <- y   
...   
Reload privilege tables now? [Y/n] :                  // <- y   
...   
Database credentials read from '/opt/domjudge/domserver/etc/dbpasswords.secret'.   
Enter password:                                       // <- ????   //Enter your new (#1) password!!    
DOMjudge database and user(s) created.   
Enter password:                                       // <- ????   //Enter your new (#1) password!!    
...   
</code></pre>
#After DOMserver installed.
<pre><code>
DOMjudge 7.3.3 stable 21.04.05    
DOMserver installed!!    
    
Check below to access DOMserver's web interface!    
------    
http://localhost/domjudge/    
admin ID : admin    
admin PW : ????????????????    
    
admin PW saved as domjudge.txt.   
Next step : installing judgehosts    
    
</code></pre>
---
#DOMjudge judgehosts installation   
<https://www.domjudge.org/>   

#Prerequisite
- DOMjudge(server) installed   

#Installation commands to install judgehosts at the same DOMserver   
#with default 1 judgehost + 2 more judgehosts
<pre><code>
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj733jh.sh
bash dj733jh.sh
</code></pre>

#After judgehosts installed    
<pre><code>
    
DOMjudge 7.3.3 stable 21.04.05    
judgehosts installed!!    
    
------ Run judgedamons after every reboot ------    
sudo /opt/domjudge/judgehost/bin/create_cgroups    
sudo -u ubuntu DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=1 setsid /opt/domjudge/judgehost/bin/judgedaemon &    
sudo -u ubuntu DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=1 setsid /opt/domjudge/judgehost/bin/judgedaemon -n 0 &    
sudo -u ubuntu DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=1 setsid /opt/domjudge/judgehost/bin/judgedaemon -n 1 &    
    
------ etc ------    
For swift! Check/Edit comple script below at Admin page    
Admin page - Languages - swift - "Compile script  swift" - "View file contents" - Edit    
...    
swiftc -O -module-cache-path "./" -static-executable -static-stdlib -o "$DEST" $SOURCES"    
...    
    
How to kill some judgedaemon processe?    
ps -ef, and find pid# of judgedaemon, run : kill -15 pid#    
    
How to domserver http web cache reset?    
sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*    

Saved as domjudge.txt    
reboot and read domjudge.txt    
     
</code></pre>    
---
#spotboard for domjudge   
<https://github.com/spotboard/spotboard>

#Prerequisite   
- DOMjudge(server + judgehost) installed   

#Installation commands to install spotboard for domjudge   

<pre><code>
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/sb070.sh
bash sb070.sh
</code></pre>

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

<pre><code>
wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/sbc070.sh
bash sbc070.sh
</code></pre>

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

#2021.10.19   
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
  ; ctrl+x (just wait... 1 or more refresh cycle time would be OK!)    
  (This makes contest.json & runs.json files to .../spotboard/dist/ directory.)    
     
4. Set freeze time to original freeze time.    
  - Set 'Scoreboard freeze time' to original freeze time at admin Contest edit page.   
  ; ex) 2021-10-16 12:30:00 Asia/Seoul -> 2021-10-16 12:00:00 Asia/Seoul   
  (This makes DOMjudge scoreboard freezing)
     
5. Copy award_slide.json sample file.
  - Copy sample award_slide.json file from .../spotboard/dist/sample/ to .../spotboard/dist/  
  ; ex)
  ; cd /var/www/html/spotboard/
  ; sudo cp award_slide.json ../award_slide.json
     
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
    
#2021.10.19   
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
  

Options & variations

../spotboard/dist/?q                      <- query ??

../spotboard/dist/?animation=true         <— animation enable   

../spotboard/dist/?award=true             <— start Awards Ceremony mode   
../spotboard/dist/?award_rank_begin=3     <— start Awards Ceremony mode from rank 3, use with award=true   

../spotboard/dist/?r=1                    <— Contest simulation from 1(first) submission     
../spotboard/dist/?time=91                <— Contest simulation from 91 minutes    
    
../spotboard/dist/?t=21                   <— follow #21 team   
../spotboard/dist/?t=21&r=1               <— follow #21 team from submission 1   
../spotboard/dist/?t=21&time=91           <— follow #21 team from 91 minutes   


</pre>
     
     
     
     
     
