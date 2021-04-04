from flask import render_template, redirect, url_for, request
from application import app, db, bcrypt
from application.models import Users
from application.forms import RegistrationForm, LoginForm, UpdateAccountForm
from flask_login import login_user, current_user, logout_user, login_required

# --- Creating a C.R.U.D site ( Create . Read . Update . Delete ) ---

@app.route('/')
@app.route('/home')
def home():
    return render_template('home.html', title='Home Page')

@app.route('/about')
def about():
    return render_template('about.html', title='About Page')

# --- CREATE-START ---

# --- CREATE---END ---
# --- READ-START ---
# --- READ---END ---

# --- READ---END ---
# --- UPDATE-START ---

# --- UPDATE---END ---
# --- DELETE-START ---

# --- DELETE---END ---

#-----------------------------------------------------------------------------------------------
#--- USERS -------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------

@app.route('/register', methods=['GET', 'POST'])
def register():
    """If the user is already logged in they are directed to the 'home'
    page. If not then the RegistrationForm is used to collect data
    to be entered into the Users table."""
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    form = RegistrationForm()
    if form.validate_on_submit():
        hash_pw=bcrypt.generate_password_hash(form.password.data)
        user=Users(
            first_name=form.first_name.data,
            last_name=form.last_name.data,
            email=form.email.data, 
            password=hash_pw
            )
        db.session.add(user)
        db.session.commit()

        return redirect(url_for('home'))
    return render_template('user/register.html', title='Register', form=form)

@app.route('/login', methods=['GET', 'POST'])
def login():
    """If the user is already logged in they are directed to the 'home'
    page. If not then they will be requested to provide their
    email and password. If not logged in and visit a page that
    reqires the user to be logged on, the user is directed to
    this page."""
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    form = LoginForm()
    if form.validate_on_submit():
        user = Users.query.filter_by(email=form.email.data).first()
        if user and bcrypt.check_password_hash(user.password, form.password.data):
            login_user(
                user,
                remember=form.remember.data
            )
            next_page = request.args.get('next')
            if next_page:
                return redirect(next_page)
            else:
                return redirect(url_for('home'))
    return render_template('user/login.html', title='Login Page', form=form)

@app.route('/account', methods=['GET', 'POST'])
@login_required
def account():
    """Using the UpdateAccountForm this pulls data from the Users table
    and applys this to the fields on screen. This data can then
    be changed and updated."""
    form = UpdateAccountForm()
    if form.validate_on_submit():
        current_user.first_name = form.first_name.data
        current_user.last_name = form.last_name.data
        current_user.email = form.email.data
        db.session.commit()
        return redirect(url_for('account'))
    elif request.method =='GET':
        form.first_name =  current_user.first_name
        form.last_name = current_user.last_name
        form.email = current_user.email
    return render_template('user/account.html', title='Account Page', form=form)

@app.route('/account/delete', methods=['GET', 'POST'])
@login_required
def account_delete():
    """This using the Users id will filter out all films in their
    collection and delete them one by one. Once all are
    removed it will log the user out and delete their account."""
    user = current_user.id
    account = Users.query.filter_by(id=user).first()
    logout_user()
    db.session.delete(account)
    db.session.commit()
    return redirect(url_for('register'))

@app.route('/logout', methods=['GET', 'POST'])
def logout():
    """Clicking the Logout button on the menu will Log the user
    out of the site."""
    logout_user()
    return redirect(url_for('login'))

#-----------------------------------------------------------------------------------------------
#--- USERS - END -------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------