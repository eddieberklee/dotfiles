git add .
read -p "Commit message (optional): " commit_description
git commit -am "automated pushing: $commit_description"
git push origin master
