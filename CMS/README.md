#2022.05.18   

#With Ubuntu 20.04 LTS Desktop... AWS OK!  + PyPy3 supported!    
#AWS firewall? open TCP 8888, TCP 8889, TCP 8890.   
    
    
    
#2020.12.10   

#IOI style CMS   
#With Ubuntu 20.04 LTS Desktop... at PC   

#I finally got it!!!!!! after hundreds of challenges  


#Official CMS http://cms-dev.github.io/   
#Official CMS GitHub https://github.com/cms-dev/cms   
#Official CMS DOCS https://cms.readthedocs.io/en/latest/index.html   



#I finally got it!!!!!! after hundreds of challenges  

#With great help of one of our great students(https://github.com/junukwon7)   


#2020.11.28 korean translation updated   
   







#for CMS install    
   

#Prerequisites batch installation terminal command  
<pre>
wget https://raw.githubusercontent.com/melongist/CSL/master/CMS/cms15dev01.sh   
bash cms15dev01.sh
</pre>

#CMS 1.5.dev0 batch installation terminal command  
<pre>
wget https://raw.githubusercontent.com/melongist/CSL/master/CMS/cms15dev02.sh   
bash cms15dev02.sh
</pre>
   
    
    
#How to make/manage contest! (last update 2022.05.18)    
(It takes about 1 hour and more ... with full problem data ... )    
   
1. First of all   
  1.1 make admin  
    cms15dev02.sh generate admin automatically    
  1.2 start admin web server    
    run cmsAdminWebServer with terminal   
    PC terminal?  : `cmsAdminWebServer`   
    AWS terminal? : `setsid cmsAdminWebServer &`
  1.3 login admin with PW at web browser    
    default admin page & port : http://localhost:8889    
    port number can be configured at /usr/local/etc/cms.conf    
    how to edit port number(reboot needed) : `sudo nano /usr/local/etc/cms.conf`    
   
2. Make contest    
  2.0 At cmsAdminWebServer page    
  2.1 make a contest    
  2.2 make tasks and settings...    
    2.2.1 upload tasks ... attachments ... in-out files ...    
    2.2.2 select/make scoring method ... etc ....    
  2.3 make users and make paticipation to a contest    
    2.3.1 make user accounts, name ... etc ...    
  2.4 (option) make team and register users to a team    
    ...   
   
3. Run ResourceServices   
  3.1 start resource services ...    
    `cmsResourceService -a`   
  3.2 select contest number ...    
  3.3 user login with PW at web browser ...    
    default admin page & port : http://localhost:8888    
    port number can be configured at /usr/local/etc/cms.conf    
    how to edit port number(reboot needed) : `sudo nano /usr/local/etc/cms.conf`    

4. Run cmsRankingWebServer    
  4.1 start cmsRankingWebServer service ?? run with other terminal ...   
    run cmsRankingWebServer with terminal    
    PC terminal?  : `cmsRankingWebServer`    
    AWS terminal? : `setsid cmsRankingWebServer &`       
    
