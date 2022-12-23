FROM python:3.10-alpine3.17
LABEL maintainer="rstest"

ENV PYTHONBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
COPY ./Pipfile ./Pipfile.lock /app/
WORKDIR /app
EXPOSE 8000


RUN python -m pip install --upgrade pip && \
    pip install pipenv && \
    if [ $DEV = "true"]; \
        then pipenv install --dev --system --deploy; \
    else pipenv install --system --deploy; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user


USER django-user