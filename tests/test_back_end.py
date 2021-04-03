import unittest
from flask import abort, url_for
from flask_testing import TestCase
from application import app, db, bcrypt
from application.models import Users, Films, Collection
from os import getenv

# ---------- Base-SetUp-Testing ----------

class TestBase(TestCase):
    def create_app(self):
        config_name = 'testing'
        app.config.update(
            SQLALCHEMY_DATABASE_URI=getenv('APP_TEST_URI'),
            SECRET_KEY=getenv('TEST_SECRET_KEY'),
            WTF_CSRF_ENABLED=False,
            DEBUG=True
            )
        return app

    def setUp(self):
        """Will be called before every test"""
        db.drop_all()
        db.create_all()
        db.session.commit()
        hashed_pw = bcrypt.generate_password_hash('Adm1nSy5temT35t1n8')
        admin = Users(
            first_name="AdminSystem",
            last_name="Testing",
            email="AdminSystem@Testing.com",
            password=hashed_pw
            )
        hashed_pw_2 = bcrypt.generate_password_hash('Sy5temT35t1n8')
        employee = Users(
            first_name="System",
            last_name="Testing",
            email="System@Testing.com",
            password=hashed_pw_2
            )
        db.session.add(admin)
        db.session.add(employee)
        db.session.commit()

    def tearDown(self):
        """Will be called after every test"""
        db.session.remove()
        db.drop_all()

# -------- END-Base-SetUp-Testing --------

# ____________________________________________________________________

# ---------- Visit-Testing ----------

class TestViews(TestBase):
    def test_homepage_view(self):
        """This is the server getting a status code 200"""
        response = self.client.get(url_for('home'))
        self.assertEqual(response.status_code, 200)

# -------- END-Visit-Testing --------

# ____________________________________________________________________

# ---------- Create-Function-Testing ----------


# -------- Create-Function-Limitations --------

class TestOwnDuplicatesF(TestBase):
    """This as it stands will fail as the item is able to be duplicated in the current system"""
    def test_owndup_film(self):
        with self.client:
            self.client.post(
                url_for('login'),
                data=dict(
                    email="AdminSystem@Testing.com",
                    password="Adm1nSy5temT35t1n8"
                ),
            follow_redirects=True
            )
        self.assertEqual(Users.query.filter_by(user_id=1).count(), 1)

# -------- END-Create-Function-Testing --------

# ____________________________________________________________________

# ---------- Read-Function-Testing ----------

class TestReadFilmF(TestBase):
    def test_edit_film(self):
        """This is to check a field holds a film title from the database 'Test Matrix 1011' with this test"""
        with self.client:
            self.client.post(
                url_for('login'),
                data=dict(
                    email="AdminSystem@Testing.com",
                    password="Adm1nSy5temT35t1n8"
                ),
            follow_redirects=True
            )
            response = self.client.get(
                url_for('edit_movie', filmID = 2)
            )
        self.assertIn(b'Test Matrix 1011', response.data)

# -------- END-Read-Function-Testing --------

# ____________________________________________________________________

# ---------- Update-Function-Testing ----------

class TestEditFilmF(TestBase):
    def test_edit_film(self):
        """This is to Edit a film to the database 'Test Matrix 1011' in to 'Test Matrix 1111' with this test"""
        with self.client:
            self.client.post(
                url_for('login'),
                data=dict(
                    email="AdminSystem@Testing.com",
                    password="Adm1nSy5temT35t1n8"
                ),
            follow_redirects=True
            )
            response = self.client.post(
                url_for('edit_movie', filmID = 2),
                data=dict(
                    title="Test Matrix 1111",
                    year=2020,
                    age="U",
                    director="Test-TestingSystem",
                    genre="Invasion 2.0",
                    formating="Plug In",
                    description="This is a second virus sent to test the functionality of this data",
                    code=92753765
                ),
                follow_redirects=True
            )
        self.assertEqual(Films.query.filter_by(title="Test Matrix 1111").count(), 1)

class TestEditUserF(TestBase):
    def test_edit_user(self):
        """This is to Edit a User to the database 'System@Testing.com's first name from 'System' to 'BetaSystem' with this test"""
        with self.client:
            self.client.post(
                url_for('login'),
                data=dict(
                    email="System@Testing.com",
                    password="Sy5temT35t1n8"
                ),
            follow_redirects=True
            )
            response = self.client.post(
                url_for('account'),
                data=dict(
                    first_name="BetaSystem",
                    last_name="Testing",
                    email="System@Testing.com"
                ),
                follow_redirects=True
            )
        self.assertEqual(Users.query.filter_by(first_name="BetaSystem").count(), 1)

# -------- Update-Function-Limitations --------

# -------- END-Update-Function-Testing --------

# ____________________________________________________________________

# ---------- Delete-Function-Testing ----------

class TestDelFilmF(TestBase):
    def test_del_film(self):
        """This is to Remove a film to the database 'Test Matrix 1011' in this test"""
        with self.client:
            self.client.post(
                url_for('login'),
                data=dict(
                    email="AdminSystem@Testing.com",
                    password="Adm1nSy5temT35t1n8"
                ),
            follow_redirects=True
            )
            response = self.client.post(
                url_for('delete', filmID = 2),              
                follow_redirects=True
            )
        self.assertEqual(Films.query.count(), 1)

class TestOwnedF(TestBase):
    """This as it stands will fail as the item is able to be duplicated in the current system"""
    def test_owndel_film(self):
        with self.client:
            self.client.post(
                url_for('login'),
                data=dict(
                    email="AdminSystem@Testing.com",
                    password="Adm1nSy5temT35t1n8"
                ),
            follow_redirects=True
            )
            response = self.client.post(
                url_for('add_collection', film=1),
                follow_redirects=True
            )
            response = self.client.post(
                url_for('add_collection', film=2),
                follow_redirects=True
            )

            self.assertEqual(Collection.query.filter_by(user_id=1).count(), 2)

            response = self.client.post(
                url_for('remove_collection', film=2),
                follow_redirects=True
            )
        
        self.assertEqual(Collection.query.filter_by(user_id=1).count(), 1)

class TestAccDelF(TestBase):
    """This as it stands will fail as the item is able to be duplicated in the current system"""
    def test_accdel_user(self):
        with self.client:
            self.client.post(
                url_for('login'),
                data=dict(
                    email="System@Testing.com",
                    password="Sy5temT35t1n8"
                ),
            follow_redirects=True
            )
            response = self.client.post(
                url_for('add_collection', film=1),
                follow_redirects=True
            )
            self.assertEqual(Collection.query.filter_by(user_id=2).count(), 1)

            response = self.client.post(
                url_for('account_delete'),
                follow_redirects=True
            )
        
        self.assertEqual(Collection.query.count(), 0)
        self.assertEqual(Users.query.count(), 1)

# -------- END-Delete-Function-Testing --------