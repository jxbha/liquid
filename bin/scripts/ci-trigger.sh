echo $(date) >> ./app/mana/.build-trigger
git add ./app/mana/.build-trigger
git commit -m "build-trigger $(date)"
git push local dev
