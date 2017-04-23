#!/usr/bin/python

#Snort rule
#alert tcp any any -> any [443,8443] (msg:"naman-protocol: ssl detected"; flow:to_server,established; ssl_state:server_hello; metadata:service ssl; sid:10000002; rev:001;)

#Sample alert
#04/20-02:22:39.042547  [**] [1:10000002:1] naman-protocol: ssl detected [**] [Priority: 0] {TCP} 192.168.5.135:44566 -> 52.27.17.189:443


import time
import datetime
import sys

def IP2Int(ip):
    o = map(int, ip.split('.'))
    res = (16777216 * o[0]) + (65536 * o[1]) + (256 * o[2]) + o[3]
    return str(res)

sid = "10000002"
file = open("alert","r")
output_file = open("process_file","a")

# Set the time flag as 0 to ensure we don't use old alerts
time_flag = 0
# Save the start time of the program in epoch
start_time = time.time()

while 1:
    where = file.tell()
    line = file.readline()
    if not line:
        time.sleep(1)
        file.seek(where)
    else:
        if sid in line:
            if time_flag == 0: #
                #pick up datetime from the alert
                split1 = line.split(" ")
                alert_time = "2017/" + split1[0]
                #convert datetime to epoch
                alert_epoch = time.mktime(datetime.datetime.strptime(alert_time, "%Y/%m/%d-%H:%M:%S.%f").timetuple())
                #if the alert has been generated after the start time, set the time flag as 1 
                if start_time <= alert_epoch:
                    time_flag = 1

            if time_flag == 1: 
                tuple = ["ssl-bypass"]
                temp1 = line.split("} ")
                #temp1[1] will have 192.168.5.135:44566 -> 52.27.17.189:443
                #Now, Split up src and dst sockets
                temp2 = temp1[1].split(" -> ")
                #temp2 will have ['192.168.5.135:44566', '52.27.17.189:443']
                for entry in temp2:
                    temp3 = entry.split(":")
                    tuple.append(IP2Int(temp3[0]))
                    temp3[1] = temp3[1].replace("\n","")
                    tuple.append(temp3[1])
                print tuple
                #output_file.write(",".join(tuple) + "\n")
file.close()
output_file.close()

