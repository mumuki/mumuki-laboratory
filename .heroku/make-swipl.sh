git clone https://github.com/flbulgarelli/swipl
cd swipl
sed 's/flbulgarelli/SWI-Prolog/' .git/config > .git/config.new
mv .git/config.new .git/config
echo y | ./prepare

./build.templ
cd ..
git clone https://github.com/flbulgarelli/mumuki m 
cd m 
git checkout heroku-build
rm -rf .heroku/vendor/*
cp /app/.heroku/vendor/* .heroku/vendor -r

git add -A 
git config user.email mumuki@herokuapp.com
git config user.name mumuki
git commit -m "updating swipl heroku vendor package"
git push origin HEAD 
