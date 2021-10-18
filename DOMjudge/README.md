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

------ run npm start every reboot ------
run : cd dcm
run : setsid npm start &
Check spotboard!

------
http://localhost/spotboard/dist/

configuration for domjudge-converter
check and edit ~/dcm/config.js
</code></pre>



---   

#2021.10.18   
#How to make spotboard's Awards Ceremony    
<pre>
0. After 'End Time', stop npm. ; Just system reboot? OK!    
1. Find the ID number just after 'Scoreboard freeze time' from admin's Submissions page. ; ex) 563 <- s563   
2. Set Scoreboard freeze time to 'End time' temporarily, and save contest????????   
3. At spotboard domjudge-converter directory, run npm start, and make contest.json & runs.json to spotboard directory(.../dist/)
4. Set Freeze time to original Freeze time, and save contest. It makes freezing scoreboard of domjudge.   
5. Copy award_slide.json to .../dist/  from .../dist/sample  and edit award_slide.json to contest   
6. From web browser ... .../spotboard/dist/?r=#1&award=true  and use "enter" & "esc" key to Ceremony   
7. After Awards Ceremony ...   
</pre>

#spotboard index.html addon options    
You need to clear web browser's cache to see it properly   
<pre>
../spotboard/dist/?r=#1            <— start from #1 submission     
../spotboard/dist/?time=#2         <— start after #2 time(minutes)     
../spotboard/dist/?award=true      <— start Awards Ceremony mode   
../spotboard/dist/?award_rank_begin=#3     <— start Awards Ceremony mode from rank #3, must use with award=true   
../spotboard/dist/?animation=true  <— animation enable   
../spotboard/dist/?q               <- query ??
../spotboard/dist/?t=#4            <— follow team number #4   
</pre>
