# Generated by Django 3.2.22 on 2024-04-19 04:27

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('MyApp', '0003_remove_leave_hod'),
    ]

    operations = [
        migrations.AddField(
            model_name='services',
            name='Certificate',
            field=models.CharField(default=1, max_length=100),
            preserve_default=False,
        ),
    ]
