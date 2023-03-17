FROM python:3.11-alpine3.17

WORKDIR /app
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

RUN addgroup -S app && adduser -S app -G app
USER app

ADD --chown=app:app https://github.com/3ng1n33r/ru-aircraft-db/raw/main/aircraft.db /app/aircraft.db
COPY --chown=app:app src .

EXPOSE 5000

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
