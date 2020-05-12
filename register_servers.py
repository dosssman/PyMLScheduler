import yaml
from pymongo import MongoClient
from pprint import pprint

# TODO: Add the serverlist file as an argument of the script instead.

# Connecting to the databaste
client = MongoClient("mongodb://127.0.0.1:27017", username="PyMLSchedulerUser", password="changeme", authSource="PyMLSchedulerDB")

with open("serverlist.yml") as ymlfile:
    # TODO: How to read it as a dictonary insread of simple list ?
    serverlist = yaml.load(ymlfile,Loader=yaml.FullLoader)

db = client["PyMLSchedulerDB"]
servers = db["servers"]

# print(serverlist)

# TODO: Override the default _id with the server name to block duplicates
for servername, serverinfo in serverlist.items():
    # Checking if already in database 
    look_up_query = {"hostname": serverinfo["hostname"]}
    serverfound = servers.count_documents(look_up_query)
    if serverfound:
        servers.update_one(
           look_up_query, { "$set": serverinfo}
        )
    else:
        servers.insert_one(serverinfo)
