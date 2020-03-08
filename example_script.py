import os
from os import listdir
from os.path import isfile, join
import subprocess

def runthis(type__):
    onlyfiles = [f for f in listdir(type__["name"]) if isfile(join(type__["name"], f))]
    for file in onlyfiles:
        subprocess.call([
                os.getcwd() + "//iso_generator.exe", 
                os.getcwd() + "//" + type__["name"] + "//" + file,
                os.getcwd() + "//" + type__["name"] + ".png",
                os.getcwd() + "//" + type__["name"] + ".png",
                "#ffffff", 
                "#ffffff", 
                "#ffffff",
                "32",
                str(type__["height"]),
                "1",
                "0",
                os.getcwd() + "//" + type__["name"] + "//" + type__["name"] + ".iso//" + file
            ])

types = [
    {
        "name" : "dirt",
        "height" : 0.75
    },
    {
        "name" : "grass",
        "height" : 1.0
    },
    {
        "name" : "forest",
        "height" : 1.0
    },
    {
        "name" : "water",
        "height" : 0.5
    }
]

for type_ in types:
    runthis(type_)
    pass