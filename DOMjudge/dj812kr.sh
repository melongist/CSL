#!/bin/bash

#DOMjudge server Korean language patch script
#DOMjudge8.1.2 stable + Ubuntu 22.04 LTS
#Made by 
#2022.08.04 melongist(melongist@gmail.com, what_is_computer@msn.com) for CS teachers


#terminal commands to install Korean patch 
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj812kr.sh
#bash dj812kr.sh


if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj812kr.sh'"
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
    echo -n "Enter  DOMjudge NAME : "
    read OJNAME
    echo -n "Repeat DOMjudge NAME : "
    read INPUTS
  done
else
  OJNAME="DOMjudge"
fi

echo ""

#menu
sudo sed -i "s/DOMjudge/${OJNAME}/" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig
sudo sed -i "s/Scoreboard/점수/" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig
sudo sed -i "s/Problemset/문제/" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig
sudo sed -i "s/Team/팀/" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig
sudo sed -i "s/Jury/대회운영/" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig

#login
sudo sed -i "s/Please sign in/로그인하세요./" /opt/domjudge/domserver/webapp/templates/security/login.html.twig
sudo sed -i "s/\"submit\">Sign in/\"submit\">로그인/" /opt/domjudge/domserver/webapp/templates/security/login.html.twig

#login/logout button
sudo sed -i "s/i> Logout/i> 로그아웃/" /opt/domjudge/domserver/webapp/templates/partials/menu_login_logout_button.html.twig
sudo sed -i "s/i> Login/i> 로그인/" /opt/domjudge/domserver/webapp/templates/partials/menu_login_logout_button.html.twig

#change_contest
sudo sed -i "s/>Change Contest/>대회 변경/" /opt/domjudge/domserver/webapp/templates/partials/menu_change_contest.html.twig
sudo sed -i "s/>no contest/>대회 없음/" /opt/domjudge/domserver/webapp/templates/partials/menu_change_contest.html.twig

#countdown
sudo sed -i "s/no contest/대회 없음/" /opt/domjudge/domserver/webapp/templates/partials/menu_countdown.html.twig

#problem list
sudo sed -i "s/problems</문제</" /opt/domjudge/domserver/webapp/templates/partials/problem_list.html.twig

#scoreboard
sudo sed -i "s/No active contest/진행중 대회 없음/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/preliminary results - not final/가채점 순위 - 최종 순위 아님/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/final standings/최종 순위/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/contest over, waiting for results/대회 종료 및 최종 순위 확인중/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/starts:/시작시간:/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/- ends:/- 종료시간:/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/The scoreboard was frozen with/공개 스코어보드가 대회 종료/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/minutes remaining - solutions/분전 상태에서 변하지 않는 상태로 고정(frozen)되었습니다. -/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/submitted in the last/이전/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/minutes of the contest/분 동안 제출된 것들은/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/are still shown as pending/아직 채점되지 않은 것으로 보여집니다./" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/are not shown/보여지지 않습니다./" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig

#scoreboard summary
sudo sed -i "s/>Summary/>통계/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/total solved/맞춘 개수/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/number of accepted submissions/맞춘 횟수/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/number of rejected submissions/틀린 횟수/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/number of pending submissions/채점 대기중/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/first solved/처음 맞춘 시간/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/min/분/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig

#scoreboard table
sudo sed -i "s/>rank/>순위/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/team name/팀 이름/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/>team/>팀 이름/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/solved \/ penalty time/맞춤 \/ 시간 패널티/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/>score/>점수/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Solved first/가장 먼저 맞춤/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Solved/맞춤/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Tried, incorrect/틀림/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Tried, pending/채점 대기중/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Untried/미제출/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Cell colours/색상별 의미/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/>Categories/>구분/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig

#team menu
sudo sed -i "s/DOMjudge/${OJNAME}/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Home/> 처음화면/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Problemset/> 문제/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Print/> 인쇄/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Scoreboard/> 순위/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Jury/> 대회운영/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Submit/> 채점 제출/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig

#team submit modal
sudo sed -i "s/> Submit/> 채점 제출/" /opt/domjudge/domserver/webapp/templates/team/submit_modal.html.twig
sudo sed -i "s/Contest has not yet started - cannot submit./대회가 아직 시작되지 않았습니다. - 제출할 수 없습니다./" /opt/domjudge/domserver/webapp/templates/team/submit_modal.html.twig
sudo sed -i "s/>Close/>취소/" /opt/domjudge/domserver/webapp/templates/team/submit_modal.html.twig
sudo sed -i "s/>Cancel/>취소/" /opt/domjudge/domserver/webapp/templates/team/submit_modal.html.twig

#team clarification add modal
sudo sed -i "s/Send clarification request/정확한 설명 요청/" /opt/domjudge/domserver/webapp/templates/team/clarification_add_modal.html.twig
sudo sed -i "s/>Cancel/>취소/" /opt/domjudge/domserver/webapp/templates/team/clarification_add_modal.html.twig
sudo sed -i "s/> Send/> 보내기/" /opt/domjudge/domserver/webapp/templates/team/clarification_add_modal.html.twig

#team partials index_content
sudo sed -i "s/Welcome team/환영합니다\!/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/There's no active contest for you (yet)./대회가 아직 시작되지 않았습니다./" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/Contest {/대회 {/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/>Submissions/>채점 제출 기록/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/>Clarifications/>공지 및 안내/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/>No clarifications./>없음/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/>Clarification Requests/>정확한 설명 요청하기/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/>No clarification request./>없음/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/request clarification/요청하기/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig

#team submission list
sudo sed -i "s/>No submissions/>제출 기록 없음/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/>time/>제출 시간/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/>problem/>문제/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/>lang/>제출 언어/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/>result/>채점 결과/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig

#team clarification list
sudo sed -i "s/>time/>시간/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/>from/>보낸 사람/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/>to/>받는 사람/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/>subject/>제목/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/>text/>내용/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig

#team submit scripts
sudo sed -i "s/Main source file:/소스 파일:/" /opt/domjudge/domserver/webapp/templates/team/partials/submit_scripts.html.twig
sudo sed -i "s/Problem:/문제:/" /opt/domjudge/domserver/webapp/templates/team/partials/submit_scripts.html.twig
sudo sed -i "s/Language:/프로그래밍언어:/" /opt/domjudge/domserver/webapp/templates/team/partials/submit_scripts.html.twig
sudo sed -i "s/Make submission?/제출하시겠습니까?/" /opt/domjudge/domserver/webapp/templates/team/partials/submit_scripts.html.twig

#etc scripts
sudo sed -i "s/Submission done\! Watch for the verdict in the list below./채점이 제출되었습니다\! 화면 새로 고침 후, 결과를 확인해주세요./" /opt/domjudge/domserver/webapp/src/Controller/Team/SubmissionController.php
sudo sed -i "s/No file selected/파일 선택/" /opt/domjudge/domserver/webapp/templates/form_theme.html.twig
sudo sed -i "s/Select a problem/문제 선택/" /opt/domjudge/domserver/webapp/src/Form/Type/SubmitProblemType.php
sudo sed -i "s/Select a language/프로그래밍언어 선택/" /opt/domjudge/domserver/webapp/src/Form/Type/SubmitProblemType.php



#clearing DOMjudge webserver cache
sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*

echo "" | tee -a ~/domjudge.txt
echo "DOMjudge 8.1.2 stable 22.08.04" | tee -a ~/domjudge.txt
echo "DOMjudge participants' korean interface installed!" | tee -a ~/domjudge.txt
echo "For korean middle & high school students." | tee -a ~/domjudge.txt
echo "" | tee -a ~/domjudge.txt
echo "Check DOMserver's web interface!" | tee -a ~/domjudge.txt
echo "------" | tee -a ~/domjudge.txt
echo "http://localhost/domjudge/" | tee -a ~/domjudge.txt
