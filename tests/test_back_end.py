import unittest
from flask import abort, url_for
from flask_testing import TestCase
from application import app, db, bcrypt
from application.models import Users, Posts
from os import getenv

class TestBase(TestCase):
    def create_app(self):
        # pass in configuration for test database
        config_name = 'testing'
        app.config.update(
            SQLALCHEMY_URI=getenv('FLASK_BLOG_TEST_URI'),
            SECRET_KEY=getenv('TEST_SECRET_KEY'),
            WTF_CSRF_ENABLED=False,
            DEBUG=True
            )
        return app

    def setUp(self):
        """Will be called before very test"""
            # ensure that there is no data in the test database when the test starts
        db.session.commit()
        db.drop_all()
        db.create_all()
            # Create a test admin user
        hashed_pw = bcrypt.generate_password_hash('admin2016')
        admin = Users(
            first_name="admin",
            last_name="user",
            email="admin@admin.com",
            password=hashed_pw
            )
            # Create a basic user
        hashed_pw_2 = bcrypt.generate_password_hash('test2016')
        employee = Users(
            first_name="test",
            last_name="user",
            email="test@user.com",
            password=hashed_pw_2
            )
            # save user to database
        db.session.add(admin)
        db.session.add(employee)
        db.session.commit()

    def tearDown(self):
        """Will be called after every test"""
        db.session.remove()
        db.drop_all()

class TestViews(TestBase):
    def test_homepage_view(self):
        response = self.client.get(url_for('home'))
        self.assertEqual(response.status_code, 200)
    
class TestPosts(TestBase):
    def test_add_new_post(self):
        with self.client:
            self.client.post(
                url_for('login'),
                data=dict(
                    email="admin@admin.com",
                    password="admin2016"
                ),
            follow_redirects=True
            )
            response = self.client.post(
                url_for('post'),
                data=dict(
                    title="Test Title",
                    content="Test Content"
                ),
                follow_redirects=True
            )
        self.assertIn(b'Test Title', response.data)