FROM python:3.8-slim-buster
COPY ./PythonWebApp /app
WORKDIR /app
RUN pip3 install -r /app/requirements.txt
EXPOSE 5000
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]