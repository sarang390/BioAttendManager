from django.db import models

# Create your models here.

class Login(models.Model):
    Username=models.CharField(max_length=100)
    Password=models.CharField(max_length=100)
    Type=models.CharField(max_length=100)

class Department(models.Model):
    DepartmentName=models.CharField(max_length=100)

class Staff(models.Model):
    Name=models.CharField(max_length=100)
    Age=models.IntegerField()
    Gender=models.CharField(max_length=10)
    Place=models.CharField(max_length=100)
    Post=models.CharField(max_length=50)
    District=models.CharField(max_length=50)
    State=models.CharField(max_length=50)
    Email=models.CharField(max_length=100)
    Phone=models.BigIntegerField()
    Photo=models.CharField(max_length=100)
    Status=models.CharField(max_length=100, default='pending')
    DEPARTMENT=models.ForeignKey(Department,on_delete=models.CASCADE)
    LOGIN=models.ForeignKey(Login,on_delete=models.CASCADE)
    # phoneid=models.CharField(max_length=100)

class Hod(models.Model):
    STAFF=models.ForeignKey(Staff,on_delete=models.CASCADE)
    DEPARTMENT=models.ForeignKey(Department,on_delete=models.CASCADE)
    Date=models.DateField()

class Leave(models.Model):
    Date=models.DateField()
    FromDate=models.DateField()
    ToDate=models.DateField()
    Status=models.CharField(max_length=100)
    LOGIN=models.ForeignKey(Login,on_delete=models.CASCADE,default="")
    Description=models.CharField(max_length=500)
    LeaveType=models.CharField(max_length=100)
    Certificate=models.CharField(max_length=200)
    # HOD=models.ForeignKey(Hod, on_delete=models.CASCADE,default='')

class Attendance(models.Model):
    STAFF=models.ForeignKey(Staff,on_delete=models.CASCADE,default='')
    Date=models.DateField()
    Attendance=models.CharField(max_length=100)
    # Type=models.CharField(max_length=100)
    Time=models.CharField(max_length=100,default='')


class Services(models.Model):
    STAFF=models.ForeignKey(Staff,on_delete=models.CASCADE)
    ServiceName=models.CharField(max_length=100)
    FromDate = models.DateField()
    ToDate = models.DateField()
    Duration=models.CharField(max_length=100)
    Certificate=models.CharField(max_length=100)


class Finger_print(models.Model):
    STAFF=models.ForeignKey(Staff,on_delete=models.CASCADE)
    fingerprint=models.CharField(max_length=250)

