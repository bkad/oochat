import pymongo
from flask import Blueprint, g, render_template
import time
from random import shuffle

frontend = Blueprint("frontend", __name__)

@frontend.route('/')
def index():
  messages = g.events.find().sort("$natural", pymongo.DESCENDING).limit(100)
  # maybe use backchat, flexjaxlot (it lines it up nicely)
  name_jumble = ["back", "flex", "jax", "chat", "lot"]
  shuffle(name_jumble)
  title = "".join(name_jumble)
  return render_template('index.htmljinja', messages=messages, time=time, name_jumble=name_jumble,
      title=title)