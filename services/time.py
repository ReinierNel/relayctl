from datetime import datetime
from time import sleep

start = "17:15"
end = "17:16"



start_time = int(start.split(":")[0])*60 + int(start.split(":")[1])
end_time = int(end.split(":")[0])*60 + int(end.split(":")[1])

while True:
    current_time =  datetime.now().hour*60 + datetime.now().minute
    print(f'{start_time} {current_time} {end_time}')
    if start_time <= current_time and end_time >= current_time:
        print("relay must be on now")
    else:
        print("relay must be off now")

    sleep(1)