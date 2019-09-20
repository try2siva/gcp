#!/bin/bash
#gcloud compute instances list | awk 'FNR == 1 {next} {print $1}' > /tmp/gcp_hosts_list
#for i in `cat /root/gcp_instance`
#for i in `gcloud compute instances list | awk 'FNR == 1 {next} {print $1}'`
#for i in `gcloud compute instances list | grep "RUNNING" | awk '{print $1}'`
hostname=`hostname`
#fqn=`hostname -f`
for i in `gcloud compute instances list | grep -v $hostname | grep "RUNNING" | awk '{print $1}'`
#for i in `gcloud compute instances list | grep "RUNNING" | awk '{print $1}'`
do
gcpinst=$(grep -i "$i" /etc/hosts | awk '{print $1}')
gcpinst_pub=`gcloud compute instances describe $i  --zone=asia-east1-b | grep -i networkIP | awk -F ": " '{print $2}'`
if [ "$gcpinst" != "$gcpinst_pub" ]; then
        echo $(`sed -i s/$gcpinst/$gcpinst_pub/ /etc/hosts` echo "New aws Public IP updated" )
else
        echo "Existing Public GCP instance IP and Current IP matching"
fi
done
