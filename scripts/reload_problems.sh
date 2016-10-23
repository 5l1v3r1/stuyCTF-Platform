# Makes sure that we are in the correct directory to work in
cd ${VAGRANT_PATH}/api

echo "Clearing database of problems"
python3 api_manager.py database clear problems

echo "Reloading problems"
python3 api_manager.py -v problems load ${VAGRANT_PATH}/problems/ graders/ ../problem_static/

devploy
