#!/bin/bash -e
RABBIT_PROC=` ps aux | grep "rake bunny_worker" | grep -v grep | awk '{print $2}' `
if [ $? -eq 0 ]
   then 
      echo $(date) " Removing process: " $RABBIT_PROC | tee -a ./log/bunny_worker.stop
      for P in $RABBIT_PROC
       	do kill $RABBIT_PROC
      done
else 
    echo  $(date) " No bunny_worker process. nothing to kill." $RABBIT_PROC " ." | tee -a  ./log/bunny_worker.stop
fi
nohup bundle exec rake bunny_worker > ./log/bunny_worker.log &
echo  $(date) " Done starting up bunny_worker" | tee -a ./log/bunny_worker.start
