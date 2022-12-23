FROM python:3.10-alpine3.17
LABEL maintainer="rstest"

ENV PYTHONBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
COPY ./Pipfile ./Pipfile.lock /app/
WORKDIR /app
EXPOSE 8000


RUN python -m pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    pip install pipenv && \
    if [ $DEV = "true"]; \
        then pipenv install --dev --system --deploy; \
    else pipenv install --dev --system --deploy; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user


USER django-user