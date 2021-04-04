import unittest
from flask import abort, url_for
from flask_testing import TestCase
from application import app, db, bcrypt
from application.models import Users
from os import getenv

# ---------- Base-SetUp-Testing-Enviroment ----------

class TestBase(TestCase):
    def create_app(self):
        # pass in configuration for test database
        config_name = 'testing'
        app.config.update(
            SQLALCHEMY_DATABASE_URI=getenv('APP_TEST_URI'),
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
            first_name="Admin",
            last_name="User",
            email="admin@admin.com",
            password=hashed_pw
            )
            # Create a basic user
        hashed_pw_2 = bcrypt.generate_password_hash('test2016')
        employee = Users(
            first_name="Test",
            last_name="User",
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

# -------- END-Base-SetUp-Testing-Enviroment --------

# ____________________________________________________________________

# ---------- Visit-Testing ----------

class TestHomeViews(TestBase):
    def test_homepage_view(self):
        """Home Page is accessable to users"""
        response = self.client.get(url_for('home'))
        self.assertEqual(response.status_code, 200)

class TestAboutViews(TestBase):
    def test_aboutpage_view(self):
        """About Page is accessable to users"""
        response = self.client.get(url_for('about'))
        self.assertEqual(response.status_code, 200)

class TestLoginViews(TestBase):
    def test_loginpage_view(self):
        """Login Page is accessable to users"""
        response = self.client.get(url_for('login'))
        self.assertEqual(response.status_code, 200)

class TestRegisterViews(TestBase):
    def test_registerpage_view(self):
        """Register Page is accessable to users"""
        response = self.client.get(url_for('register'))
        self.assertEqual(response.status_code, 200)

class TestAccountViews(TestAccountBase):
    def test_acountpage_view(self):
        """Account Page is accessable to users"""
        response = self.client.get(url_for('account'))
        self.assertEqual(response.status_code, 200)

# -------- END-Visit-Testing --------

# ____________________________________________________________________

# ---------- Create-Function-Testing ----------

class TestCreateUser(TestBase):
    def test_add_new_post(self):
        with self.client:
            self.client.post(
                url_for('register'),
                data=dict(
                    first_name="Sean"
                    last_name="McCann"
                    email="Sean@admin.com",
                    password="admin2021",
                    confirm_password="admin2021"
                ),
            follow_redirects=True
            )
        self.assertEqual(Users.query.count(), 3)

# -------- END-Create-Function-Testing --------

# ____________________________________________________________________

# ---------- Read-Function-Testing ----------

class TestLoginUser(TestBase):
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
        self.assertIn(b'admin@admin.com', response.data)

# -------- END-Read-Function-Testing --------

# ____________________________________________________________________

# ---------- Update-Function-Testing ----------

class TestEditUser(TestBase):
    def test_edit_user(self):
        """This is to Edit a User to the database 'admin@admin.com's first name from 'Admin' to 'Sudo' with this test"""
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
                url_for('account'),
                data=dict(
                    first_name="Sudo",
                    last_name="User",
                    email="admin@admin.com"
                ),
                follow_redirects=True
            )
        self.assertEqual(Users.query.filter_by(first_name="Sudo").count(), 1)

# -------- END-Update-Function-Testing --------

# ____________________________________________________________________

# ---------- Delete-Function-Testing ----------

class TestDeleteUser(TestBase):
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
                url_for('account/delete'),
            follow_redirects=True
            )
        self.assertEqual(Films.query.count(), 1)

# -------- END-Delete-Function-Testing --------