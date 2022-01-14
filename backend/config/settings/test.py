from decouple import config
# import dj_database_url
from .base import *  # noqa
from config.db_url import PgUrl

SECRET_KEY = config('DJANGO_SECRET_KEY')
DEBUG = False
ALLOWED_HOSTS = ['*']

DATABASES = {
    # use my own
    'default': PgUrl(config('DATABASE_URL')).to_dict()
}
