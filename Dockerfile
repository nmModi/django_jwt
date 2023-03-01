# Pull base image
FROM python:3.9
# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
# Set work directory
WORKDIR /code
# Copy project
COPY . /code/
#Install dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

CMD ["gunicorn", "django_jwt.wsgi:application", "--bind", "0.0.0.0:8000"]