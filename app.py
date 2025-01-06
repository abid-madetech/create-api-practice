from flask import Flask, jsonify, request
import json
from tests import courses

app = Flask(__name__)

# with open("tests/courses.json", "r") as courses:
    # courses_json = json.load(courses)

courses = courses.courses
@app.get("/")
def hello_world():
    return "<h1>hello world<h1/>"

@app.get("/courses")
def hello_courses():
    return jsonify(courses), 200

@app.post("/courses")
def add_course():
    data = request.json
    courses.append(data)
    return jsonify(data), 201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)