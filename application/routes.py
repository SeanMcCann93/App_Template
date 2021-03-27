from flask import render_template, redirect, url_for, request
from application import app, db, bcrypt
from application.models import Films, Users, Collection
from application.forms import FilmsForm, RegistrationForm, LoginForm, UpdateAccountForm
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

@app.route('/add_movie', methods=['GET', 'POST'])
@login_required
def add_movie():
    """Using the FilmsForm will add field data to the Films Table. If
    all needs are met the user will be redirected to the 'home' page."""
    form = FilmsForm()
    if form.validate_on_submit():
        filmData = Films(
                title=form.title.data,
                year=form.year.data,
                age=form.age.data,
                director=form.director.data,
                genre=form.genre.data,
                formating=form.formating.data,
                description=form.description.data,
                code=form.code.data
        )
        db.session.add(filmData)
        db.session.commit()
        return redirect(url_for('home'))
    else:
        print(form.errors)
    return render_template('add_movie.html', title='add_movie', form=form)

@app.route('/catalogue/<film>/add', methods=['GET','POST'])
def add_collection(film):
    """If the user requests to add the movie to collection, the
    movie will be filtered within the users current collection.
    If the result of the search turns up no entries, the film will be
    added to the users collection and sent to the 'collection' page."""
    userID = int(current_user.id)
    own = Collection.query.filter_by(user_id=current_user.id).filter_by(films_id=film).first()
    if own == None:
        filmOwn = Collection(
            user_id = userID,
            films_id = film
        )
        db.session.add(filmOwn)
    db.session.commit()
    return redirect(url_for('collection'))

# --- CREATE---END ---
# --- READ-START ---
# --- READ---END ---

@app.route('/catalogue', methods=['GET', 'POST'])
def catalogue():
    """When opening the 'catalogue' page all the films in the database
    will be displayed on the screen. On the page the buttons to
    edit/delete or add to collection are hidden untill the user signs
    in and creates and account."""
    filmData = Films.query.all()
    return render_template('catalogue.html', title='catalogue Page', films=filmData)

@app.route('/collection', methods=['GET', 'POST'])
@login_required
def collection():
    """Filtering the films within the users collection, when entering
    the 'collection' page, only the films hosted within the users
    collection will be displayed."""
    userID = int(current_user.id)
    myFilms = Collection.query.filter_by(user_id = userID).all()
    return render_template('collection.html', title='collection', films=myFilms)

# --- READ---END ---
# --- UPDATE-START ---


@app.route('/edit_movie/<filmID>', methods=['GET', 'POST'])
@login_required
def edit_movie(filmID):
    """Using the FilmForm this pulls data from the Films DATABASE
    that is filtered by a filmID containing its id. Applying the data
    to the fields in the 'edit_movie' page and applying any changes
    the user wishes to make."""
    form = FilmsForm()
    film = Films.query.filter_by(id=filmID).first()
    if form.validate_on_submit():
        film.title = form.title.data
        film.year = form.year.data
        film.age = form.age.data
        film.director = form.director.data
        film.genre = form.genre.data
        film.formating = form.formating.data
        film.description = form.description.data
        film.code = form.code.data
        db.session.commit()
        return redirect(url_for('collection'))
    elif request.method =='GET':
        form.title.data = film.title
        form.year.data = film.year
        form.age.data = film.age
        form.director.data = film.director
        form.genre.data = film.genre
        form.formating.data = film.formating
        form.description.data = film.description
        form.code.data = film.code
    return render_template('edit_movie.html', title='Edit Page', form=form)

# --- UPDATE---END ---
# --- DELETE-START ---

@app.route('/catalogue/<filmID>/delete', methods=['GET', 'POST'])
@login_required
def delete(filmID):
    """When looking to delete a film from the Films tabel this will filter
    thought all Collection table\, looking for entries of this film in
    all user collections and deletes them before removing the film."""
    film = Films.query.filter_by(id=filmID).first()
    collections = Collection.query.filter_by(films_id=filmID).all()
    print("Removing", film.title, "from Database")
    for collection in collections:
        db.session.delete(collection)
    db.session.delete(film)
    db.session.commit()
    return redirect(url_for('catalogue'))

@app.route('/collection/<film>/delete', methods=['GET', 'POST'])
@login_required
def remove_collection(film):
    """Allowing the user to remove films from their collection, this
    filtersout the film in the Collection table that relates
    to thelogged in user and deletes the DATABASE entry."""
    userID = int(current_user.id)
    myFilms = Collection.query.filter_by(user_id=userID).filter_by(films_id=film)
    for film in myFilms:
        db.session.delete(film)
    db.session.commit()
    return redirect(url_for('collection'))

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

        return redirect(url_for('catalogue'))
    return render_template('register.html', title='Register', form=form)

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
    return render_template('login.html', title='Login Page', form=form)

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
    return render_template('account.html', title='Account Page', form=form)

@app.route('/account/delete', methods=['GET', 'POST'])
@login_required
def account_delete():
    """This using the Users id will filter out all films in their
    collection and delete them one by one. Once all are
    removed it will log the user out and delete their account."""
    user = current_user.id
    account = Users.query.filter_by(id=user).first()
    owned = Collection.query.filter_by(user_id=user).all()
    logout_user()
    for films in owned:
        db.session.delete(films)
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