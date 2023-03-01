###########
# BUILDER #
###########

# pull official base image
FROM python:3.10 as builder

# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install psycopg2 dependencies
RUN apt-get update && apt-get install -y apt-utils && apt-get install -y curl
RUN apt-get update && apt-get -y install python3-gi python3-gi-cairo gir1.2-gtk-3.0\
    libgirepository1.0-dev gcc libcairo2-dev pkg-config python3-dev


# lint
#RUN pip install --upgrade pip
#RUN pip install flake8
#COPY . .
#RUN flake8 --ignore=E501,F401

# install dependencies
COPY ./requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /usr/src/app/wheels -r ./requirements.txt


#########
# FINAL #
#########

# pull official base image
FROM python:3.10

# create directory for the app user
RUN mkdir -p /home/app

# create the app user
RUN useradd -ms /bin/bash app

# create the appropriate directories
ENV HOME=/home/app
ENV APP_HOME=/home/app/web
RUN mkdir $APP_HOME
RUN mkdir $APP_HOME/static
RUN mkdir $APP_HOME/media
WORKDIR $APP_HOME

# install dependencies
RUN apt-get update && apt-get install libpq-dev netcat
COPY --from=builder /usr/src/app/wheels /wheels
COPY --from=builder /usr/src/app/requirements.txt .
RUN pip install --no-cache /wheels/*

# copy entrypoint-prod.sh
COPY ./entrypoint.sh $APP_HOME

# copy project
COPY . $APP_HOME

# chown all the files to the app user
RUN chown -R app:app $APP_HOME

# change to the app user
USER app

# run entrypoint.sh
ENTRYPOINT ["/home/app/web/entrypoint.sh"]