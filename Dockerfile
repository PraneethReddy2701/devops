FROM python:3.11-slim

WORKDIR /app

COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app/main.py .

EXPOSE 8000

#CMD ["uvicorn", "main:app", "--host", "127.0.0.1", "--port", "8000"] this particualr ip restricts the access to conatiner

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"] # we need to use 0.0.0.0 to get container communication

