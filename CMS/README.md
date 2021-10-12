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
   

#Prerequisites installation terminal command  
<pre>
wget https://raw.githubusercontent.com/melongist/CSL/master/CMS/cms150dev1.sh   
bash cms150dev1.sh
</pre>

#CMS 1.5.0 dev installation terminal command  
<pre>
wget https://raw.githubusercontent.com/melongist/CSL/master/CMS/cms150dev2.sh   
bash cms150dev2.sh
</pre>
   
   
#How to manage contest!   
(It takes about 1 hour ... with full problem data ... )   
   
1. First of all   
  1.1 make admin  
    `cmsAddAdmin -p <password> <username>`   
  1.2 start admin web server  
    `cmsAdminWebServer.`   
  1.3 login admin/pw  
    web page : http://localhost:8889   
    the port number can be configured in cms.conf  
   
2. Make contest    
  2.0 with cmsAdminWebServer page   
  2.1 make a contest    
  2.2 make tasks and settings...  
    2.2.1 tasks ... attachments ... in-out files ...   
    2.2.2 scoring ... etc ....   
  2.3 make users and make paticipation to a contest   
    2.3.1 user account, name ... etc ...   
  2.4 (option) make team and register users to a team   
    ...   
   
3. Run ResourceServices   
  3.1 start resource services ?? run with other terminal ...    
    `cmsResourceService -a`   
   
4. Run cmsRankingWebServer    
  4.1 start cmsRankingWebServer service ?? run with other terminal ...   
    `cmsRankingWebServer`     
   
