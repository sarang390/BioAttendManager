import datetime
import threading
from time import sleep

from django.core.files.storage import FileSystemStorage
from django.core.mail import send_mail
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render, redirect

# Create your views here.
from MyApp.models import *
from Staff_management import settings


def login(request):
    return render(request,'loginindex.html')
def login_post(request):
    username=request.POST['textfield']
    password=request.POST['textfield2']
    var = Login.objects.filter(Username=username, Password=password)
    if var.exists():
        var2 = Login.objects.get(Username=username, Password=password)
        request.session['lid'] = var2.id
        if var2.Type == 'admin':
            return HttpResponse('''<script>window.location='/MyApp/admin_home/'</script>''')

        elif var2.Type == 'hod':
            return HttpResponse('''<script>window.location='/MyApp/hod_home/'</script>''')
        else:
            return HttpResponse('''<script>alert('invalid');window.location='/MyApp/login/'</script>''')
    else:
        return HttpResponse('''<script>alert('invalid');window.location='/MyApp/login/'</script>''')

def forgot(request):
    return render(request, 'forgotpswd.html')


def forget_post(request):
    em = request.POST['em_add']
    import random
    password = random.randint(00000000, 99999999)
    log = Login.objects.filter(Username=em)
    if log.exists():
        logg = Login.objects.get(Username=em)
        message = 'temporary password is ' + str(password)
        send_mail(
            'temp password',
            message,
            settings.EMAIL_HOST_USER,
            [em, ],
            fail_silently=False
        )
        logg.Password = password
        logg.save()
        return HttpResponse('''<script>window.location='/MyApp/login/'</script>''')
    else:
        return HttpResponse('''<script>window.location='/MyApp/forgot/'</script>''')


def logout(request):
    request.session['lid']=''
    return HttpResponse('''<script>alert('logged out');window.location='/MyApp/login/'</script>''')


# def forgot_post(request):
#     username = request.POST['textfield']
#     if not Login.objects.filter(Username=username).exists():
#         return HttpResponse('''<script>alert('email does not exist');window.location='/Myapp/login/'</script>''')
#     import smtplib
#     import random
#     new_pass = random.randint(00000000, 99999999)
#     server = smtplib.SMTP('smtp.gmail.com', 587)
#     server.starttls()
#     server.login("sarangshajikumar@gmail.com", "vapq zeyj jrxw rtmk")
#
#     to = username
#     subject = "Password Reset"
#     body = "Your new password is " + str(new_pass)
#     msg = f"Subject: {subject}\n\n\{body}"
#     server.sendmail("sarangshajikumar@gmail.com", to, msg)
#     server.quit()
#     Login.objects.filter(Username=username).update(Password=new_pass)
#     return HttpResponse('''<script>alert('changed');window.location='/Myapp/login/'</script>''')

#Admin


def add_department(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
      return render(request,'admin/add department.html')
def add_department_post(request):
    department=request.POST['textfield']
    if Department.objects.filter(DepartmentName=department).exists():
        return HttpResponse('''<script>alert('Already Exist');window.location='/MyApp/add_department/'</script>''')

    obj=Department()
    obj.DepartmentName=department
    obj.save()
    return HttpResponse('''<script>alert('Department Added');window.location='/MyApp/add_department/'</script>''')
def admin_home(requset):
    return render(requset,'admin/adminhomepageindex.html')


def add_hod(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Staff.objects.all()
        obj1 = Department.objects.all()
        return render(request,'admin/add hod.html',{'data':obj,'data1':obj1})

def get_staff(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        if request.method == 'GET' and 'department_id' in request.GET:
            department_id = request.GET.get('department_id')
            staff_members = Staff.objects.filter(DEPARTMENT_id=department_id)
            staff_data = [{'id': staff.id, 'Name': staff.Name} for staff in staff_members]
            return JsonResponse(staff_data, safe=False)
        else:
            return JsonResponse({'error': 'Invalid request'})
def add_hod_post(request):
    staff=request.POST['select']
    Department=request.POST['select2']
    if Hod.objects.filter(DEPARTMENT_id=Department).exists():
        return HttpResponse('''<script>alert('Hod Already Exist');window.location='/MyApp/add_hod/'</script>''')
    a = Hod.objects.filter(DEPARTMENT_id=Department)
    if a.exists():
        a = a[0]
        Login.objects.filter(id=a.STAFF.LOGIN.id).update(Type="staff")
    obj=Hod()
    obj.STAFF_id=staff
    obj.DEPARTMENT_id=Department
    import datetime
    obj.Date=datetime.date.today()
    obj.save()
    s=Staff.objects.get(id=staff).LOGIN.id
    res=Login.objects.filter(id=s).update(Type='hod')
    return HttpResponse('''<script>alert('Hod Added');window.location='/MyApp/add_hod/'</script>''')

def add_staff(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        res=Department.objects.all()
        return render(request,'admin/add staff.html',{'data':res})
def add_staff_post(request):
    Name=request.POST['textfield']
    Age=request.POST['textfield2']
    Gender=request.POST['RadioGroup1']
    Place=request.POST['textfield3']
    Post=request.POST['textfield4']
    District=request.POST['textfield5']
    State=request.POST['textfield6']
    email=request.POST['textfield7']
    Phone=request.POST['textfield8']
    Photo=request.FILES['fileField']
    from datetime import datetime
    date=datetime.now().strftime("%Y%m%d%H%M%S")+".jpg"
    fs=FileSystemStorage()
    b=fs.save(date,Photo)
    path=fs.url(date)
    Department=request.POST['select']

    l=Login()
    l.Username=email
    import random
    new_pass=random.randint(0000,9999)
    l.Password=str(new_pass)
    l.Type='staff'
    l.save()

    obj=Staff()
    obj.Name=Name
    obj.Age=Age
    obj.Gender=Gender
    obj.Place=Place
    obj.Post=Post
    obj.District=District
    obj.State=State
    obj.Email=email
    obj.Phone=Phone
    obj.Photo=path
    obj.DEPARTMENT_id=Department
    obj.LOGIN=l
    obj.save()
    return HttpResponse('''<script>alert('Staff Added');window.location='/MyApp/add_staff/'</script>''')


def admin_change_password(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
    # if request.session['lid']=='':
    #     return redirect('/MyApp/login/')
        return render(request,'Admin/Changepassword.html')

def admin_change_password_post(request):
    if request.session['lid']=='':
        return redirect('/MyApp/login/')
    old=request.POST['textfield']
    new=request.POST['textfield2']
    confirm=request.POST['textfield3']

    var = Login.objects.filter(Password=old)
    if var.exists():
        if new==confirm:
            var2=Login.objects.filter(Password=old).update(Password=confirm)
            return HttpResponse('''<script>alert('success');window.location='/MyApp/login/'</script>''')
        else:
            return HttpResponse('''<script>alert('invalid');window.location='/MyApp/admin_change_password/'</script>''')
    else:
        return HttpResponse('''<script>alert('invalid current password');window.location='/MyApp/admin_change_password/'</script>''')



def edit_department(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Department.objects.get(id=id)
        return render(request,'admin/edit department.html',{'data':obj})
def edit_department_post(request):
    DepartmentName=request.POST['textfield']
    id=request.POST['id']
    obj = Department.objects.get(id=id)
    obj.DepartmentName = DepartmentName
    obj.save()
    return HttpResponse('''<script>alert('changed');window.location='/MyApp/view_department/'</script>''')

def delete_dept(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj=Department.objects.filter(id=id).delete()
        return redirect('/MyApp/view_department/')


def edit_hod(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj=Hod.objects.get(id=id)
        res=Department.objects.all()
        res2=Staff.objects.all()
        return render(request,'admin/edit hod.html',{'data':obj,'data1':res,'data2':res2})
def edit_hod_post(request):
    Staff=request.POST['select']
    Department=request.POST['select2']
    id=request.POST['id']
    obj = Hod.objects.get(id=id)
    obj.STAFF_id = Staff
    obj.DEPARTMENT_id = Department
    obj.Date = datetime.date.today()
    obj.save()
    return HttpResponse('''<script>alert('changed');window.location='/MyApp/view_hod/'</script>''')

def delete_hod(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj=Hod.objects.get(id=id).delete()
        return redirect('/MyApp/view_hod/')


def edit_staff(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Staff.objects.get(id=id)
        obj1=Department.objects.all()
        return render(request,'admin/edit staff.html',{'data':obj,'data1':obj1})
def edit_staff_post(request):
    id=request.POST['id']
    Name = request.POST['textfield']
    Age = request.POST['textfield2']
    Gender = request.POST['RadioGroup1']
    Place = request.POST['textfield3']
    Post = request.POST['textfield4']
    District = request.POST['textfield5']
    State = request.POST['textfield6']
    email = request.POST['textfield7']
    Phone = request.POST['textfield8']

    Department = request.POST['select']
    obj = Staff.objects.get(id=id)
    if 'fileField' in request.FILES:
        Photo = request.FILES['fileField']
        if Photo !="":
            from datetime import datetime
            date = datetime.now().strftime("%Y%m%d%H%M%S") + ".jpg"
            fs = FileSystemStorage()
            b = fs.save(date, Photo)
            path = fs.url(date)
            obj.Photo = path

    obj.Name = Name
    obj.Age = Age
    obj.Gender = Gender
    obj.Place = Place
    obj.Post = Post
    obj.District = District
    obj.State = State
    obj.Email = email
    obj.Phone = Phone
    obj.DEPARTMENT_id = Department
    obj.save()
    return HttpResponse('''<script>alert('changed');window.location='/MyApp/view_staff/'</script>''')

def delete_staff(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj=Staff.objects.filter(id=id).delete()
        return redirect('/MyApp/view_staff/')

def new_requests(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Staff.objects.filter(LOGIN__Type='pending')
        return render(request, 'admin/new requests.html', {'data': obj})
def new_requests_post(request):
    search=request.POST['textfield']
    obj=Staff.objects.filter(LOGIN__Type='pending',Name__icontains=search)|Staff.objects.filter(DEPARTMENT__DepartmentName__icontains=search)
    return render(request,'admin/new requests.html',{'data':obj})

def approve_staff(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        Login.objects.filter(id=id).update(Type='staff')
        obj = Staff.objects.filter(LOGIN=id).update(Status='approved')
        return HttpResponse('''<script>alert('Approved');window.location='/MyApp/new_requests/'</script>''')

def reject_staff(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        Login.objects.filter(id=id).update(Type='rejected')
        obj = Staff.objects.filter(LOGIN=id).update(Status='rejected')
        return HttpResponse('''<script>alert('Rejected');window.location='/MyApp/new_requests/'</script>''')


def rejected_req(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Staff.objects.filter(LOGIN__Type='rejected')
        return render(request, 'admin/rejected staff.html', {'data': obj})
def rejected_req_post(request):
    search=request.POST['textfield']
    obj=Staff.objects.filter(LOGIN__Type='rejected',Name__icontains=search)|Staff.objects.filter(DEPARTMENT__DepartmentName__icontains=search)
    return render(request,'admin/rejected staff.html',{'data':obj})

def view_approved_requests(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Leave.objects.filter(Status='approved')
        l = []
        for i in obj:
            name = ''
            if i.LOGIN.Type == 'staff':
                name = Staff.objects.get(LOGIN_id=i.LOGIN.id)
            elif i.LOGIN.Type == 'hod':
                name = Staff.objects.get(LOGIN_id=i.LOGIN.id)
            l.append({"name": name.Name, "id": i.id, "Date": i.Date, "Status": i.Status, "Description": i.Description,
                      "FromDate": i.FromDate, "ToDate": i.ToDate, "LeaveType": i.LeaveType, 'Certificate':i.Certificate})
        return render(request, 'admin/view approved requests.html', {'data': l})


def view_approved_requests_post(request):
    From=request.POST['textfield']
    To=request.POST['textfield2']
    obj=Leave.objects.filter(Date__range=[From,To])
    l = []
    for i in obj:
        name = ''
        if i.LOGIN.Type == 'staff':
            name = Staff.objects.get(LOGIN_id=i.LOGIN.id)
        elif i.LOGIN.Type == 'hod':
            name = Staff.objects.get(LOGIN_id=i.LOGIN.id)
        l.append({"name": name.Name, "id": i.id, "Date": i.Date, "Status": i.Status, "Description": i.Description,
                  "FromDate": i.FromDate, "ToDate": i.ToDate, "LeaveType": i.LeaveType, 'Certificate':i.Certificate})
    return render(request,'admin/view approved requests.html',{'data':l})


def view_department(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj=Department.objects.filter()
        return render(request,'admin/view department.html',{'data':obj})
def view_department_post(request):
    search=request.POST['textfield']
    obj=Department.objects.filter(DepartmentName__icontains=search)
    return render(request,'admin/view department.html',{'data':obj})


def view_hod(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj=Hod.objects.filter()
        return render(request,'admin/view hod.html',{'data':obj})
def view_hod_post(request):
    search=request.POST['textfield']
    obj=Hod.objects.filter(DEPARTMENT__DepartmentName__icontains=search)
    return render(request,'admin/view hod.html',{'data':obj})


def view_leave_request(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Leave.objects.filter(Status='forwarded')
        l=[]
        for i in obj:
            name=''
            if i.LOGIN.Type=='staff':
                name=Staff.objects.get(LOGIN_id=i.LOGIN.id)
            elif i.LOGIN.Type=='hod':
                name=Staff.objects.get(LOGIN_id=i.LOGIN.id)
            l.append({"name":name.Name,"id":i.id,"Date":i.Date,"Status":i.Status,"Description":i.Description,"FromDate":i.FromDate,"ToDate":i.ToDate , "LeaveType": i.LeaveType,'Certificate':i.Certificate})
        return render(request,'admin/view leave request.html',{'data':l})
def view_leave_request_post(request):
    From = request.POST['textfield']
    To = request.POST['textfield2']
    obj = Leave.objects.filter(Date__year=To,Date__month=From,Status='forwarded')
    return render(request,'admin/view leave request.html',{'data':obj})

def admin_approve_request_post(request,id):
    obj=Leave.objects.filter(id=id).update(Status='approved')
    return HttpResponse('''<script>alert('leave request approved');window.location='/MyApp/view_leave_request/'</script>''')


def view_rejected_request(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Leave.objects.filter(Status='rejected')
        l = []
        for i in obj:
            name = ''
            if i.LOGIN.Type == 'staff':
                name = Staff.objects.get(LOGIN_id=i.LOGIN.id)
            elif i.LOGIN.Type == 'hod':
                name = Staff.objects.get(LOGIN_id=i.LOGIN.id)
            l.append({"name": name.Name, "id": i.id, "Date": i.Date, "Status": i.Status, "Description": i.Description,
                      "FromDate": i.FromDate, "ToDate": i.ToDate, "LeaveType": i.LeaveType, 'Certificate':i.Certificate})
        return render(request, 'admin/view rejected requests .html', {'data': l})
def view_rejected_request_post(request):
    From = request.POST['textfield']
    To = request.POST['textfield2']
    obj = Leave.objects.filter(Date__range=[From, To])
    l = []
    for i in obj:
        name = ''
        if i.LOGIN.Type == 'staff':
            name = Staff.objects.get(LOGIN_id=i.LOGIN.id)
        elif i.LOGIN.Type == 'hod':
            name = Staff.objects.get(LOGIN_id=i.LOGIN.id)
        l.append({"name": name.Name, "id": i.id, "Date": i.Date, "Status": i.Status, "Description": i.Description,
                  "FromDate": i.FromDate, "ToDate": i.ToDate, 'Certificate':i.Certificate})
    return render(request,'admin/view rejected requests .html',{'data':l})

def admin_reject_request_post(request,id):
    obj=Leave.objects.filter(id=id).update(Status='rejected')
    return HttpResponse('''<script>alert('leave request rejected');window.location='/MyApp/view_leave_request/'</script>''')


def view_service_details_of_other_staff(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Attendance.objects.all()
        dates = []
        for i in obj:
            if i.Date not in dates:
                dates.append(i.Date)

        res = Staff.objects.get(id=id)

        ls = []

        print(dates)
        m = []
        for j in dates:
            resa = Attendance.objects.filter(Date=j, STAFF=res)

            print(resa)

            if len(resa) == 0:
                m.append([j, "NA", "NA", "NA", "NA"])

            elif len(resa) == 1:
                m.append([j, resa[0].Time, "NA", "NA", "NA"])

            elif len(resa) == 2:
                m.append([j, resa[0].Time, resa[1].Time, "NA", "NA"])

            elif len(resa) == 3:
                m.append([j, resa[0].Time, resa[1].Time, resa[2].Time, "NA"])

            elif len(resa) >= 4:

                print(resa)
                m.append([j, resa[0].Time, resa[1].Time, resa[2].Time, resa[3].Time])

            ls.append(m)

        return render(request, 'admin/view service details of other staff.html', {'data': m})
def view_service_details_of_other_staff_post(request):
    # search=request.POST['textfield']
    # obj=Attendance.objects.filter()

    From = request.POST['textfield']
    To = request.POST['textfield2']
    obj = Attendance.objects.filter(Date__year=To, Date__month=From)





    return render(request,'admin/view service details of other staff.html',{'data':obj})


def attendance_date(request):
    return render(request,'admin/attendance date.html')

def attendance_date_post(request):
    search=request.POST['date']



    res = Staff.objects.all()

    # ls = []

    m = []
    for j in res:
        resa = Attendance.objects.filter(Date=search, STAFF=j)

        print(resa)

        if len(resa) == 0:
            m.append([j, "NA", "NA", "NA", "NA"])

        elif len(resa) == 1:
            m.append([j, resa[0].Time, "NA", "NA", "NA"])

        elif len(resa) == 2:
            m.append([j, resa[0].Time, resa[1].Time, "NA", "NA"])

        elif len(resa) == 3:
            m.append([j, resa[0].Time, resa[1].Time, resa[2].Time, "NA"])

        elif len(resa) >= 4:

            print(resa)
            m.append([j, resa[0].Time, resa[1].Time, resa[2].Time, resa[3].Time])

        # ls.append(m)
    # print(ls)
    return render(request, 'admin/attendance date.html', {'data': m})



def view_services(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Services.objects.filter(STAFF_id=id)
        return render(request, 'admin/view services.html',{'data': obj})
def view_services_post(request):
    search=request.POST['textfield']
    obj=Services.objects.filter()
    return render(request,'admin/view services.html',{'data':obj})



def view_staff(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Staff.objects.exclude(LOGIN__Type='admin').exclude(LOGIN__Type='rejected')
        return render(request, 'admin/view staff.html', {'data': obj})
def view_staff_post(request):
    search=request.POST['textfield']
    obj=Staff.objects.filter(LOGIN__Type='staff',Name__icontains=search)|Staff.objects.filter(DEPARTMENT__DepartmentName__icontains=search)
    return render(request,'admin/view staff.html',{'data':obj})



def view_attendance(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Attendance.objects.all()

        dates = []
        for i in obj:
            if i.Date not in dates:
                dates.append(i.Date)

        res = Staff.objects.get(LOGIN_id=request.session['lid'])

        ls = []

        m = []
        for j in dates:
            resa = Attendance.objects.filter(Date=j, STAFF=res)
            if len(resa) == 0:
                m.append([j, "NA", "NA", "NA", "NA"])

            elif len(resa) == 1:
                m.append([j, resa[0].Time, "NA", "NA", "NA"])

            elif len(resa) == 2:
                m.append([j, resa[0].Time, resa[1].Time, "NA", "NA"])

            elif len(resa) == 3:
                m.append([j, resa[0].Time, resa[1].Time, resa[2].Time, "NA"])

            elif len(resa) >= 4:

                print(resa)
                m.append([j, resa[0].Time, resa[1].Time, resa[2].Time, resa[3].Time])

            ls.append(m)

        return render(request, 'admin/view attendance.html', {'data': m})





def view_attendance_post(request):
    From = request.POST['textfield']
    To = request.POST['textfield2']
    obj = Attendance.objects.filter(Date__range=[From, To])
    return render(request, 'admin/view attendance.html', {'data': obj})




#Hod

def hod_change_password(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        if request.session['lid']=='':
            return redirect('/MyApp/login/')
        return render(request,'Hod/hod change password.html')

def hod_change_password_post(request):
    if request.session['lid']=='':
        return redirect('/Myapp/login/')
    old=request.POST['textfield']
    new=request.POST['textfield2']
    confirm=request.POST['textfield3']
    var = Login.objects.filter(Password=old)
    if var.exists():
        if new == confirm:
            var2 = Login.objects.filter(Password=old).update(Password=confirm)
            return HttpResponse('''<script>alert('success');window.location='/MyApp/login/'</script>''')
        else:
            return HttpResponse('''<script>alert('invalid');window.location='/MyApp/hod_change_password/'</script>''')

    else:
        return HttpResponse('''<script>alert('invalid current password');window.location='/MyApp/hod_change_password/'</script>''')


def hod_home(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        return render(request,'Hod/hodhomepageindex.html')


def edit_profile(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Staff.objects.get(LOGIN_id=request.session['lid'])
        obj2 = Department.objects.all()
        return render(request,'Hod/edit profile.html',{'data':obj,'data2':obj2,})
def edit_profile_post(request):
    Name=request.POST['textfield']
    Age=request.POST['textfield2']
    Gender=request.POST['RadioGroup1']
    Place=request.POST['textfield3']
    Post=request.POST['textfield4']
    District=request.POST['textfield5']
    State=request.POST['textfield6']
    email=request.POST['textfield7']
    Phone=request.POST['textfield8']
    Department=request.POST['select']
    id=request.POST['id']
    obj=Staff.objects.get(LOGIN_id=id)

    if 'fileField' in request.FILES:
        Photo=request.FILES['fileField']
        from datetime import datetime
        date=datetime.now().strftime("%Y%m%d%H%M%S")+".jpg"
        fs=FileSystemStorage()
        b=fs.save(date,Photo)
        path=fs.url(date)
        obj.Photo = path
        obj.save()

    l=Login.objects.get(id=id)
    l.Username=email
    l.save()

    obj.Name=Name
    obj.Age=Age
    obj.Gender=Gender
    obj.Place=Place
    obj.Post=Post
    obj.District=District
    obj.State=State
    obj.Email=email
    obj.Phone=Phone
    obj.DEPARTMENT_id=Department
    obj.save()
    return HttpResponse('''<script>alert('Profile Edited');window.location='/MyApp/view_profile/'</script>''')




def send_leave_request(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        return render(request,'Hod/send leave request.html')
def send_leave_request_post(request):
    Details=request.POST['textarea']
    frmdate=request.POST['frmdate']
    todate=request.POST['todate']
    leavetype=request.POST['leavetype']
    Certificate=request.FILES['certificate']
    obj=Leave()
    obj.LOGIN=Login.objects.get(id=request.session['lid'])
    from datetime import datetime
    if Certificate:  # Check if a file is uploaded
        date = datetime.now().strftime("%Y%m%d%H%M%S") + "_" + Certificate.name
        fs = FileSystemStorage()
        filename = fs.save(date, Certificate)
        path = fs.url(filename)

        # Save the data to the database
        obj = Leave(
            Date=datetime.now().date(),
            Description=Details,
            FromDate=frmdate,
            ToDate=todate,
            LeaveType=leavetype,
            Certificate=path,
            LOGIN_id=request.session['lid'],
            Status='forwarded'
        )
        obj.save()
    return HttpResponse('''<script>alert('leave request sent');window.location='/MyApp/send_leave_request/'</script>''')


def view_forwarded_leave_request(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Leave.objects.filter(Status='forwarded')
        l = []
        for i in obj:
            name = ''
            if i.LOGIN.Type == 'staff':
                name = Staff.objects.get(LOGIN_id=i.LOGIN.id)
            elif i.LOGIN.Type == 'hod':
                name = Staff.objects.get(LOGIN_id=i.LOGIN.id)
            l.append({"name": name.Name, "id": i.id, "Date": i.Date, "Status": i.Status, "Description": i.Description,
                      "FromDate": i.FromDate, "ToDate": i.ToDate, "LeaveType": i.LeaveType, 'Certificate':i.Certificate})
        return render(request, 'Hod/view forwarded leave request.html', {'data': l})


def view_forwarded_leave_request_post(request):
    From = request.POST['textfield']
    To = request.POST['textfield2']
    obj = Leave.objects.filter(Date__range=[From, To])
    return render(request, 'Hod/view forwarded leave request.html', {'data': obj})

def view_leave_request_and_forward_to_principal(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Leave.objects.filter(Status="forwarded")
        return render(request, 'Hod/view my leave request status.html', {'data': obj})
def view_leave_request_and_forward_to_principal_post(request):
    From = request.POST['textfield']
    To = request.POST['textfield2']
    obj = Leave.objects.filter(Date__range=[From, To])
    return render(request, 'Hod/view my leave request status.html', {'data': obj})


def hod_view_leave_request(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:

        h = Hod.objects.get(STAFF__LOGIN_id=request.session['lid']).DEPARTMENT.id
        # obj2 = Staff.objects.filter(DEPARTMENT_id=h).exclude(LOGIN_id=request.session['lid'])

        # obj = Leave.objects.filter(Status='pending').exclude(LOGIN_id=obj2.LOGIN_id)

        obj = Leave.objects.filter(Status='pending').exclude(LOGIN_id=request.session['lid'])

        l = []
        for i in obj:
            name = ''
            if i.LOGIN.Type == 'staff':
                name = Staff.objects.get(LOGIN_id=i.LOGIN.id)
                h = Hod.objects.get(STAFF__LOGIN_id=request.session['lid']).DEPARTMENT.id
                if h == Staff.objects.get(LOGIN=i.LOGIN).DEPARTMENT_id:
                    l.append({"name": name.Name, "id": i.id, "Date": i.Date, "Status": i.Status, "Description": i.Description,
                      "FromDate": i.FromDate, "ToDate": i.ToDate, "LeaveType": i.LeaveType, 'Certificate':i.Certificate})
            elif i.LOGIN.Type == 'hod':
                name = Staff.objects.get(LOGIN_id=i.LOGIN.id)
                if h == Staff.objects.get(LOGIN=i.LOGIN).DEPARTMENT_id:

                    l.append({"name": name.Name, "id": i.id, "Date": i.Date, "Status": i.Status, "Description": i.Description,
                              "FromDate": i.FromDate, "ToDate": i.ToDate , "LeaveType": i.LeaveType, 'Certificate':i.Certificate})
        return render(request, 'Hod/hod view leave request.html', {'data': l})


def hod_view_leave_request_post(request):
    From = request.POST['textfield']
    To = request.POST['textfield2']
    obj = Leave.objects.filter(Date__range=[From, To])
    return render(request, 'Hod/hod view leave request.html', {'data': obj})

def approve_request_post(request,id):
    obj=Leave.objects.filter(id=id).update(Status='forwarded')
    return HttpResponse('''<script>alert('leave request approved');window.location='/MyApp/hod_view_leave_request/'</script>''')

def reject_request_post(request,id):
    obj=Leave.objects.filter(id=id).update(Status='rejected')
    return HttpResponse('''<script>alert('leave request rejected');window.location='/MyApp/hod_view_leave_request/'</script>''')

def view_profile(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj=Staff.objects.get(LOGIN_id=request.session['lid'])
        return render(request,'Hod/view profile.html',{'data':obj})


def hod_view_service_details_of_other_staff(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Attendance.objects.filter(STAFF_id=id)
        dates = []
        for i in obj:
            if i.Date not in dates:
                dates.append(i.Date)

        res = Staff.objects.get(LOGIN_id=request.session['lid'])

        ls = []

        m = []
        for j in dates:
            resa = Attendance.objects.filter(Date=j, STAFF=res)
            if len(resa) == 0:
                m.append([j, "NA", "NA", "NA", "NA"])

            elif len(resa) == 1:
                m.append([j, resa[0].Time, "NA", "NA", "NA"])

            elif len(resa) == 2:
                m.append([j, resa[0].Time, resa[1].Time, "NA", "NA"])

            elif len(resa) == 3:
                m.append([j, resa[0].Time, resa[1].Time, resa[2].Time, "NA"])

            elif len(resa) >= 4:

                print(resa)
                m.append([j, resa[0].Time, resa[1].Time, resa[2].Time, resa[3].Time])

            ls.append(m)
        return render(request, 'Hod/hod view service details of other staff.html', {'data': m})
def hod_view_service_details_of_other_staff_post(request):
    search=request.POST['textfield']
    obj=Attendance.objects.filter()
    return render(request,'Hod/hod view service details of other staff.html',{'data':obj})


def view_service_details(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj=Attendance.objects.all()

        dates = []
        for i in obj:
            if i.Date not in dates:
                dates.append(i.Date)

        res = Staff.objects.get(LOGIN_id=request.session['lid'])

        ls = []


        m = []
        for j in dates:
            resa = Attendance.objects.filter(Date=j,STAFF=res)
            if len(resa) == 0:
                m.append([j,"NA","NA","NA","NA"])

            elif len(resa) == 1:
                m.append([j,resa[0].Time,"NA","NA","NA"])

            elif len(resa) == 2:
                m.append([j,resa[0].Time,resa[1].Time,"NA","NA"])

            elif len(resa) == 3:
                m.append([j,resa[0].Time,resa[1].Time,resa[2].Time,"NA"])

            elif len(resa)>=4:

                print(resa)
                m.append([j,resa[0].Time,resa[1].Time,resa[2].Time,resa[3].Time])

            ls.append(m)

        return render(request, 'Hod/view service details.html', {'data': m})


def view_service_details_post(request):

    From = request.POST['textfield']
    To = request.POST['textfield2']
    obj = Attendance.objects.filter(Date__year=To,Date__month=From)
    # obj = Attendance.objects.filter(Date__range=[From, To])


    dates = []
    for i in obj:
        if i.Date not in dates:
            dates.append(i.Date)

    res = Staff.objects.get(LOGIN_id=request.session['lid'])

    ls = []

    m = []
    for j in dates:
        resa = Attendance.objects.filter(Date=j, STAFF=res)
        if len(resa) == 0:
            m.append([j, "NA", "NA", "NA", "NA"])

        elif len(resa) == 1:
            m.append([j, resa[0].Time, "NA", "NA", "NA"])

        elif len(resa) == 2:
            m.append([j, resa[0].Time, resa[1].Time, "NA", "NA"])

        elif len(resa) == 3:
            m.append([j, resa[0].Time, resa[1].Time, resa[2].Time, "NA"])

        elif len(resa) >= 4:

            print(resa)
            m.append([j, resa[0].Time, resa[1].Time, resa[2].Time, resa[3].Time])

        ls.append(m)

    return render(request, 'Hod/view service details.html', {'data': m})


def hod_view_staff(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        h=Hod.objects.get(STAFF__LOGIN_id=request.session['lid']).DEPARTMENT.id
        obj = Staff.objects.filter(DEPARTMENT_id=h).exclude(LOGIN_id=request.session['lid'])
        return render(request, 'Hod/hod view staff.html', {'data': obj})


def hod_view_services(request,id):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Services.objects.filter(STAFF_id=id)
        return render(request, 'Hod/hod view services.html',{'data': obj})
def hod_view_services_post(request):
    search=request.POST['textfield']
    obj=Services.objects.filter()
    return render(request,'Hod/hod view services.html',{'data':obj})


def hod_view_my_leave_request_status(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Leave.objects.filter(LOGIN_id=request.session['lid'])
        return render(request, 'Hod/view my leave request status.html', {'data':obj})

def hod_view_my_leave_request_status_post(request):
    From = request.POST['textfield']
    To = request.POST['textfield2']
    obj = Leave.objects.filter(Date__range=[From, To])
    return render(request, 'Hod/view my leave request status.html', {'data': obj})





def hod_view_staff_post(request):
    search=request.POST['textfield']
    obj=Staff.objects.filter(DEPARTMENT__DepartmentName__icontains=search)
    return render(request,'Hod/hod view staff.html',{'data':obj})

def hod_edit_staff(request,id):
    obj = Staff.objects.get(id=id)
    obj1=Department.objects.all()
    return render(request,'hod/hod edit staff.html',{'data':obj,'data1':obj1})
def hod_edit_staff_post(request):
    id=request.POST['id']
    Name = request.POST['textfield']
    Age = request.POST['textfield2']
    Gender = request.POST['RadioGroup1']
    Place = request.POST['textfield3']
    Post = request.POST['textfield4']
    District = request.POST['textfield5']
    State = request.POST['textfield6']
    email = request.POST['textfield7']
    Phone = request.POST['textfield8']

    Department = request.POST['select']
    obj = Staff.objects.get(id=id)
    if 'fileField' in request.FILES:
        Photo = request.FILES['fileField']
        if Photo !="":
            from datetime import datetime
            date = datetime.now().strftime("%Y%m%d%H%M%S") + ".jpg"
            fs = FileSystemStorage()
            b = fs.save(date, Photo)
            path = fs.url(date)
            obj.Photo = path

    obj.Name = Name
    obj.Age = Age
    obj.Gender = Gender
    obj.Place = Place
    obj.Post = Post
    obj.District = District
    obj.State = State
    obj.Email = email
    obj.Phone = Phone
    obj.DEPARTMENT_id = Department
    obj.save()
    return HttpResponse('''<script>alert('changed');window.location='/MyApp/hod_view_staff/'</script>''')

def hod_delete_staff(request,id):
    obj=Staff.objects.filter(id=id).delete()
    return redirect('/MyApp/hod_view_staff/')



def hod_add_services(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        return render(request, 'Hod/add services.html')

# def hod_add_services_post(request):
#     ServiceName=request.POST['textfield']
#     FromDate=request.POST['frmdate']
#     ToDate=request.POST['todate']
#     Duration=request.POST['textfield3']
#     Certificate=request.FILES['certificate']
#     from datetime import datetime
#     date = datetime.now().strftime("%Y%m%d%H%M%S") + ".pdf"
#     fs = FileSystemStorage()
#     b = fs.save(date, Certificate)
#     path = fs.url(date)
#     obj=Services()
#     obj.ServiceName=ServiceName
#     obj.FromDate=FromDate
#     obj.ToDate=ToDate
#     obj.Duration=Duration
#     obj.Certificate=path
#     obj.STAFF=Staff.objects.get(LOGIN=request.session['lid'])
#     obj.save()
#     return HttpResponse('''<script>alert('Service added');window.location='/MyApp/hod_home/'</script>''')
from django.http import HttpResponse
from django.core.files.storage import FileSystemStorage
from datetime import datetime
from .models import Services, Staff

def hod_add_services_post(request):
    # if request.method == 'POST':
        ServiceName = request.POST.get('textfield')
        FromDate = request.POST.get('frmdate')
        ToDate = request.POST.get('todate')
        Duration = request.POST.get('textfield3')
        Certificate = request.FILES.get('certificate')
        from datetime import datetime
        if Certificate:  # Check if a file is uploaded
            date = datetime.now().strftime("%Y%m%d%H%M%S") + "_" + Certificate.name
            fs = FileSystemStorage()
            filename = fs.save(date, Certificate)
            path = fs.url(filename)

            # Save the data to the database
            obj = Services(
                ServiceName=ServiceName,
                FromDate=FromDate,
                ToDate=ToDate,
                Duration=Duration,
                Certificate=path,
                STAFF=Staff.objects.get(LOGIN=request.session['lid'])
            )
            obj.save()

            return HttpResponse('''<script>alert('Service added');window.location='/MyApp/hod_home/'</script>''')
        else:
            return HttpResponse("Certificate file is required.")
    # else:
    #     return HttpResponse("Invalid request method.")


def hod_view_my_services(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('login required');window.location='/MyApp/login/'</script>''')
    else:
        obj = Services.objects.filter(STAFF__LOGIN_id=request.session['lid'])
        return render(request, 'Hod/view my services.html',{'data': obj})
def hod_view_my_services_post(request):
    search=request.POST['textfield']
    obj=Services.objects.filter()
    return render(request,'Hod/view my services.html',{'data':obj})






def staff_login(request):
    name=request.POST['name']
    password=request.POST['password']
    log=Login.objects.filter(Username=name,Password=password)
    if log.exists():
        log1=Login.objects.get(Username=name,Password=password)
        lid=log1.id
        if log1.Type=='staff':
            return JsonResponse({'status':'ok','lid':str(lid),'type':log1.Type})
        else :
            return JsonResponse({'status':'no'})
    else:
        return JsonResponse({'status':'no'})




def staff_loginnew(request):
    name=request.POST['username']
    password=request.POST['password']
    log=Login.objects.filter(Username=name,Password=password)
    if log.exists():
        log1=Login.objects.get(Username=name,Password=password)
        lid=log1.id

        m="done"
        chk=Attendance.objects.filter(STAFF__LOGIN_id=lid,Attendance='check in',Date=datetime.datetime.now())
        if chk.exists():
            m="do"






        return JsonResponse({'status':'ok','lid':log1.id,'type':log1.Type,'s':m})
    else:
        return JsonResponse({'status':'no'})


def and_Checkin(request):
    lid= request.POST["lid"]

    Attendance.objects.filter(Date=datetime.datetime.now(),Attendance='check in').update(Attendance="Done")

    return JsonResponse({
        'status':'ok'
    })


def staff_view_profile(request):
    lid=request.POST['lid']
    r=Staff.objects.get(LOGIN_id=lid)
    return JsonResponse({'status':'ok',"Name":r.Name,"Age":r.Age,"Gender":r.Gender,"Place":r.Place,"Post":r.Post,
                         "District":r.District,"State":r.State,"Email":r.Email,"Phone":r.Phone,"Photo":r.Photo,"DEPARTMENT":r.DEPARTMENT.DepartmentName})

def view_dept_staff(request):
    lid=request.POST['lid']
    d=Staff.objects.get(LOGIN_id=lid).DEPARTMENT.id
    res=Staff.objects.filter(DEPARTMENT_id=d)
    l=[]
    for i in res:
        l.append({"id":i.id,"Name":i.Name,"Age":i.Age,"Gender":i.Gender,"Place":i.Place,"Post":i.Post,"District":i.District,
                  "State":i.State,"Email":i.Email,"Phone":i.Phone,"Photo":i.Photo,"DEPARTMENT":i.DEPARTMENT.DepartmentName})
    return JsonResponse({'status':'ok',"data":l})

def staff_send_leave_req(request):
    lid=request.POST['lid']
    photo=request.POST['photo']
    description=request.POST['leavereq']
    frmdate = request.POST['frmdate']
    todate = request.POST['todate']
    leavetype = request.POST['leavetype']

    import datetime, base64
    dt = datetime.datetime.now().strftime('%Y%m%d%H%M%S')+'.jpg'
    a = base64.b64decode(photo)
    open(settings.MEDIA_ROOT+'\\'+dt, 'wb').write(a)
    lobj=Leave()
    lobj.Status='pending'
    lobj.Date=datetime.datetime.now().date()
    lobj.FromDate=frmdate
    lobj.ToDate=todate
    lobj.LeaveType=leavetype
    lobj.Certificate='/media/'+dt
    lobj.LOGIN_id=lid
    lobj.Description=description
    lobj.save()

    return JsonResponse({'status':'ok'})

def staff_view_leave_req_status(request):
    lid=request.POST['lid']
    res=Leave.objects.filter(LOGIN_id=lid)
    l=[]
    for i in res:
        l.append({"id":i.id,"Date":i.Date,"Description":i.Description,"Status":i.Status,"certificate":i.Certificate})
    return JsonResponse({'status':'ok',"data":l})

def staff_attendance_history(request):
    lid=request.POST['lid']
    obj = Attendance.objects.filter(STAFF__LOGIN_id=lid)
    dates = []
    for i in obj:
        if i.Date not in dates:
            dates.append(i.Date)

    res = Staff.objects.get(LOGIN_id=lid)

    ls = []

    m = []
    for j in dates:
        resa = Attendance.objects.filter(Date=j, STAFF=res)
        if len(resa) == 0:
            m.append([j, "NA", "NA", "NA", "NA"])

        elif len(resa) == 1:
            m.append([j, resa[0].Time, "NA", "NA", "NA"])

        elif len(resa) == 2:
            m.append([j, resa[0].Time, resa[1].Time, "NA", "NA"])

        elif len(resa) == 3:
            m.append([j, resa[0].Time, resa[1].Time, resa[2].Time, "NA"])

        elif len(resa) >= 4:

            print(resa)
            m.append([j, resa[0].Time, resa[1].Time, resa[2].Time, resa[3].Time])

        if m in ls:
            continue
        ls.append(m)
    print(ls)
    # res=Attendance.objects.filter(STAFF__LOGIN_id=lid)
    # l=[]
    # for i in res:
    #     l.append({"id":i.id,"Date":i.Date,"Attendance":i.Attendance,"Time":i.Time})
    return JsonResponse({'status':'ok',"data":ls})

def staff_change_pswd(request):
    old = request.POST['oldpassword']
    new = request.POST['newpassword']
    confirm = request.POST['cnfmpassword']
    lid = request.POST['lid']

    var = Login.objects.get(id=lid)
    if var.Password==old:
        if new == confirm:
            var2 = Login.objects.filter(id=lid).update(Password=confirm)
            return JsonResponse({'status': 'ok'})
        else:
            return JsonResponse({'status': 'ano'})
    else:
        return JsonResponse({'status':'no'})
def View_stud_dep(request):
    sf=Department.objects.all()
    l=[]
    for i in sf:
        l.append({'id': i.id, 'dep_name': i.DepartmentName})
    return JsonResponse({'status':'ok','data':l})
def new_register(request):
    Name = request.POST['name']
    Age = request.POST['age']
    Gender = request.POST['gender']
    Place = request.POST['place']
    Post = request.POST['post']
    District = request.POST['district']
    State = request.POST['state']
    email = request.POST['email']
    Phone = request.POST['phone']
    Photo = request.POST['photo']
    department = request.POST['department']
    dp=Department.objects.get(id=department)
    password=request.POST['password']
    confirmpassword=request.POST['cnfrmpassword']
    lobj=Login()
    lobj.Username=email
    lobj.Password=password
    lobj.Type='pending'
    lobj.save()
    import datetime
    import base64

    date = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    a=base64.b64decode(Photo)
    fh = open("C:\\Users\\saran\\PycharmProjects\\Staff_management\\media\\Staff\\" + date + ".jpg", "wb")

    path = "/media/Staff/" + date + ".jpg"
    fh.write(a)
    fh.close()
    if password == confirmpassword:
        obj=Staff()
        obj.LOGIN=lobj

        obj.Name=Name
        obj.Age=Age
        obj.Gender=Gender
        obj.Place=Place
        obj.Post=Post
        obj.District=District
        obj.State=State
        obj.Email=email
        obj.Phone=Phone
        obj.Photo=path
        obj.Status='pending'
        obj.DEPARTMENT=dp
        obj.save()
        return JsonResponse({'status': 'ok'})
    return JsonResponse({'status': 'no'})


def staff_edit_profile(request):
    lid=request.POST['lid']
    Name = request.POST['name']
    Age = request.POST['age']
    Gender = request.POST['gender']
    Place = request.POST['place']
    Post = request.POST['post']
    District = request.POST['district']
    State = request.POST['state']
    email = request.POST['email']
    Phone = request.POST['phone']
    Photo = request.POST['photo']
    department = request.POST['department']
    dp = Department.objects.get(id=department)
    lobj = Login.objects.get(id=lid)
    lobj.Username = email
    lobj.save()

    obj = Staff.objects.get(LOGIN_id=lid)

    if len(Photo)>0:
        import datetime
        import base64
        date = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
        a = base64.b64decode(Photo)
        fh = open("C:\\Users\\saran\\PycharmProjects\\Staff_management\\media\\Staff\\" + date + ".jpg", "wb")
        path = "/media/Staff/" + date + ".jpg"
        fh.write(a)
        fh.close()
        obj.Photo = path

    obj.Name = Name
    obj.Age = Age
    obj.Gender = Gender
    obj.Place = Place
    obj.Post = Post
    obj.District = District
    obj.State = State
    obj.Email = email
    obj.Phone = Phone
    obj.DEPARTMENT = dp
    obj.save()

    return JsonResponse({'status': 'ok'})
    # return JsonResponse({'status': 'no'})


def add_services(request):
    lid=request.POST['lid']
    servicename=request.POST['servicename']
    fromdate=request.POST['fromdate']
    todate=request.POST['todate']
    duration=request.POST['duration']
    certificate=request.POST['certificate']
    import base64, datetime
    a = base64.b64decode(certificate)
    dt = datetime.datetime.now().strftime('%Y%m%d%H%M%S%f')+'.jpg'
    open(r'C:\Users\saran\PycharmProjects\Staff_management\media\certs\\'+dt, 'wb').write(a)
    print(certificate,"jjjjjjjjjjjjj")
    obj=Services()
    obj.STAFF=Staff.objects.get(LOGIN_id=lid)
    obj.ServiceName=servicename
    obj.FromDate=fromdate
    obj.ToDate=todate
    obj.Duration=duration
    obj.Certificate='/media/certs/'+dt
    obj.save()
    return JsonResponse({'status':'ok'})


def staff_view_services(request):
    lid=request.POST['lid']
    print('lid',lid)
    l=[]
    res=Services.objects.filter(STAFF__LOGIN_id=lid)
    for i in res:
            l.append({'id':i.id,'servicename':i.ServiceName,'fromdate':i.FromDate,'todate':i.ToDate,'duration':i.Duration, 'certificate':i.Certificate})
    return JsonResponse({'status':'ok','data':l})


def forget_password_post(request):
    em = request.POST['em_add']
    import random
    password = random.randint(00000000, 99999999)
    log = Login.objects.filter(Username=em)
    if log.exists():
        logg = Login.objects.get(Username=em)
        message = 'temporary password is ' + str(password)
        send_mail(
            'temp password',
            message,
            settings.EMAIL_HOST_USER,
            [em, ],
            fail_silently=False
        )
        logg.Password = password
        logg.save()
        return JsonResponse({'status': 'ok'})
    else:
        return JsonResponse({'status': 'no'})


def calculate_time_difference(staff_id, year, month):
    from django.http import JsonResponse
    from django.db.models import Q
    from datetime import datetime
    # Define the time format expected in the 'Time' field
    time_format = '%H:%M:%S'
    morning_cutoff = datetime.strptime('14:00:00', time_format)
    morning_comparison_time = datetime.strptime('09:00:00', time_format)
    afternoon_comparison_time = datetime.strptime('14:00:00', time_format)

    # Get the start and end dates of the month
    start_date = datetime(year, month, 1)
    end_date = datetime(year, month + 1, 1) if month < 12 else datetime(year + 1, 1, 1)

    # Filter records for the specified staff and date range
    attendance_records = Attendance.objects.filter(
        STAFF_id=staff_id,
        Date__range=[start_date, end_date],
        Attendance__icontains='Checkin'  # Assuming 'Checkin' is part of the Attendance field for check-ins
    ).order_by('Date', 'Time')

    # Initialize variables to calculate total minutes difference
    total_difference_minutes = 0
    last_processed_date = None
    morning_checkin_processed = False
    afternoon_checkin_processed = False

    # Iterate through sorted attendance records
    for record in attendance_records:
        current_date = record.Date
        checkin_time = datetime.strptime(record.Time, time_format)

        # Reset daily checkin processing if it's a new day
        if current_date != last_processed_date:
            morning_checkin_processed = False
            afternoon_checkin_processed = False
            last_processed_date = current_date

        # Process morning checkin if not already done
        if not morning_checkin_processed and checkin_time < morning_cutoff:
            time_difference = morning_comparison_time - checkin_time if checkin_time < morning_comparison_time else checkin_time - morning_comparison_time
            total_difference_minutes += time_difference.total_seconds() / 60
            morning_checkin_processed = True
        # Process afternoon checkin if not already done
        elif not afternoon_checkin_processed and checkin_time >= morning_cutoff:
            time_difference = afternoon_comparison_time - checkin_time if checkin_time < afternoon_comparison_time else checkin_time - afternoon_comparison_time
            total_difference_minutes += time_difference.total_seconds() / 60
            afternoon_checkin_processed = True
    print(total_difference_minutes)

    if total_difference_minutes > 60:
        insert_leave_record(last_processed_date, staff_id, 'Casual Leave', total_difference_minutes)

    return JsonResponse({'message': 'Attendance processed and leave records updated if necessary'})


def insert_leave_record(date, staff_id, leave_type, total_difference_minutes):
    # Here you would implement logic to insert a leave record
    login_instance = Login.objects.get(staff__id=staff_id)  # Assumption: Login model is linked to Staff
    import datetime
    date = datetime.date.today()
    print(date)
    if not Leave.objects.filter(LOGIN=login_instance, Date=date).exists():

        Leave.objects.create(
            Date=date,
            FromDate=date,
            ToDate=date,
            Status='approved',
            LOGIN=login_instance,
            Description=f"Late {total_difference_minutes} minutes.",
            LeaveType=leave_type,
            Certificate='No Certificate'
        )

def run_background_task():
    while True:
        import datetime
        m = datetime.date.today().month
        d = datetime.date.today().day
        y = datetime.date.today().year
        print(m, d)
        calculate_time_difference(1, y, m)
        # calculate_time_difference(1, 2024, 4)
        sleep(5)


def start_background_task():
    background_thread = threading.Thread(target=run_background_task)
    background_thread.start()
    return 0
start_background_task()