FROM python:3.7

WORKDIR /app

COPY . .

RUN pip install flask==0.5

CMD ["python", "app.py"]
