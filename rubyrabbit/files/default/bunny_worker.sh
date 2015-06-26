#!/bin/bash -e
RABBIT_PROC=` ps aux | grep bunny_worker | awk '{print $2}' `
if [ $? -eq 0 ]
   then 
      echo " Removing process: " $RABBIT_PROC >> ./log/bunny_worker.stop
      kill $RABBIT_PROC
else 
    echo  " No bunny_worker process. nothing to kill." $RABBIT_PROC " ." >>  ./log/bunny_worker.stop
fi
nohup bundle exec rake bunny_worker > ./log/bunny_worker.log &
echo  " Done starting up bunny_worker" >> ./log/bunny_worker.start
