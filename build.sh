docker build -t jorarmarfin/awstats:0.1 .
docker build -t jorarmarfin/awstats:tmp .

docker run --name srv-awstats -dit -p 9005:80 jorarmarfin/awstats:0.1