# Generated by Django 3.2.22 on 2024-04-22 03:34

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('MyApp', '0005_leave_certificate'),
    ]

    operations = [
        migrations.AlterField(
            model_name='leave',
            name='Certificate',
            field=models.CharField(max_length=200),
        ),
    ]
