from decouple import config
from config.db_url import PgUrl
# import dj_database_url
# from dj_database_url import parse as db_url
from .base import *  # noqa

SECRET_KEY = config('DJANGO_SECRET_KEY')
DEBUG = False
ALLOWED_HOSTS = ['localhost', '127.0.0.1']

# TODO: Below commented code not work for me
# # Improperly configured error: provide settings.DATABASES ENGINE value
# DATABASES = {
#     'default': dj_database_url.config()
# }

DATABASES = {
    # use my own
    'default': PgUrl(config('DATABASE_URL')).to_dict()
}
