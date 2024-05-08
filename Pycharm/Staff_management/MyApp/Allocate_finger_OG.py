import time
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
            self.f = PyFingerprint('COM11',9600,0xFFFFFFFF, 0x00000000)
            print("connected")
            # print(self.f.verifyPassword())
            if (self.f.verifyPassword() == False):
                raise ValueError('The given fingerprint sensor password is wrong!')

        except Exception as e:
            print('Exception message: ' + str(e))

        root = tk.Tk()

        # setting title
        root.title("E VOTING")
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


        messagebox.showinfo("E VOTING", "Enrolling Finger")
        time.sleep(2)
        messagebox.showinfo("E VOTING", 'Waiting for finger...')
        print("Place Finger")
        while (self.f.readImage() == False):
            pass
        self.f.convertImage(0x01)
        result = self.f.searchTemplate()
        positionNumber = result[0]
        if (positionNumber >= 0):
            print('Template already exists at position #' + str(positionNumber))
            messagebox.showinfo("E VOTING", "Finger Already Exists")

        else:

            time.sleep(2)
            # return
        print('Remove finger...')
        messagebox.showinfo("E VOTING", "Remove Finger")
        time.sleep(2)
        print('Waiting for same finger again...')
        messagebox.showinfo("E VOTING", "Place Same Finger Again")
        while (self.f.readImage() == False):
            pass
        self.f.convertImage(0x02)
        if (self.f.compareCharacteristics() == 0):
            print("Fingers do not match")
            messagebox.showinfo("E VOTING", "Finger Did not Mactched")
            time.sleep(2)
            return
        self.f.createTemplate()
        positionNumber = self.f.storeTemplate()
        print('Finger enrolled successfully!')
        messagebox.showinfo("E VOTING", "Stored successfuly")
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
            messagebox.showinfo("E VOTING", 'Waiting for finger...')
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
                messagebox.showinfo("E VOTING", "No Match Found")
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
                    s="Checkin"
                    if len(r2)>0:
                        if r2[0]['Attendance']=="Checkin":
                            s="Checkout"
                    qry="insert into `myapp_attendance` (`Date`,`Attendance`,`Time`,`STAFF_id`) values (curdate(),'"+s+"',curtime(),'"+str(sid)+"')"
                    db.insert(qry)

                messagebox.showinfo("E VOTING", "Fingerprint Found at position " + str(positionNumber) + "!!!")
                time.sleep(2)
            return positionNumber

        except Exception as e:
            print('Operation failed!')
            print('Exception message: ' + str(e))
            exit(1)


    def deleteFinger(self):
        positionNumber = 0
        count = simpledialog.askinteger("E VOTING", "Which ID number you need to delete", minvalue=1, maxvalue=1000)
        print("Position: " + str(count))
        positionNumber = count
        if self.f.deleteTemplate(positionNumber) == True:
            print('Template deleted!')
            messagebox.showinfo("E VOTING", "Finger ID deleted")
            time.sleep(2)

            return "ok"

a=abc(12)