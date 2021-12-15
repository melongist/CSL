#!/bin/bash

#DOMjudge server Korean language patch script
#DOMjudge7.3.4 stable + Ubuntu 20.04 LTS
#Made by 
#2021.09.21 melongist(melongist@gmail.com, what_is_computer@msn.com) for CS teachers


#terminal commands to install Korean patch 
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj734kr.sh
#bash dj734kr.sh


if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj734kr.sh'"
  exit 1
fi

OJNAME="o"
INPUTS="x"
while [ ${OJNAME} != ${INPUTS} ]; do
  echo -n "Enter  DOMjudge NAME : "
  read OJNAME
  echo -n "Repeat DOMjudge NAME : "
  read INPUTS
done

#menu
sudo sed -i "s/DOMjudge/${OJNAME}/" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig
sudo sed -i "s/Scoreboard/점수/" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig
sudo sed -i "s/Problemset/문제/" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig
sudo sed -i "s/Team/팀/" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig
sudo sed -i "s/Jury/대회운영/" /opt/domjudge/domserver/webapp/templates/public/menu.html.twig

#login
sudo sed -i "s/Please sign in/로그인하세요./" /opt/domjudge/domserver/webapp/templates/security/login.html.twig

#login/logout button
sudo sed -i "s/i> Logout/i> 로그아웃/" /opt/domjudge/domserver/webapp/templates/partials/menu_login_logout_button.html.twig
sudo sed -i "s/i> Login/i> 로그인/" /opt/domjudge/domserver/webapp/templates/partials/menu_login_logout_button.html.twig

#change_contest
sudo sed -i "s/Change Contest/대회 변경/" /opt/domjudge/domserver/webapp/templates/partials/menu_change_contest.html.twig
sudo sed -i "s/No contest/대회 없음/" /opt/domjudge/domserver/webapp/templates/partials/menu_change_contest.html.twig

#countdown
sudo sed -i "s/no contest/대회 없음/" /opt/domjudge/domserver/webapp/templates/partials/menu_countdown.html.twig

#problem list
sudo sed -i "s/Contest problems/문제/" /opt/domjudge/domserver/webapp/templates/partials/problem_list.html.twig

#scoreboard
sudo sed -i "s/No active contest/현재 진행중인 대회가 없습니다./" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/preliminary results - not final/확정 전 순위 - 아직 최종 결과가 아닙니다./" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/final standings/최종 순위/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/contest over, waiting for results/대회가 종료되었습니다. 결과를 기다려주세요./" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/starts:/시작시간:/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/- ends:/- 종료시간:/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/The scoreboard was frozen with/공개 스코어보드가 대회 종료/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/minutes remaining - solutions/분전 상태에서 변하지 않는 상태로 고정(frozen)되었습니다. -/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/submitted in the last/이전/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/minutes of the contest/분 동안 제출된 채점들은/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/are still shown as pending/채점을 제출한 것으로만 계속 보여집니다./" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig
sudo sed -i "s/are not shown/보여지지 않습니다./" /opt/domjudge/domserver/webapp/templates/partials/scoreboard.html.twig

#scoreboard summary
sudo sed -i "s/Summary/통계/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/total solved/맞춘 개수/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/number of accepted submissions/맞춘 횟수/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/number of rejected submissions/틀린 횟수/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/number of pending submissions/채점 대기중/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/first solved/처음 맞춘 시간/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig
sudo sed -i "s/min/분/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_summary.html.twig

#scoreboard table
sudo sed -i "s/\"rank\"/\"순위\"/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/>rank/>순위/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/team name/팀 이름/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/>team/>팀 이름/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/solved \/ penalty time/맞춤 \/ 시간 패널티/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/>score/>점수/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Solved first/가장 먼저 맞춤/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/'Solved'/'맞춤'/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Tried, incorrect/틀림/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Tried, pending/채점 대기중/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Untried/미제출/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig
sudo sed -i "s/Cell colours/셀 색상/" /opt/domjudge/domserver/webapp/templates/partials/scoreboard_table.html.twig

#team menu
sudo sed -i "s/DOMjudge/${OJNAME}/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Home/> 첫 페이지/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Problemset/> 문제/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Print/> 인쇄/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Scoreboard/> 순위/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Jury/> 대회운영/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig
sudo sed -i "s/> Submit/> 채점 제출/" /opt/domjudge/domserver/webapp/templates/team/menu.html.twig

#team submit modal
sudo sed -i "s/Submit/채점 제출/" /opt/domjudge/domserver/webapp/templates/team/submit_modal.html.twig
sudo sed -i "s/Contest has not yet started - cannot submit./대회가 아직 시작되지 않았습니다. - 채점을 제출할 수 없습니다./" /opt/domjudge/domserver/webapp/templates/team/submit_modal.html.twig
sudo sed -i "s/>Close/>취소/" /opt/domjudge/domserver/webapp/templates/team/submit_modal.html.twig
sudo sed -i "s/>Cancel/>취소/" /opt/domjudge/domserver/webapp/templates/team/submit_modal.html.twig

#team partials index_content
sudo sed -i "s/Welcome team/환영합니다./" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/There's no active contest for you (yet)./대회가 아직 시작되지 않았습니다./" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/Contest {/대회 {/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/Submissions/채점 제출 기록/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/Clarifications/공지 및 안내/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/No clarifications./공지 또는 안내가 없습니다./" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/Clarification Requests/질문 또는 요청/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/No clarification request./질문 또는 요청이 없습니다./" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig
sudo sed -i "s/request clarification/질문 또는 요청하기/" /opt/domjudge/domserver/webapp/templates/team/partials/index_content.html.twig

#team submission list
sudo sed -i "s/No submissions/채점을 제출한 기록이 없습니다./" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/>time/>제출 시간/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/>problem/>문제/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/>lang/>제출 언어/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig
sudo sed -i "s/>result/>채점 결과/" /opt/domjudge/domserver/webapp/templates/team/partials/submission_list.html.twig

#team clarification list
sudo sed -i "s/>time/>시간/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/>from/>발신/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/>to/>수신/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/>subject/>제목/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig
sudo sed -i "s/>text/>내용/" /opt/domjudge/domserver/webapp/templates/team/partials/clarification_list.html.twig

#team submit scripts
sudo sed -i "s/Main source file:/소스 파일:/" /opt/domjudge/domserver/webapp/templates/team/partials/submit_scripts.html.twig
sudo sed -i "s/Problem:/문제:/" /opt/domjudge/domserver/webapp/templates/team/partials/submit_scripts.html.twig
sudo sed -i "s/Language:/프로그래밍언어:/" /opt/domjudge/domserver/webapp/templates/team/partials/submit_scripts.html.twig
sudo sed -i "s/Make submission?/제출하시겠습니까?/" /opt/domjudge/domserver/webapp/templates/team/partials/submit_scripts.html.twig

#clearing DOMjudge webserver cache
sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*

echo "DOMjudge 7.3.4 stable 21.11.22"
echo "DOMjudge korean patch for beginner installed!(but not for admin)"
echo "Check DOMserver's web interface!"
echo "------"
echo "http://localhost/domjudge/"
