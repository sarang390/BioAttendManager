from serial import Serial, time

serialport = Serial(port="COM5", baudrate=9600)
print("port====", serialport)
reading=[]
# serialport.open()

while True:

    serialport.read()

    time.sleep(0.001)
