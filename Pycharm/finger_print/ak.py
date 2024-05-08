import time
from pyfingerprint.pyfingerprint import PyFingerprint
# import RPi.GPIO as GPIO
# import Adafruit_DHT

import tkinter as tk
import tkinter.font as tkFont
from tkinter import *
from tkinter import messagebox
from tkinter import simpledialog

# DHT_SENSOR = Adafruit_DHT.DHT11
DHT_PIN = 4
MOT_L = 2
MOT_R = 3

try:
    f = PyFingerprint('COM10', 57600, 0xFFFFFFFF, 0x00000000)

    if (f.verifyPassword() == False):
        raise ValueError('The given fingerprint sensor password is wrong!')

except Exception as e:
    print('Exception message: ' + str(e))
    exit(1)


class App:
    def __init__(self, root):
        # GPIO.setwarnings(False)
        # GPIO.setmode(GPIO.BCM)
        # GPIO.setup(MOT_R, GPIO.OUT)
        # GPIO.setup(MOT_L, GPIO.OUT)
        # setting title
        root.title("Biometric ATM System")
        # setting window size
        width = 255
        height = 229
        screenwidth = root.winfo_screenwidth()
        screenheight = root.winfo_screenheight()
        alignstr = '%dx%d+%d+%d' % (width, height, (screenwidth - width) / 2, (screenheight - height) / 2)
        root.geometry(alignstr)
        root.resizable(width=False, height=False)

        btnEnroll = tk.Button(root)
        btnEnroll["bg"] = "#e9e9ed"
        ft = tkFont.Font(family='Times', size=10)
        btnEnroll["font"] = ft
        btnEnroll["fg"] = "#000000"
        btnEnroll["justify"] = "center"
        btnEnroll["text"] = "Enroll"
        btnEnroll.place(x=40, y=30, width=70, height=25)
        btnEnroll["command"] = self.btnEnroll_command

        btnAtm = tk.Button(root)
        btnAtm["bg"] = "#e9e9ed"
        ft = tkFont.Font(family='Times', size=10)
        btnAtm["font"] = ft
        btnAtm["fg"] = "#000000"
        btnAtm["justify"] = "center"
        btnAtm["text"] = "ATM"
        btnAtm.place(x=120, y=30, width=70, height=25)
        btnAtm["command"] = self.btnAtm_command

        btnAdd = tk.Button(root)
        btnAdd["bg"] = "#e9e9ed"
        ft = tkFont.Font(family='Times', size=10)
        btnAdd["font"] = ft
        btnAdd["fg"] = "#000000"
        btnAdd["justify"] = "center"
        btnAdd["text"] = "Add Finger"
        btnAdd.place(x=40, y=110, width=70, height=25)
        btnAdd["command"] = self.btnAdd_command

        btnDel = tk.Button(root)
        btnDel["bg"] = "#e9e9ed"
        ft = tkFont.Font(family='Times', size=10)
        btnDel["font"] = ft
        btnDel["fg"] = "#000000"
        btnDel["justify"] = "center"
        btnDel["text"] = "Delete Finger"
        btnDel.place(x=120, y=110, width=85, height=25)
        btnDel["command"] = self.btnDel_command

        btnWithDraw = tk.Button(root)
        btnWithDraw["bg"] = "#e9e9ed"
        ft = tkFont.Font(family='Times', size=10)
        btnWithDraw["font"] = ft
        btnWithDraw["fg"] = "#000000"
        btnWithDraw["justify"] = "center"
        btnWithDraw["text"] = "Withdraw"
        btnWithDraw.place(x=10, y=170, width=70, height=25)
        btnWithDraw["command"] = self.btnWithDraw_command

        btnDeposit = tk.Button(root)
        btnDeposit["bg"] = "#e9e9ed"
        ft = tkFont.Font(family='Times', size=10)
        btnDeposit["font"] = ft
        btnDeposit["fg"] = "#000000"
        btnDeposit["justify"] = "center"
        btnDeposit["text"] = "Deposit"
        btnDeposit.place(x=90, y=170, width=70, height=25)
        btnDeposit["command"] = self.btnDeposit_command

        btnBalance = tk.Button(root)
        btnBalance["bg"] = "#e9e9ed"
        ft = tkFont.Font(family='Times', size=10)
        btnBalance["font"] = ft
        btnBalance["fg"] = "#000000"
        btnBalance["justify"] = "center"
        btnBalance["text"] = "Balance"
        btnBalance.place(x=170, y=170, width=70, height=25)
        btnBalance["command"] = self.btnBalance_command

    def btnEnroll_command(self):
        print("Enrolling")
        enrollFinger()

    def btnAtm_command(self):
        print("ATM")
        # messagebox.showinfo("Temperature", "Checking the temperature please wait")
        # humidity, temperature = Adafruit_DHT.read(DHT_SENSOR, DHT_PIN)
        # if humidity is not None and temperature is not None:
        #     print("Temp={0:0.1f}C  Humidity={1:0.1f}%".format(temperature, humidity))
        #     if (temperature <= 38):
        #         pos = searchFinger()
        #         messagebox.showinfo("BioATM", str(pos))
        #
        #     else:
        #         messagebox.showinfo("BioATM", "Please Check R.T.P.C.R")
        # else:
        #     print("Sensor failure. Check wiring.")
        #     messagebox.showerror("Temperature", "Sensor failure. Check wiring.")
        #     exit(1)

    def btnAdd_command(self):
        print("Add Finger")
        enrollFinger()

    def btnDel_command(self):
        print("Delete Finger")
        deleteFinger()

    def btnWithDraw_command(self):
        print("Withdraw amount")
        motorActivate()  # this function will activate motor

    def btnDeposit_command(self):
        print("Deposit Amount")

    def btnBalance_command(self):
        print("Balance Check")


def enrollFinger():
    messagebox.showinfo("Biometric ATM", "Enrolling Finger")
    time.sleep(2)
    messagebox.showinfo("Biometric ATM", 'Waiting for finger...')
    print("Place Finger")
    while (f.readImage() == False):
        pass
    f.convertImage(0x01)
    result = f.searchTemplate()
    positionNumber = result[0]
    if (positionNumber >= 0):
        print('Template already exists at position #' + str(positionNumber))
        messagebox.showinfo("Biometric ATM", "Finger Already Exists")
        time.sleep(2)
        return
    print('Remove finger...')
    messagebox.showinfo("Biometric ATM", "Remove Finger")
    time.sleep(2)
    print('Waiting for same finger again...')
    messagebox.showinfo("Biometric ATM", "Place Same Finger Again")
    while (f.readImage() == False):
        pass
    f.convertImage(0x02)
    if (f.compareCharacteristics() == 0):
        print("Fingers do not match")
        messagebox.showinfo("Biometric ATM", "Finger Did not Mactched")
        time.sleep(2)
        return
    f.createTemplate()
    positionNumber = f.storeTemplate()
    print('Finger enrolled successfully!')
    messagebox.showinfo("Biometric ATM", "Stored successfuly")
    print('New template position #' + str(positionNumber))
    time.sleep(2)


def searchFinger():
    try:
        print('Waiting for finger...')
        while (f.readImage() == False):
            # pass
            time.sleep(.5)
            return
        f.convertImage(0x01)
        result = f.searchTemplate()
        positionNumber = result[0]
        accuracyScore = result[1]
        if positionNumber == -1:
            print('No match found!')
            messagebox.showinfo("Biometric ATM", "No Match Found")
            time.sleep(2)
            return
        else:
            print('Found template at position #' + str(positionNumber))
            messagebox.showinfo("Biometric ATM", "Fingerprint Found !!!")
            time.sleep(2)
        return positionNumber

    except Exception as e:
        print('Operation failed!')
        print('Exception message: ' + str(e))
        exit(1)


def deleteFinger():
    positionNumber = 0
    count = simpledialog.askinteger("Biometric ATM", "Which ID number you need to delete", minvalue=1, maxvalue=1000)
    print("Position: " + str(count))
    positionNumber = count
    if f.deleteTemplate(positionNumber) == True:
        print('Template deleted!')
        messagebox.showinfo("Biometric ATM", "Finger ID deleted")
        time.sleep(2)


def motorActivate():
    print("Activating motor")
    # GPIO.output(MOT_L, GPIO.HIGH)
    # GPIO.output(MOT_R, GPIO.LOW)
    # time.sleep(2)
    # GPIO.output(MOT_L, GPIO.LOW)
    # GPIO.output(MOT_R, GPIO.LOW)
    # time.sleep(0.250)
    # GPIO.output(MOT_L, GPIO.LOW)
    # GPIO.output(MOT_R, GPIO.HIGH)
    # time.sleep(2)
    # GPIO.output(MOT_L, GPIO.LOW)
    # GPIO.output(MOT_R, GPIO.LOW)


if __name__ == "__main__":
    root = tk.Tk()
    app = App(root)
    root.mainloop()

