FROM python:3.12.1-alpine3.19
LABEL maintainer="Taen Ahammmed"
LABEL email="taenahammed7@gmail.com"

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 4000

CMD ["python", "app.py"]