"""
Basic settings for django framework. It controls how django will works.
"""

from decouple import config, Choices


DJANGO_ENV = config(
    'DJANGO_ENV',
    default='local',
    cast=Choices(['local', 'production', 'test'])
)

if DJANGO_ENV == 'production':
    from .production import *  # noqa
elif DJANGO_ENV == 'test':
    from .test import *  # noqa
elif DJANGO_ENV == 'local':
    from .local import *  # noqa
