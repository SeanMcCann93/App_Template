from flask_wtf import FlaskForm
from wtforms import IntegerField, StringField, SubmitField, PasswordField, BooleanField
from wtforms.validators import DataRequired, Length, Email, EqualTo, ValidationError
from application.models import Users, Films
from flask_login import current_user

class FilmsForm(FlaskForm):
    
    title = StringField("Title",
        validators=[
            DataRequired(),
            Length(min=3, max=50)
            ]
    )

    year = IntegerField("Year",
        validators=[
            DataRequired()
            ]
    )

    age = StringField("Rating",
        validators=[
            DataRequired(),
            Length(min=1, max=3)
            ]
    )

    director = StringField("Director",
        validators=[
            DataRequired(),
            Length(min=3, max=50)
            ]
    )

    genre = StringField("Genre",
        validators=[
            DataRequired(),
            Length(min=3, max=50)
            ]
    )

    formating = StringField("Format",
        validators=[
            DataRequired(),
            Length(min=3, max=10)
            ]
    )

    description = StringField("Description",
        validators=[
            DataRequired(),
            Length(min=3, max=1000)
            ]
    )

    code = IntegerField("Bar Code",
        validators=[
            DataRequired()
            ]
    )

    submit = SubmitField('Add!')

#-----------------------------------------------------------------------------------------------
#--- USERS -------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------

class RegistrationForm(FlaskForm):

    email = StringField("Email",
        validators=[
            DataRequired(),
            Email()
            ]
    )

    password = PasswordField("Password",
        validators=[
            DataRequired(),
            ]
    )

    confirm_password = PasswordField("Comfirm Password",
        validators=[
            DataRequired(),
            EqualTo('password')
            ]
    )

    first_name = StringField("First Name",
        validators=[
            DataRequired(),
            Length(min=2, max=30)
            ]
    )

    last_name = StringField("Last Name",
        validators=[
            DataRequired(),
            Length(min=3, max=30)
            ]
    )

    submit = SubmitField('Sign Up')

    def validate_email(self, email):
        user = Users.query.filter_by(email=email.data).first()
        if user:
            raise ValidationError('Email already in use')

class LoginForm(FlaskForm):

    email = StringField("Email",
        validators=[
            DataRequired(),
            Email()
            ]
    )

    password = PasswordField("Password",
        validators=[
            DataRequired(),
            ]
    )

    remember = BooleanField('Remember Me')
    submit = SubmitField('Login')

class UpdateAccountForm(FlaskForm):
    first_name = StringField("First Name",
        validators=[
            DataRequired(),
            Length(min=2, max=30)
            ]
    )

    last_name = StringField("Last Name",
        validators=[
            DataRequired(),
            Length(min=3, max=30)
            ]
    )
    
    email = StringField("Email",
        validators=[
            DataRequired(),
            Email()
            ]
    )

    submit = SubmitField('Update!')

    def validate_email(self, email):
        if email.data != current_user.email:
            user = Users.query.filter_by(email=email.data).first()
            if user:
                raise ValidationError('Email already in use')

#-----------------------------------------------------------------------------------------------
#--- USERS - END -------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------