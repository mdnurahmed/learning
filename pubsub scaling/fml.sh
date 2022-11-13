#! /bin/bash
for i in {1..200}; do 
  gcloud pubsub topics publish echo --message=”Autoscaling #${i}”
done