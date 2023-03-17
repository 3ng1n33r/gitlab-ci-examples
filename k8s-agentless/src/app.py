from flask import Flask, render_template, request, make_response
import sqlite3

DBFILE = "aircraft.db"

app = Flask(__name__)

def queryfromdb(search):
  conn = sqlite3.connect(DBFILE)
  cursor = conn.cursor()
  cursor.execute("SELECT * FROM `aircraftdb` WHERE `icao` LIKE ? OR `reg` LIKE ?", [search+"%", search+"%"])
  results = cursor.fetchall()
  conn.close()
  return results

@app.route('/', methods=["GET"])
def _get_():
  return render_template('index.html')

@app.route('/', methods=["POST"])
def _post_():
  if request.method == "POST":
     req = dict(request.form)
     acdata = queryfromdb(req["search"])
  else:
     acdata = []
  return render_template('result.html', q=acdata)

if __name__ == ' __main__ ':
  app.run(host='0.0.0.0', port='5000')