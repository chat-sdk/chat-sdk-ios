# git tag -d 5.0.5
# git push origin :5.0.5
git add --all
git commit -m "Update podspec"
git push origin master
git tag 5.0.5
git push --tags
pod trunk push --allow-warnings ChatK\!t.podspec