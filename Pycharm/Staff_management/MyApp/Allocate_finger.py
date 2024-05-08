import datetime
import smtplib
import time
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from pyfingerprint.pyfingerprint import PyFingerprint
import tkinter as tk
import tkinter.font as tkFont
from tkinter import *
from tkinter import messagebox
from tkinter import simpledialog
from tkinter import  ttk
# from DBConnection import Db
from MyApp.DBConnection import Db


class abc:
    def __init__(self, sid):
        self.sid=sid
        try:
            self.f = PyFingerprint('COM12',9600,0xFFFFFFFF, 0x00000000)
            print("connected")
            # print(self.f.verifyPassword())
            if (self.f.verifyPassword() == False):
                raise ValueError('The given fingerprint sensor password is wrong!')

        except Exception as e:
            print('Exception message: ' + str(e))

        root = tk.Tk()

        # setting title
        root.title("ATTENDANCE")
        # setting window size
        width = 255
        height = 229
        screenwidth = root.winfo_screenwidth()
        screenheight = root.winfo_screenheight()
        alignstr = '%dx%d+%d+%d' % (width, height, (screenwidth - width) / 2, (screenheight - height) / 2)
        root.geometry(alignstr)
        root.resizable(width=False, height=False)


        db=Db()
        qry="SELECT `id`,`Name` FROM `myapp_staff`"
        res=db.select(qry)

        # Example items for the dropdown
        self.items = []
        self.ids=[]
        for i in res:
            self.items.append(i['Name'])
            self.ids.append(str(i['id']))

        self.selected_item = tk.StringVar(root)

        self.dropdown = ttk.Combobox(root, textvariable=self.selected_item, values=self.items, state='readonly')
        self.dropdown.place(x=70, y=0, width=120, height=25)
        self.dropdown.current(0)  # set the selected item index

        btnEnroll = tk.Button(root)
        btnEnroll["bg"] = "#e9e9ed"
        ft = tkFont.Font(family='Times', size=10)
        btnEnroll["font"] = ft
        btnEnroll["fg"] = "#000000"
        btnEnroll["justify"] = "center"
        btnEnroll["text"] = "Enroll Employees"
        btnEnroll.place(x=70, y=30, width=100, height=25)
        btnEnroll["command"] = self.btnAdd_command

        btnDel = tk.Button(root)
        btnDel["bg"] = "#e9e9ed"
        ft = tkFont.Font(family='Times', size=10)
        btnDel["font"] = ft
        btnDel["fg"] = "#000000"
        btnDel["justify"] = "center"
        btnDel["text"] = "Mark Attendance"
        btnDel.place(x=70, y=75, width=100, height=25)
        btnDel["command"] = self.btnSearch_command

        btnDel = tk.Button(root)
        btnDel["bg"] = "#e9e9ed"
        ft = tkFont.Font(family='Times', size=10)
        btnDel["font"] = ft
        btnDel["fg"] = "#000000"
        btnDel["justify"] = "center"
        btnDel["text"] = "Delete Finger"
        btnDel.place(x=70, y=120, width=100, height=25)
        btnDel["command"] = self.btnDel_command
        root.mainloop()



    def btnSearch_command(self):
        print("Searching")
        self.searchFinger()


    def btnAdd_command(self):
        print("Add Finger")
        self.enrollFinger()


    def btnDel_command(self):
        print("Delete Finger")
        self.deleteFinger()


    def enrollFinger(self):


        messagebox.showinfo("ATTENDANCE", "Enrolling Finger")
        time.sleep(2)
        messagebox.showinfo("ATTENDANCE", 'Waiting for finger...')
        print("Place Finger")
        while (self.f.readImage() == False):
            pass
        self.f.convertImage(0x01)
        result = self.f.searchTemplate()
        positionNumber = result[0]
        if (positionNumber >= 0):
            print('Template already exists at position #' + str(positionNumber))
            messagebox.showinfo("ATTENDANCE", "Finger Already Exists")

        else:

            time.sleep(2)
            # return
        print('Remove finger...')
        messagebox.showinfo("ATTENDANCE", "Remove Finger")
        time.sleep(2)
        print('Waiting for same finger again...')
        messagebox.showinfo("ATTENDANCE", "Place Same Finger Again")
        while (self.f.readImage() == False):
            pass
        self.f.convertImage(0x02)
        if (self.f.compareCharacteristics() == 0):
            print("Fingers do not match")
            messagebox.showinfo("ATTENDANCE", "Finger Did not Mactched")
            time.sleep(2)
            return
        self.f.createTemplate()
        positionNumber = self.f.storeTemplate()
        print('Finger enrolled successfully!')
        messagebox.showinfo("ATTENDANCE", "Stored successfuly")
        print('New template position #' + str(positionNumber))
        time.sleep(2)

        db=Db()

        print(self.dropdown.get())
        print(self.dropdown.get())
        sid = self.items.index(self.dropdown.get())

        print(sid)

        qry = "insert into `myapp_finger_print` (`fingerprint`,`STAFF_id`) values ('" + str(
            positionNumber) + "','" + str(self.ids[sid]) + "')"
        print(qry)
        db = Db()
        db.insert(qry)




        return positionNumber

    def searchFinger(self):
        try:
            print('Waiting for finger...')
            messagebox.showinfo("ATTENDANCE", 'Waiting for finger...')
            while (self.f.readImage() == False):
                pass
                # time.sleep(.5)
                # return
            self.f.convertImage(0x01)
            result = self.f.searchTemplate()
            positionNumber = result[0]
            accuracyScore = result[1]
            if positionNumber == -1:
                print('No match found!')
                messagebox.showinfo("ATTENDANCE", "No Match Found")
                time.sleep(2)
                return
            else:
                print('Found template at position #' + str(positionNumber))
                db=Db()

                qry="SELECT `STAFF_id` FROM `myapp_finger_print` WHERE `fingerprint`='"+str(positionNumber)+"'"
                res=db.select(qry)
                if len(res)>0:
                    sid= str(res[0]['STAFF_id'])
                    qry="select * from myapp_attendance where Date= curdate() and STAFF_id='"+sid+"' order by id DESC"
                    r2= db.select(qry)


                    try:
                        from datetime import datetime
                        office_start_time = datetime.now().strptime("11:00", "%H:%M")
                        office_noon_time = datetime.now().strptime("12:00", "%H:%M")
                        office_late_noon_time = datetime.now().strptime("14:00", "%H:%M")
                        times = datetime.now().time()
                        ntimes = str(times).split('.')[0]
                        print(ntimes,"===1")
                        nltimes = ntimes.split(':')[0] + ":" + str(ntimes).split(':')[1]
                        staff_punch_time = datetime.now().strptime(nltimes, "%H:%M")
                        time_difference = staff_punch_time - office_start_time
                        print(time_difference,"===2")
                        hours, minutes, seconds = map(int, str(time_difference).split(':'))
                        total_minutes = hours * 60 + minutes

                        if staff_punch_time > office_start_time and staff_punch_time < office_noon_time:
                            if total_minutes > 5:
                                resstff = db.selectOne("select * from myapp_staff where id='"+str(sid)+"'")
                                qryLCheck = "SELECT `LOGIN_id` FROM `myapp_leave` WHERE `LOGIN_id`='" + str(
                                    resstff['LOGIN_id']) + "' and date=CURDATE()"
                                resLCheck = db.select(qryLCheck)
                                if len(resLCheck)==0:
                                    qryLeave = "INSERT INTO `myapp_leave` (`Date`,`FromDate`,`ToDate`,`Status`,`Description`,`LeaveType`,`LOGIN_id`,`Certificate`) VALUES (CURDATE(),CURDATE(),CURDATE(),'approved','Late','Half Leave','" + str(
                                        resstff['LOGIN_id']) + "','No Certificate')"
                                    db.insert(qryLeave)
                            s = "NA"
                        elif staff_punch_time > office_late_noon_time:
                            if total_minutes > 5:
                                resstff = db.selectOne("select * from myapp_staff where id='"+str(sid)+"'")
                                qryLCheck = "SELECT `LOGIN_id`, `id` FROM `myapp_leave` WHERE `LOGIN_id`='" + str(
                                    resstff['LOGIN_id']) + "' and date=CURDATE()"
                                resLCheck = db.select(qryLCheck)
                                if len(resLCheck) > 0:
                                    print(resLCheck)
                                    resuL = resLCheck[0]
                                    sslid = resuL['id']
                                    qryLeave = "Update `myapp_leave` set LeaveType='Casual Leave' where id='"+str(sslid)+"'"
                                    db.update(qryLeave)
                            s = "NA"
                        else:
                            s = "Checkin"


                    except Exception as e:
                        s="Checkin"
                        print(e, 'eeeeeeeeeeeeeeeeeeeeee')
                        # return "Invalid time format. Please use HH:MM format."

                    try:
                        if len(r2)>0:
                            if r2[0]['Attendance']=="Checkin":
                                s="Checkout"

                    except:
                        pass


                    print("Heyyy")


                    qry="insert into `myapp_attendance` (`Date`,`Attendance`,`Time`,`STAFF_id`) values (curdate(),'"+s+"',curtime(),'"+str(sid)+"')"

                    print(qry,"Helllo")

                    db.insert(qry)
                    try:
                        sts = s
                        if s=='NA': sts = 'Late'
                        messag1e = "Attendance marked as "+sts+" Successfully at " + datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                        # message = s+' Successful'
                        resstff = db.selectOne("select * from myapp_staff where id='" + str(sid) + "'")

                        # import smtplib
                        # server = smtplib.SMTP('smtp.gmail.com', 587)
                        # server.starttls()
                        # server.login('roronoa3150@gmail.com', 'cespndyadoxhzmmn')
                        # server.sendmail(
                        #     'roronoa3150@gmail.com',
                        #     resstff['Email'],
                        #     message, )


                        message = MIMEMultipart()

                        # Set the sender, recipient, and subject
                        message['From'] = 'roronoa3150@gmail.com'
                        message['To'] = resstff[
                            'Email']  # Assuming resstff['Email'] contains the recipient's email address
                        message['Subject'] = 'Report'

                        # Add body to thmail
                        body = "This is the body of your email."
                        message.attach(MIMEText(messag1e, 'plain'))

                        # Convert the message to a string
                        text = message.as_string()
                        # text=message

                        # Connect to Gmail's SMTP server
                        server = smtplib.SMTP('smtp.gmail.com', 587)
                        server.starttls()

                        # Log in to your Gmail account
                        server.login('roronoa3150@gmail.com', 'cespndyadoxhzmmn')

                        # Send the email
                        server.sendmail('roronoa3150@gmail.com', resstff['Email'], text)








                        print(message)
                    except Exception as e:
                        print(e, 'mmmmmmmmmmmZ')
                        pass

                messagebox.showinfo("ATTENDANCE", "Fingerprint Found at position " + str(positionNumber) + "!!!")
                time.sleep(2)
            return positionNumber

        except Exception as e:
            print('Operation failed!')
            print('Exception message: ' + str(e))
            # exit(1)


    def deleteFinger(self):
        positionNumber = 0
        count = simpledialog.askinteger("ATTENDANCE", "Which ID number you need to delete", minvalue=1, maxvalue=1000)
        print("Position: " + str(count))
        positionNumber = count
        if self.f.deleteTemplate(positionNumber) == True:
            print('Template deleted!')
            messagebox.showinfo("ATTENDANCE", "Finger ID deleted")
            time.sleep(2)

            return "ok"

a=abc(12)
