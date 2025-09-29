#!/bin/bash

#DOMjudge server Korean language patch script
#2025.09 Made by melongist(melongist@gmail.com) for CS teachers
#DOMjudge8.3.2 stable + Ubuntu 24.04.3 LTS + apache2/nginx




#DOMjudge korean interface installation script for middle/high school student.




#terminal commands to install Korean patch 
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj832kr.sh
#bash dj832kr.sh


#------

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj832kr.sh'"
  exit 1
fi


if [ ! -d /opt/domjudge/domserver ] ; then
  echo ""
  echo "DOMjudge server is not installed at this computer!!"
  echo ""
  exit 1
fi


clear

INPUTS="x"

while [ ${INPUTS} != "y" ] && [ ${INPUTS} != "n" ]; do
  echo -n "Rename DOMjudge logo name? [y/n]: "
  read INPUTS
done

echo ""
if [ ${INPUTS} == "y" ] ; then
  OJNAME="o"
  INPUTS="x"
  while [ ${OJNAME} != ${INPUTS} ]; do
    echo -n "Enter  logo NAME : "
    read OJNAME
    echo -n "Repeat logo NAME : "
    read INPUTS
  done
else
  OJNAME="DOMjudge"
fi

echo ""


#webapp/public/js/domjudge.js
sudo sed -i "s/start delayed/시작 지연됨/" /opt/domjudge/domserver/webapp/public/js/domjudge.js
sudo sed -i "s/no contest/대회 없음/" /opt/domjudge/domserver/webapp/public/js/domjudge.js
sudo sed -i "s/time to start/시작 시간/" /opt/domjudge/domserver/webapp/public/js/domjudge.js
sudo sed -i "s/contest over/대회 종료/" /opt/domjudge/domserver/webapp/public/js/domjudge.js
sudo sed -i "s/Your browser does not support desktop notifications./웹브라우저가 알림 기능을 지원하지 않습니다./" /opt/domjudge/domserver/webapp/public/js/domjudge.js
sudo sed -i "s/Your browser does not support local storage;/웹브라우저가 저장 장치를 사용할 수 없습니다.;/" /opt/domjudge/domserver/webapp/public/js/domjudge.js
sudo sed -i "s/this is required to keep track of sent notifications./전송된 알림을 기록하는데 필요합니다./" /opt/domjudge/domserver/webapp/public/js/domjudge.js
sudo sed -i "s/Browser denied permission to send desktop notifications./웹브라우저에 알림 전송 권한이 없습니다./" /opt/domjudge/domserver/webapp/public/js/domjudge.js
sudo sed -i "s/Re-enable notification permission in the browser and retry./웹브라우저의 알림 전송 권한을 허용한 후 시도해보세요./" /opt/domjudge/domserver/webapp/public/js/domjudge.js
sudo sed -i "s/Really log out?/로그아웃 하시겠습니까?/" /opt/domjudge/domserver/webapp/public/js/domjudge.js

#webapp/src/Controller/SecurityController.php
sudo sed -i "s/'Account registered successfully. Please log in.'/'팀별ID가 등록되었습니다. 로그인하세요.'/" /opt/domjudge/domserver/webapp/src/Controller/SecurityController.php

#webapp/src/Controller/Team/SubmissionController.php
sudo sed -i "s/Submission done\! Watch for the verdict in the list below./채점이 제출되었습니다\! 페이지 새로고침을 눌러 채점 결과를 확인해주세요./" /opt/domjudge/domserver/webapp/src/Controller/Team/SubmissionController.php

#webapp/src/Controller/Team/ClarificationController.php
sudo sed -i "s/Clarification sent to the jury/해당 요청이 심사위원단에게 전송되었습니다./" /opt/domjudge/domserver/webapp/src/Controller/Team/ClarificationController.php

#webapp/src/Form/Type/SubmitProblemType.php
sudo sed -i "s/Select a problem/문제 선택/" /opt/domjudge/domserver/webapp/src/Form/Type/SubmitProblemType.php
sudo sed -i "s/Select a language/프로그래밍 언어 선택/" /opt/domjudge/domserver/webapp/src/Form/Type/SubmitProblemType.php
sudo sed -i "s/=> 'Source file' . (\$allowMultipleFiles ? 's' : ''),/=> '소스 파일',/" /opt/domjudge/domserver/webapp/src/Form/Type/SubmitProblemType.php
sudo sed -i "s/'class' => Problem::class,/'class' => Problem::class,'label' => '문제',/" /opt/domjudge/domserver/webapp/src/Form/Type/SubmitProblemType.php
sudo sed -i "s/'class' => Language::class,/'class' => Language::class,'label' => '프로그래밍 언어',/" /opt/domjudge/domserver/webapp/src/Form/Type/SubmitProblemType.php

#webapp/src/Form/Type/TeamClarificationType.php
sudo sed -i "s/'data' => 'Jury',/'data' => '심사위원단', 'label' => '수신',/" /opt/domjudge/domserver/webapp/src/Form/Type/TeamClarificationType.php
sudo sed -i "s/'choices' => \$subjects,/'choices' => \$subjects, 'label' => '제목',/" /opt/domjudge/domserver/webapp/src/Form/Type/TeamClarificationType.php
sudo sed -i "s/'attr' =>/'label' => '내용', 'attr' =>/" /opt/domjudge/domserver/webapp/src/Form/Type/TeamClarificationType.php

#webapp/src/Twig/TwigExtension.php
sudo sed -i "s/scheduled to start /시작 예정 /" /opt/domjudge/domserver/webapp/src/Twig/TwigExtension.php
sudo sed -i "s/start delayed, was scheduled /시작 지연됨 /" /opt/domjudge/domserver/webapp/src/Twig/TwigExtension.php
sudo sed -i "s/\"at \"/\"시간 \"/" /opt/domjudge/domserver/webapp/src/Twig/TwigExtension.php
sudo sed -i "s/\"on \"/\"날짜 및 시간 \"/" /opt/domjudge/domserver/webapp/src/Twig/TwigExtension.php

#webapp/templates/partials/menu_change_contest.html
sudo sed -i "s/>Change Contest/>대회 변경/" /opt/domjudge/domserver/webapp/templates/partials/menu_change_contest.html.twig
sudo sed -i "s/>no contest/>대회 없음/" /opt/domjudge/domserver/webapp/templates/partials/menu_change_contest.html.twig

#webapp/templates/partials/menu_countdown.html.twig
sudo sed -i "s/no contest/대회 없음/" /opt/domjudge/domserver/webapp/templates/partials/menu_countdown.html.twig

#webapp/templates/partials/menu_login_logout_button.html.twig
sudo sed -i "s/i> Logout/i> 로그아웃/" /opt/domjudge/domserver/webapp/templates/partials/menu_login_logout_button.html.twig
sudo sed -i "s/i> Login/i> 로그인/" /opt/domjudge/domserver/webapp/templates/partials/menu_login_logout_button.html.twig
sudo sed -i "s/i> Register/i> 참가등록/" /opt/domjudge/domserver/webapp/templates/partials/menu_login_logout_button.html.twig

#webapp/templates/partials/modal.html.twig
sudo sed -i "s/}Close/}닫기/" /opt/domjudge/domserver/webapp/templates/partials/modal.html.twig

#webapp/templates/partials/problem_list.html.twig
sudo sed -i "s/}} problems/}} 문제/" /opt/domjudge/domserver/webapp/templates/partials/problem_list.html.twig
sudo sed -i "s/Limits:/실행 제한:/" /opt/domjudge/domserver/webapp/templates/partials/problem_list.html.twig
sudo sed -i "s/\<second\>/초/" /opt/domjudge/domserver/webapp/templates/partials/problem_list.html.twig
sudo sed -i "s/1 %}s{% endif/1 %}{% endif/" /opt/domjudge/domserver/webapp/templates/partials/problem_list.html.twig
sudo sed -i "s/\<statement\>/문제/" /opt/domjudge/domserver/webapp/templates/partials/problem_list.html.twig
sudo sed -i "s/> samples/> 예시 데이터/" /opt/domjudge/domserver/webapp/templates/partials/problem_list.html.twig
sudo sed -i "s/> Submit/> 채점 제출/" /opt/domjudge/domserver/webapp/templates/partials/problem_list.html.twig

#webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/No active contest/진행중인 대회 없음/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/preliminary results - not final/채점 결과 - 결과 검증전/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/final standings/최종 순위/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/contest over, waiting for results/대회 종료, 결과 검증중/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/starts:/시작시간:/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/started:/시작시간:/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/- ends:/- 종료시간:/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/The scoreboard was frozen with/대회 종료/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/minutes remaining - solutions/분전에 점수가 변하지 않게 고정(frozen)되었습니다. -/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/submitted in the last/대회 종료/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/minutes of the contest/분전 점수 고정 이후에 제출된 채점들은/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/are still shown as pending/제출된 것으로만 나타납니다./" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/are not shown/보이지 않습니다./" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig

#webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/>Summary/>통계/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/total solved/맞춘 개수/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/number of accepted submissions/맞춤/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/number of rejected submissions/틀림/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/number of pending submissions/제출함/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/first solved/처음 맞춘 시간/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/min/분/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig

#webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/\"rank/\"순위/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/>rank/>순위/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/\"team name/\"팀 이름/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/>team/>팀 이름/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/solved \/ penalty time/맞춤 \/ 패널티 시간/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/>score/>점수/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/1 try/1번 시도/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/ tries/번 시도/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Solved, fastest/가장 빨리 맞춤/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Solved first/가장 먼저 맞춤/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Solved/맞춤/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Tried, incorrect/틀림/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Tried, pending/채점 제출함/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Untried/미제출/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Cell colours/색상별 의미/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/>Categories/>구분/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/>Medals/>메달/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/(tentative)/(결과 검증전)/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
#sudo sed -i "s/Gold/금/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
#sudo sed -i "s/Silver/은/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
#sudo sed -i "s/Bronze/동/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/ Medal</ 메달</" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig

#webapp/templates/public/menu.html.twig
sudo sed -i "s/DOMjudge/${OJNAME}/" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig
sudo sed -i "s/Scoreboard/점수/" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig
sudo sed -i "s/Problemset/문제/g" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig
sudo sed -i "s/Team/팀/" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig
sudo sed -i "s/Jury/대회운영/" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig

#webapp/templates/security/login.html.twig
sudo sed -i "s/Don't have an account?/팀별ID가 없나요?/" /opt/domjudge/domserver/webapp/templates/security/login.html.twig
sudo sed -i "s/>Register now/>팀별ID 만들기/" /opt/domjudge/domserver/webapp/templates/security/login.html.twig

#webapp/templates/security/register.html.twig
sudo sed -i "s/>Register Account/>팀별ID 등록/" /opt/domjudge/domserver/webapp/templates/security/register.html.twig
sudo sed -i "s/Enter the following information to register your account with DOMjudge./>팀별ID 등록을 위해 아래 정보를 작성해주세요./" /opt/domjudge/domserver/webapp/templates/security/register.html.twig
sudo sed -i "s/Already have an account?/이미 팀별ID가 있나요?/" /opt/domjudge/domserver/webapp/templates/security/register.html.twig
sudo sed -i "s/>Login/>로그인하기/" /opt/domjudge/domserver/webapp/templates/security/register.html.twig

#webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'Username'/'팀별ID'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'Full name (optional)'/'등록자 이름 (선택)'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'Email address (optional)'/'등록자 이메일 주소 (선택)'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'Team name'/'팀 이름'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'This team name is already in use.'/'팀 이름을 이미 사용중입니다.'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'Use existing affiliation'/'등록된 조직에서 선택'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'Add new affiliation'/'새 조직 추가'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'No affiliation'/'조직 없음'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'Affiliation name'/'조직 이름'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'Affiliation shortname'/'조직 이름 약자'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'No country'/'국가 선택 (선택)'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'-- Select category --'/'-- 종류 선택 --'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'Category'/'종류'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'-- Select affiliation --'/'-- 조직 선택 --'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'Affiliation'/'조직'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'The password fields must match.'/'비밀번호가 일치하지 않습니다.'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'Password'/'비밀번호'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'Repeat Password'/'비밀번호 재입력'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'Register'/'등록'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'This value should not be blank.'/'입력하세요.'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'This affiliation '/'이 '/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/' is already in use.'/' 이름은 이미 사용중입니다.'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php
sudo sed -i "s/'This value should not be blank.'/'입력하세요.'/" /opt/domjudge/domserver/webapp/src/Form/Type/UserRegistrationType.php

#webapp/templates/security/login.html.twig
sudo sed -i "s/Please sign in/로그인하세요/" /opt/domjudge/domserver/webapp/templates/security/login.html.twig
sudo sed -i "s/\"submit\">Sign in/\"submit\">로그인/" /opt/domjudge/domserver/webapp/templates/security/login.html.twig
sudo sed -i "s/\<Username\>/팀별ID/g" /opt/domjudge/domserver/webapp/templates/security/login.html.twig
sudo sed -i "s/\<Password\>/비밀번호/g" /opt/domjudge/domserver/webapp/templates/security/login.html.twig

#webapp/templates/team/base.html.twig
sudo sed -i "s/> Send/> 보내기/" /opt/domjudge/domserver/webapp/templates/team/base.html.twig
sudo sed -i "s/Send clarification request to Jury?/설명을 요청하시겠습니까?/" /opt/domjudge/domserver/webapp/templates/team/base.html.twig

#webapp/templates/team/clarification_add_modal.html.twig
sudo sed -i "s/Send clarification request/명확한 설명 요청하기/" /opt/domjudge/domserver/webapp/templates/team/clarification_add_modal.html.twig
sudo sed -i "s/>Cancel/>취소/" /opt/domjudge/domserver/webapp/templates/team/clarification_add_modal.html.twig
sudo sed -i "s/> Send/> 보내기/" /opt/domjudge/domserver/webapp/templates/team/clarification_add_modal.html.twig
sudo sed -i "s/rendered preview/요청 내용 미리보기/" /opt/domjudge/domserver/webapp/templates/team/clarification_add_modal.html.twig
sudo sed -i "s/Start typing to see a preview of your message/요청 내용을 입력하세요./" /opt/domjudge/domserver/webapp/templates/team/clarification_add_modal.html.twig

#webapp/templates/team/clarification_modal.html.twig
sudo sed -i "s/Clarification Request/설명 요청 내용/" /opt/domjudge/domserver/webapp/templates/team/clarification_modal.html.twig
sudo sed -i "s/View clarification/공지사항/" /opt/domjudge/domserver/webapp/templates/team/clarification_modal.html.twig
sudo sed -i "s/reply to this clarification/회신하기/" /opt/domjudge/domserver/webapp/templates/team/clarification_modal.html.twig

#webapp/templates/team/menu.html.twig
sudo sed -i "s/DOMjudge/${OJNAME}/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Home/> 처음화면/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Problemset/> 문제/g" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Print/> 인쇄/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Scoreboard/> 순위/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Jury/> 대회운영/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Submit/> 채점 제출/g" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/Enable Notifications/알림 활성화/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/Disable Notifications/알림 비활성화/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig

#webapp/templates/team/partials/clarification.html.twig
sudo sed -i "s/Subject:/제목:/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification.html.twig
sudo sed -i "s/Problem {/문제 {/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification.html.twig
sudo sed -i "s/From:/발신:/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification.html.twig
sudo sed -i "s/To:/수신:/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification.html.twig
sudo sed -i "s/Jury/심사위원단/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification.html.twig
sudo sed -i "s/All/전체참가자/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification.html.twig

#webapp/templates/team/partials/clarification_content.html.twig
sudo sed -i "s/rendered preview/요청 내용 미리보기/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_content.html.twig

#webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/>time/>시간/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/>from/>발신/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/>to/>수신/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/>subject/>제목/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/>text/>내용/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/Jury/심사위원단/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/All/전체참가자/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/problem {/문제 {/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig

#webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/Welcome team/환영합니다\!/g" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/There's no active contest for you (yet)./현재 진행중인 대회가 없습니다./" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/Contest {/대회 {/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/>Submissions/>채점 제출 기록/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/>Clarifications/>공지사항 및 답변/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/>No clarifications./>없음/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/>Clarification Requests/>명확한 설명 요청하기/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/>No clarification request./>없음/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/request clarification/요청하기/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig

#webapp/templates/team/partials/submission.html.twig
sudo sed -i "s/Problem:/문제:/" /opt/domjudge/domserver/webapp/templates/team/partials/submission.html.twig
sudo sed -i "s/Submitted:/제출 시간:/" /opt/domjudge/domserver/webapp/templates/team/partials/submission.html.twig
sudo sed -i "s/Language:/프로그래밍 언어:/" /opt/domjudge/domserver/webapp/templates/team/partials/submission.html.twig
sudo sed -i "s/Result:/채점 결과:/" /opt/domjudge/domserver/webapp/templates/team/partials/submission.html.twig
sudo sed -i "s/Download submission ZIP/제출 파일 다운로드/" /opt/domjudge/domserver/webapp/templates/team/partials/submission.html.twig

#webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/>No submissions/>없음/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/>time/>제출 시간/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/>problem/>문제/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/>lang/>제출 언어/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/>result/>채점 결과/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/>runtime/>실행 시간/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/Download submission ZIP/제출 파일 다운로드/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig

#webapp/templates/team/partials/submit_scripts.html.twig
sudo sed -i "s/Main source file:/소스 파일:/" /opt/domjudge/domserver/webapp/templates/team/partials/submit_scripts.html.twig
sudo sed -i "s/Problem:/문제:/" /opt/domjudge/domserver/webapp/templates/team/partials/submit_scripts.html.twig
sudo sed -i "s/Language:/제출 언어:/" /opt/domjudge/domserver/webapp/templates/team/partials/submit_scripts.html.twig
sudo sed -i "s/Make submission\?/제출하시겠습니까\?/" /opt/domjudge/domserver/webapp/templates/team/partials/submit_scripts.html.twig

#webapp/templates/team/submission_modal.html.twig
sudo sed -i "s/Submission details/채점 상세 정보/" /opt/domjudge/domserver/webapp/templates/team/submission_modal.html.twig

#webapp/templates/team/submit_modal.html.twig
sudo sed -i "s/Submit {% if problem is not null %}problem/채점 제출 {% if problem is not null %}- 문제:/" /opt/domjudge/domserver/webapp/templates/team/submit_modal.html.twig
sudo sed -i "s/> Submit/> 채점 제출/" /opt/domjudge/domserver/webapp/templates/team/submit_modal.html.twig
sudo sed -i "s/Contest has not yet started - cannot submit./대회가 아직 시작되지 않았습니다. - 제출할 수 없습니다./" /opt/domjudge/domserver/webapp/templates/team/submit_modal.html.twig
sudo sed -i "s/>Close/>닫기/" /opt/domjudge/domserver/webapp/templates/team/submit_modal.html.twig
sudo sed -i "s/>Cancel/>취소/" /opt/domjudge/domserver/webapp/templates/team/submit_modal.html.twig




#DOMjudge cache clear
/opt/domjudge/domserver/webapp/bin/console cache:clear

#clearing DOMjudge webserver cache
sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*

echo "" | tee -a ~/readme.txt
echo "DOMjudge 8.3.2 stable" | tee -a ~/readme.txt
echo "DOMjudge participants' korean interface installed!" | tee -a ~/readme.txt
echo "For korean middle & high school students." | tee -a ~/readme.txt
echo "" | tee -a ~/readme.txt
echo "Check DOMserver's web interface!" | tee -a ~/readme.txt
echo "------" | tee -a ~/readme.txt
echo "http://localhost/domjudge/" | tee -a ~/readme.txt
