#!/usr/bin/python3
# import cognitive_face as CF
import time
from tkinter import messagebox
# import cv2
import pymysql
from serial import Serial
import sys

# from encode_faces import *
# from recognize_face import *
from math import log
import tkinter
con=pymysql.connect(host='localhost',user='root',passwd="",port=3306,db="sams")
cmd=con.cursor()

# def verifi():
connected = 0
serialport = 0
finalid = -1
flag =0

def bytes_needed(n):
    if n == 0:
        return 1
    return int(log(n, 256)) + 1

def ToHexList(num):
    lenght = bytes_needed(num)
    if lenght == 0:
        return 0
    liste = []
    for i in range(lenght):
        bitwise = 0xff << i * 8
        liste.append(chr((num & bitwise) >> 8 * i))
    liste.reverse()
    return liste

def ToHexList2(num):
    lenght = bytes_needed(num)
    if lenght == 0:
        return 0
    liste = []
    for i in range(lenght):
        bitwise = 0xff << i * 8
        liste.append(hex((num & bitwise) >> 8 * i))
    liste.reverse()
    return liste

def ToInt(liste):
    tal = 0
    for i in range(len(liste)):
        tal += liste[i] << ((len(liste) - (i + 1)) * 8)
    return tal

def SerialConnect():
    global serialport
    try:
        serialport = Serial(port=PortPath.get(), baudrate=9600)
        global connected
        connected = 1
        messagebox.showinfo("Connection", "Successfull")
    except:
        messagebox.showinfo("Connection", "Error")

def SendInput():
    if connected:
        command = InputString.get()
        command = int(command, 16)
        command = ToHexList(command)
        for i in range(int(RepeatString.get())):
            serialport.write(command)
            time.sleep(0.001)

def Recive():
    reading = []
    if connected:
        # print("r1")
        global RecievedString
        while (serialport.inWaiting() > 0):

            print("r3")
            if (serialport.inWaiting() > 0):
                reading.append(ord(serialport.read(1)))
            time.sleep(0.001)
        global finalid
        if reading != []:
            # print(reading)0
            hexstring = ''
            global flag
            flag=0

            print("r2",reading)

            if str(reading[0]) != "0":
                messagebox.showinfo("Reading", "reading success")
                # for i in reading:
                #     print(i)
                #     hexstring += hex(i)[2:] + ' '
                # print("hexxxx-----",hexstring)
                reading=reading[0]
                if str(reading) == 'ff' or reading=="cc":
                    flag=1
                    messagebox.showinfo("Reading", "invalid id")
                else:

                    print('hii')
                    flag=0
                    # finalid = int(hexstring) - 30
                    finalid = int(reading)

                    # cap = cv2.VideoCapture(0)
                    # while (True):
                    #     ret, frame = cap.read()
                    #     rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2BGRA)
                    #     cv2.imshow('frame', rgb)
                    #     if cv2.waitKey(1) & 0xFF == ord('q'):
                    #         out = cv2.imwrite("comp.jpg", frame)
                    #         break
                    #
                    #
                    #
                    # cap.release()
                    # cv2.destroyAllWindows()


                    print(str(finalid), "hexa")
                    RecievedField.insert(tkinter.INSERT, str(finalid) + '\n')
                    RecievedField.see('end')
                    messagebox.showinfo("Reading", "success")


    top.after(1, Recive)

def nextt():
    global finalid
    global flag
    print("f--",flag)

    if flag==0:
        try:
            cmd.execute(" select STAFF_id from myapp_finger_print where id=" + str(finalid))
            # cmd.execute(" select sid from finger where id=" + str(finalid))
            s = cmd.fetchone()

            with open('session_id.txt', 'w') as f:
                f.write(str(finalid))

            print("------")
            print(s)
            # cmd.execute("select * from voterrequest_table where vstatus='voted' and id='"+str(s[0])+"'")
            # st=cmd.fetchone()
            #
            # print("st---",st)
            # if s is not None:
            #
            #     cmd.execute("select * from `votelist` WHERE `user_id`='"+str(s[0])+"'")
            #     vv= cmd.fetchone()
            #     if( vv is None):
            #
            #             import subprocess
            #             subprocess.run(['python', 'app2.py'])
            #             messagebox.showinfo("Verification", " eligible")
            #     else:
            #         messagebox.showinfo("Verification", "You have already voted")
            # else:
            #     messagebox.showinfo("Verification", "sorry ur not eligible")
            #


        except Exception as e:
                        print(e)
                        messagebox.showinfo("Verification", "sorry ur not eligible")

        except Exception as e:
            print(e)
            messagebox.showinfo("Verification", "Error")
    else:
        messagebox.showinfo("Verification", "sorry ur not eligible")

top = tkinter.Tk()  # Main Windows
RWidth = top.winfo_screenwidth()
RHeight = top.winfo_screenheight()
top.minsize(50, 50)
top.maxsize(500, 500)
InputString = tkinter.StringVar()  # String for the input window
RecievedString = tkinter.StringVar()
RepeatString = tkinter.StringVar()
RepeatString.set('1')
PortPath = tkinter.StringVar()
SendButton = tkinter.Button(top, command=SendInput, text="Send", anchor='w')  # Button to send
PortField = tkinter.Entry(top, textvariable=PortPath)
PortField.grid(row=90, column=0, sticky="nsew")
ConnectButton = tkinter.Button(top, command=SerialConnect, text="Connect")
ConnectButton.grid(row=90, column=1, columnspan=2, sticky="nsew")
RecievedScrool = tkinter.Scrollbar(top)

RecievedScrool.grid(row=120, column=100, sticky="nsew")
RecievedField = tkinter.Text(top, bg='white', yscrollcommand=RecievedScrool.set)
RecievedField.grid(row=120, columnspan=99, sticky="nsew")

ConnectButton = tkinter.Button(top, command=nextt, text="NEXT")
ConnectButton.grid(row=100, column=0, sticky="nsew")

top.columnconfigure(0, weight=1)
top.columnconfigure(1, weight=1)
top.rowconfigure(100, weight=0)  # not needed, this is the default behavior
top.rowconfigure(11, weight=0)
top.rowconfigure(120, weight=1)
top.after(1, Recive)



top.mainloop()  # Start main loop

# verifi()