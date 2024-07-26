from flask import Flask, render_template, redirect, request, url_for, session
from flask_sqlalchemy import SQLAlchemy
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import random
import string

app = Flask(__name__)
app.secret_key = 'your_secret_key'
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://your_user:your_password@db/your_database'

db = SQLAlchemy(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(150), unique=True, nullable=False)
    password = db.Column(db.String(150), nullable=False)
    otp_code = db.Column(db.String(6), nullable=True)

with app.app_context():
    db.create_all()

@app.route('/')
def index():
    return render_template('index.html')

from sqlalchemy.exc import IntegrityError

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        existing_user = User.query.filter_by(email=email).first()
        if existing_user:
            return 'Email already registered', 400

        user = User(email=email, password=password)
        db.session.add(user)
        try:
            db.session.commit()
        except IntegrityError:
            db.session.rollback()
            return 'Email already registered', 400

        return redirect(url_for('login'))
    return render_template('register.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        user = User.query.filter_by(email=email, password=password).first()
        if user:
            session['user_id'] = user.id
            otp_code = ''.join(random.choices(string.digits, k=6))
            user.otp_code = otp_code
            db.session.commit()
            send_otp_email(user.email, otp_code)
            return redirect(url_for('verify_2fa'))
    return render_template('login.html')

def send_otp_email(to_email, otp_code):
    from_email = 'twofatest1@outlook.com'
    password = 'Password2FA'
    smtp_server = 'smtp.office365.com'
    smtp_port = 587

    msg = MIMEMultipart()
    msg['From'] = from_email
    msg['To'] = to_email
    msg['Subject'] = 'Your 2FA Code'
    body = f'Your 2FA code is {otp_code}.'
    msg.attach(MIMEText(body, 'plain'))

    try:
        print("Connecting to mail server...")
        server = smtplib.SMTP(smtp_server, smtp_port)
        server.starttls()
        print("Logging in...")
        server.login(from_email, password)
        print("Sending email...")
        text = msg.as_string()
        server.sendmail(from_email, to_email, text)
        server.quit()
        print("Email sent successfully")
    except Exception as e:
        print(f"Failed to send email: {e}")

@app.route('/verify_2fa', methods=['GET', 'POST'])
def verify_2fa():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    user = User.query.get(session['user_id'])
    if request.method == 'POST':
        token = request.form['token']
        if token == user.otp_code:
            session['2fa_verified'] = True
            return redirect(url_for('home'))
        return 'Invalid token'
    return render_template('verify_2fa.html')

@app.route('/home')
def home():
    if 'user_id' not in session or '2fa_verified' not in session:
        return redirect(url_for('login'))
    return render_template('home.html')

@app.route('/logout')
def logout():
    session.pop('user_id', None)
    session.pop('2fa_verified', None)
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
