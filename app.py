from flask import Flask
import json

app = Flask(__name__)

with open("tests/courses.json", "r") as courses:
    courses_json = json.load(courses)

@app.route("/")
def hello_world():
    return "<h1>hello world<h1/>"

@app.route("/courses")
def hello_courses():
    return courses_json
