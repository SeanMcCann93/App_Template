from flask import render_template, redirect, url_for, request
from application import app, db,bcrypt
from application.models import Posts, Users
from application.forms import PostForm, RegistrationForm, LoginForm, UpdateAccountForm
from flask_login import login_user, current_user, logout_user, login_required

@app.route('/')
@app.route('/home')
def home():
    blogData = Posts.query.all()
    return render_template('home.html', title='Home Page', posts=blogData)

@app.route('/about')
def about():
    return render_template('about.html', title='About Page')

@app.route('/register', methods=['GET', 'POST'])
def register():
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

        return redirect(url_for('post'))
    return render_template('user/register.html', title='Register', form=form)

@app.route('/login', methods=['GET', 'POST'])
def login():
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
    return render_template('user/account.html', title='Account', form=form)

@app.route('/account/delete', methods=['GET', 'POST'])
@login_required
def account_delete():
    user = current_user.id
    account = Users.query.filter_by(id=user).first()
    posts = Posts.query.filter_by(user_id=user).all()
    logout_user()
    for post in posts:
        db.session.delete(post)
    db.session.delete(account)
    db.session.commit()
    return redirect(url_for('register'))

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

        return redirect(url_for('post'))
    return render_template('user/register.html', title='Register', form=form)

@app.route('/logout', methods=['GET', 'POST'])
def logout():
    logout_user()
    return redirect(url_for('login'))

@app.route('/post', methods=['GET', 'POST'])
@login_required
def post():
    form = PostForm()
    if form.validate_on_submit():
        postData = Posts(
                title=form.title.data,
                auther=current_user,
                content=form.content.data
        )

        db.session.add(postData)
        db.session.commit()

        return redirect(url_for('home'))
    else:
        print(form.errors)

    return render_template('post.html', title='Post', form=form)
