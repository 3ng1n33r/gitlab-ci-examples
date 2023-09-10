from flask import Flask, render_template, request, make_response
import sqlite3

DBFILE = "aircraft.db"

app = Flask(__name__)

def queryfromdb(select,query):
  conn = sqlite3.connect(DBFILE)
  cursor = conn.cursor()
  cursor.execute("SELECT * FROM aircraftdb WHERE (%s) LIKE (?) LIMIT 25" % (select), (query+"%",))
  results = cursor.fetchall()
  conn.close()
  return results

@app.route('/', methods=["GET"])
def _get_():
  return render_template('index.html')

@app.route('/', methods=["POST"])
def _post_():
  if request.method == "POST":
     select = request.form['select']
     query = request.form['query']
     acdata = queryfromdb(select,query)
  else:
     acdata = []
  return render_template('result.html', q=acdata)

if __name__ == ' __main__ ':
  app.run(host='0.0.0.0', port='5000')