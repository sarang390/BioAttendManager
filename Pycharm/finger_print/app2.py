import tkinter
from tkinter import *
from tkinter.ttk import Combobox
from tkinter import messagebox

import PIL
from PIL import Image, ImageTk


# from src.login1 import  log
import MySQLdb

# from src.loginn import log

con=MySQLdb.connect(host='localhost',user='root',passwd="",port=3306,db="sams")
cmd=con.cursor()

a1=None
global iddd
def login11(uid):
    print(uid)
    global iddd
    iddd= uid
    vhome = Tk()
    vhome.geometry('900x900+350+90')
    global  a1
    z = StringVar()
    q=StringVar()
    v = IntVar()
    # cmd.execute("select name from constituency")
    # cmd.execute("")
    # n = cmd.fetchone()
    #
    # print(n)
    # # a1=Combobox(vhome,value=n,textvariable=z)
    # # a1.place(relx=0.275,rely=0.1)
    #
    # a2=Label(vhome,text="Course - "+n[0])
    # a2.place(relx=0.155,rely=0.2)
    #
    # a8 = Label(vhome, text="photo")
    # a8.place(relx=0.455, rely=0.148)
    #
    # a7 = Label(vhome,text="Name - "+n[3])
    # a7.place(relx=0.155, rely=0.259)
    #
    # a3 = Label(vhome, text="Year - "+str(n[1]))
    # a3.place(relx=0.155, rely=0.148)
    #
    # img = PIL.Image.open(r"C:\Users\rahee\PycharmProjects\vote\src\static\photo\\" + n[2])
    # img = img.resize((100, 100), PIL.Image.ANTIALIAS)
    # ii = ImageTk.PhotoImage(img)
    #
    # # ii=PhotoImage(file=r"C:\Users\rahee\PycharmProjects\vote\src\static\photo\\" + n[2])
    #
    # # w,h=ii.width(), ii.height()
    # #
    # # scale_w = 150 / w
    # # scale_h = 150 / h
    # # ii.zoom(scale_w, scale_h)
    #
    #
    # canvas = tkinter.Label(vhome, image=ii, width=100, height=100)
    #
    #
    # canvas.place(relx=0.455, rely=0.205)
    #
    # # a4 = Combobox(vhome, value=(1,2,3),textvariable=q)
    # # a4.place(relx=0.495, rely=0.1)
    #
    # b7 = Button(vhome, text="key Generation", command=genr)
    # b7.place(relx=0.375, rely=0.025)



    def search():
        # cmd.execute("SELECT `course`,`Year` FROM `login_id`="+str(uid))
        # s=cmd.fetchone()
        cmd.execute("SELECT `candidate`.`first_name`,`post`.`postname`,`candidate`.`candidate_id`,post.pid FROM `candidate` JOIN `post` ON `post`.`pid`=`candidate`.`pid`")
        s=cmd.fetchall()
        print(s)
        i=0.0
        img=[]

        k=0
        for d in s:
            print(d)
            global id
            # global vhome
            id=d[2]
            a3=Label(vhome,text=d[0])
            a3.place(relx=0.155,rely=(0.15*i)+0.2)

            ########################################
            # print("C:\\Users\\rahee\PycharmProjects\\vote\\src\\static\\symbol\\"+d[1])
            # img.append(PhotoImage(file=r"C:\Users\rahee\PycharmProjects\vote\src\static\symbol\\"+d[1]))
            # canvas = tkinter.Label(vhome,image=img[k], width=100, height=100)
            # k+=1
            # print('haaaaai', type(canvas))
            # # cn = canvas.create_image(20, 20, anchor=NW, )
            # canvas.place(relx=0.455,rely=(0.15*i)+0.5)
            #

            a4 = Label(vhome, text=d[1])
            a4.place(relx=0.455, rely=(0.15 * i) + 0.2)


            qw = Radiobutton(vhome,variable=v, value=int(d[2]))
            qw.place(relx=0.675, rely=(0.15*i)+0.2)
            i=i+1.0

        vhome.mainloop()

    # b1=Button(vhome,text="Search",command=search())
    # b1.place(relx=0.675,rely=0.1)




    l1=Label(vhome,text="CANDIDATE", fg="black" ,font=(None, 13) )
    l1.place(relx=0.155,rely=0.1)





    q1=Label(vhome,text="POST",fg="black" ,font=(None, 13))
    q1.place(relx=0.455,rely=0.1)
    def vote():


        idd=v.get()

        print(idd)

        # cmd.execute("SELECT `pid` FROM `candidate` WHERE `candidate_id`='"+str(idd)+"'")
        # postid= cmd.fetchone()

        # with open('session_id.txt', 'w') as f:
        #     f.write(str(idd))

        cmd.execute("select vote from vote where candidate_id='"+str(idd)+"'")
        s=cmd.fetchone()
        if(s is None):

            cmd.execute("insert into vote values(null,'1','"+str(idd)+"')")
            con.commit()

            with open('session_id.txt', 'r') as f:
                fid = f.read()

            cmd.execute(" select sid from finger where id=" + str(fid))
            s = cmd.fetchone()

            cmd.execute("insert into votelist values(null,'" + str(s[0]) + "')")
            con.commit()

        else:
            with open('session_id.txt', 'r') as f:
                fid = f.read()

            cmd.execute(" select sid from finger where id=" + str(fid))
            s = cmd.fetchone()

            cmd.execute("insert into votelist values(null,'" + str(s[0]) + "')")
            con.commit()

            cmd.execute("update vote set vote=vote+1 where  candidate_id='"+str(idd)+"'")
            con.commit()




        messagebox.showerror("Result", "You have voted successfully")
        vhome.destroy()

    c1=Button(vhome,text="vote",command=vote)
    c1.place(relx=0.775,rely=0.5)

    search()

    vhome.mainloop()
login11(14)
