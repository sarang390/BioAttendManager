from tkinter import *
import tkinter
from serial import Serial, time
from tkinter import messagebox
from tkinter.ttk import Combobox
from math import log

import pymysql
# con=pymysql.Connect(host='localhost',port=3308,user='root',passwd='root',db='fingerprint')
# cmd=con.cursor()

root=Tk()
root.geometry('980x650+20+0')
connected = 0
serialport = 0
finalid=0
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
        global RecievedString
        while (serialport.inWaiting() > 0):
            if (serialport.inWaiting() > 0):
                reading.append(ord(serialport.read(1)))
            time.sleep(0.001)
        global finalid
        if reading != []:
            print(reading)
            hexstring = ''
            if str(reading[0])!="0":
                for i in reading:
                    hexstring += hex(i)[2:] + ' '
                print(hexstring)
                if hexstring=="cc " or hexstring=="ff ":
                    pass
                else:

                        hexlist=hexstring.split(' ')
                        id=''
                        for ii in hexlist:
                            try:
                                finalid=int(hexstring)
                                print(str(finalid),"hexa")
                                e1.insert(tkinter.INSERT, hexstring + '\n')
                                RecievedField.insert(tkinter.INSERT, hexstring + '\n')
                                RecievedField.see('end')
                                break
                            except:
                                pass

    root.after(1, Recive)

def stud():
    # crs2 = combo2.get()
    # print(crs2)
    # sem = combo3.get()
    # print(sem)
    # cmd.execute("select name from student where course='"+str(crs2)+"' and sem='"+str(sem)+"'")
    # s=cmd.fetchone()
    # st=list(s)
    # combo4= st.keys()
    sid= combo4.get()
    print("sid=====",sid)
    cmd.execute("SELECT `name` FROM `student`")
    s = cmd.fetchall()
    combo4['values'] = s

def SerialConnect():
    global serialport
    try:
        serialport = Serial(port=comboExample.get(), baudrate=9600)
        print("port====",serialport)
        global connected
        connected = 1
        messagebox.showinfo("Connection", "Successfull")
    except Exception as  e:
        print(e)
        messagebox.showinfo("Connection", "Error")

def insert():
    sid=combo4.get()
    print(sid)
    cmd.execute("select id from student where name='"+sid+"'")
    s=cmd.fetchone()
    stid=str(s[0])
    print(stid)
    fid=e1.get()
    print(fid)
    cmd.execute("insert into finger values(null,'"+str(stid)+"','"+fid+"')")
    con.commit()

InputString = tkinter.StringVar()
RepeatString = tkinter.StringVar()
RepeatString.set('1')
RecievedScrool = tkinter.Scrollbar(root)
RecievedScrool.grid(row=120, column=100, sticky="nsew")
RecievedField = tkinter.Text(root, bg='white', yscrollcommand=RecievedScrool.set)
RecievedField.grid(row=120, columnspan=99, sticky="nsew")
l1= Label(root,text="SERIAL PORT")
l1.place(relx=0.25,rely=0.25)


# e2=Entry(root)
# e2.place(relx=0.35,rely=0.25)

comboExample = Combobox(root,values=["COM4", "COM5","COM6","COM7"] )
comboExample.place(relx=0.35,rely=0.25)
comboExample.current(0)
b1=Button(root,text="CONNECT", command=SerialConnect)
b1.place(relx=0.50,rely=0.25)

# l2=Label(root,text="STUDENT")
# l2.place(relx=0.25,rely=0.30)
cmd.execute("SELECT `name` FROM `student`")
s=cmd.fetchall()
# combo2 = Combobox(root,values=s)
# combo2.place(relx=0.35,rely=0.30)
# combo2.current(1)
# print(combo2.current(0))
# l3=Label(root,text="SEM")
# l3.place(relx=0.25,rely=0.35)
# combo3 = Combobox(root,values=["1", "2", "3","4","5","6"])
# combo3.place(relx=0.35,rely=0.35)
# combo3.current(0)
# b2=Button(root,text="SEARCH", command=stud)
# b2.place(relx=0.50,rely=0.34)
l5 = Label(root, text="STUDENT")
l5.place(relx=0.25, rely=0.40)

def justamethod():
    print("method is called")
    print (combo4.get())

box_value = StringVar()
combo4 = Combobox(root, values=s)
# combo4.bind("<<ComboboxSelected>>", justamethod())
combo4.place(relx=0.35,rely=0.40)
combo4.current(0)

l4=Label(root,text="FINGER ID")
l4.place(relx=0.25,rely=0.45)
e1=Entry(root)
e1.place(relx=0.35,rely=0.45)
b2=Button(root,text="REGISTER",command=insert)
b2.place(relx=0.25,rely=0.50)
root.after(1, Recive)

root.mainloop()

