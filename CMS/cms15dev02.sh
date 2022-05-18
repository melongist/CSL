#!/bin/bash

#http://cms-dev.github.io/
#https://github.com/cms-dev/cms

#CMS1.5.dev0 + Ubuntu 20.04 LTS Server
#Installation

#------

cd

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash cms15dev02.sh'"
  exit 1
fi

cd cms

sudo pip3 install -r requirements.txt

wget https://raw.githubusercontent.com/melongist/CSL/master/CMS/db.txt

USERPW="o"
INPUTS="x"
while [ ${USERPW} != ${INPUTS} ]; do
  echo -n "Enter  postgresql cmsuser password : "
  read USERPW
  echo -n "Repeat postgresql cmsuser password : "
  read INPUTS
done

sudo sed -i "s#login password 'enternewpassword'#login password '$USERPW'#" ./db.txt
sudo su - postgres < db.txt
cd

sudo sed -i "s#your_password_here#$USERPW#" /usr/local/etc/cms.conf
sudo chown cmsuser:cmsuser /usr/local/etc/cms.conf


#for PyPy3
sudo sed -i "s#Python3CPython\",#Python3CPython\",\n            \"Python 3 / PyPy3=cms.grading.languages.python3_pypy3:Python3PyPy3\",#g" ~/cms/setup.py
sudo cp -f ~/cms/cms/grading/languages/python3_cpython.py ~/cms/cms/grading/languages/python3_pypy3.py
sudo sed -i "s#__all__ = \[\"Python3CPython\"\]#__all__ = \[\"Python3PyPy3\"\]#g" ~/cms/cms/grading/languages/python3_pypy3.py
sudo sed -i "s#class Python3CPython(CompiledLanguage):#class Python3PyPy3(CompiledLanguage):#g" ~/cms/cms/grading/languages/python3_pypy3.py
sudo sed -i "s#return \"Python 3 \/ CPython\"#return \"Python 3 \/ PyPy3\"#g" ~/cms/cms/grading/languages/python3_pypy3.py
sudo sed -i "s#commands.append(\[\"\/usr\/bin\/python3\"#commands.append(\[\"\/usr\/bin\/pypy3\"#g" ~/cms/cms/grading/languages/python3_pypy3.py
sudo sed -i "s#return \[\[\"\/usr\/bin\/python3\"#return \[\[\"\/usr\/bin\/pypy3\"#g" ~/cms/cms/grading/languages/python3_pypy3.py


cd
cd cms
sudo python3 setup.py install
cd

cmsInitDB

cmsAddAdmin admin -p $USERPW

echo "cms1.5.dev0 installation completed!!" | tee -a cms.txt
echo "Last update : 2022.05.18" | tee -a cms.txt
echo "" | tee -a cms.txt
echo "------ CMS admin server ------" | tee -a cms.txt
echo "Start CMS admin server" | tee -a cms.txt
echo "  PC terminal?  : cmsAdminWebServer" | tee -a cms.txt
echo "  AWS terminal? : setsid cmsAdminWebServer &" | tee -a cms.txt
echo "" | tee -a cms.txt
echo "      id : admin" | tee -a cms.txt
echo "      pw : $USERPW" | tee -a cms.txt
echo "" | tee -a cms.txt
echo "" | tee -a cms.txt
echo "------ Making contest ------" | tee -a cms.txt
echo "At admin page" | tee -a cms.txt
echo "http://localhost:8889" | tee -a cms.txt
echo "  upload tasks ... attachments ... in/out files ..." | tee -a cms.txt
echo "  select/make scoring method ... etc" | tee -a cms.txt
echo "  make user accounts ... etc ..." | tee -a cms.txt
echo "" | tee -a cms.txt
echo "" | tee -a cms.txt
echo "------ Run contest ------" | tee -a cms.txt
echo "  PC terminal?  : cmsResourceService -a" | tee -a cms.txt
echo "  AWS terminal? : cmsResourceService -a" | tee -a cms.txt
echo "  and   select # to start contest!" | tee -a cms.txt
echo "" | tee -a cms.txt
echo "check : contest, user ... with user menu" | tee -a cms.txt
echo "      http://localhost:8888" | tee -a cms.txt
echo "  how to change port number : sudo nano /usr/local/etc/cms.conf" | tee -a cms.txt
echo "" | tee -a cms.txt
echo "------ CMS Ranking Web Server ------" | tee -a cms.txt
echo "Start CMS Ranking Web Server" | tee -a cms.txt
echo "  PC terminal?  : cmsRankingWebServer" | tee -a cms.txt
echo "  AWS terminal? : setsid cmsRankingWebServer &" | tee -a cms.txt
echo "" | tee -a cms.txt
echo "" | tee -a cms.txt


clear
echo "------ CMS 1.5.dev0 ready!! ------"
echo ""
cat cms.txt
