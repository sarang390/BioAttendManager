# Generated by Django 3.2.22 on 2024-04-19 05:20

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('MyApp', '0004_services_certificate'),
    ]

    operations = [
        migrations.AddField(
            model_name='leave',
            name='Certificate',
            field=models.CharField(default=1, max_length=100),
            preserve_default=False,
        ),
    ]
