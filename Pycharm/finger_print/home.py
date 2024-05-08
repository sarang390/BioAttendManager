import tkinter
from tkinter import *



root=Tk()
root.geometry('600x600+350+40')


def finger():
    import subprocess
    subprocess.run(['python','finger.py'])


def checkfinger():
    import subprocess 
    subprocess.run(['python','verification.py'])


b1=Button(root,text="Fingureprint Registration", command= finger)
b1.place(relx=0.475,rely=0.5)


b2=Button(root,text="Verify and Vote candidate", command= checkfinger)
b2.place(relx=0.475,rely=0.6)


root.mainloop()
