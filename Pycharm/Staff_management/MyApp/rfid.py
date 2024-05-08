import serial
from  MyApp.DBConnection import  Db
serialPort = serial.Serial(port="COM7")
import pyttsx3
engine = pyttsx3.init()
serialString = ""                           # Used to hold data coming over UART
mm=""
counter=0
studentlogid=""
while(True):
        serialString = serialPort.read().decode('utf-8')
        mm=mm+serialString
        print(mm)
        if len(mm)==12:
            print(mm)


            db=Db()
            qry="select * from myapp_staff where Post='"+mm+"'"
            print(qry)
            mm = ""
            res=db.selectOne(qry)
            if res is not None:
                print("inside 1")
                engine.say("Hi "+ res['Name'])
                engine.runAndWait()
                counter=counter+1
                studentlogid=res['LOGIN_id']

                db = Db()
                qry = "SELECT * FROM `myapp_attendance` WHERE `STAFF_id`='" + str(res['id']) + "' AND `Date`=CURDATE() AND Attendance='Done'"
                res2 = db.select(qry)
                if len(res2)>0:
                    print("inside 1")
                    engine.say("Please open attendance app and verify using your finger print")
                    engine.runAndWait()
                    qry2 = "INSERT INTO `myapp_attendance` (`Date`,`Attendance`,`STAFF_id`,`Time`) VALUES(CURDATE(),'check in','" + str(
                        res['id']) + "',CURTIME())"
                    res2 = db.insert(qry2)
                    pass
                    # qry1 = "UPDATE `myapp_attendance` SET `Attendance`='check out' WHERE DATE=CURDATE() AND `STAFF_id`='" + str(res['id']) + "'"
                    # db.update(qry1)
                else:

                   pass

            else:
                print("inside 1")
                engine.say("No Records found")
                engine.runAndWait()

        #
        #
        #      # mm=""
        # else:
        #     engine.say("Rfid not recognized. Try again")
        #     engine.runAndWait()