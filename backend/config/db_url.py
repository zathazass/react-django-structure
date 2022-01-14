"""
Converting postgres url into django database dict.
"""

DEFAULT_ENV = 'DATABASE_URL'
DB_PROVIDER = ['postgres', 'postgresql', 'pgsql']


class PgUrl:
    def __init__(self, env=DEFAULT_ENV, conn_max_age=600):
        self._env = env
        self._conn_max_age = conn_max_age

    def _find_db(self):
        db_provider, *_ = self._env.split(':')
        if db_provider in DB_PROVIDER:
            return True

    def to_dict(self):
        if not self._find_db():
            return Exception('Use Postgres only')

        _, usr_pw_hos_por, name = [x for x in self._env.split('/') if x]
        usr_pw, hos_por = usr_pw_hos_por.rsplit('@', 1)
        user, password = usr_pw.split(':', 1)
        host, port = hos_por.split(':')
        port = int(port)

        return {
            'ENGINE': 'django.db.backends.postgresql_psycopg2',
            'USER': user,
            'PASSWORD': password,
            'HOST': host,
            'PORT': port,
            'NAME': name
        }
