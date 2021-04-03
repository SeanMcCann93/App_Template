#!/usr/bin/env python3

from application import db
from application.models import Users

db.drop_all()
db.create_all()