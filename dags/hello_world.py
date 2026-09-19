from datetime import timedelta, datetime
from airflow.operators.python import PythonOperator
from airflow import DAG

def start_pipline():
    print('Начинаю пайплайн')

def proceed_pipline():
    print("Обрабатываю данные")

def end_pipline():
    print("Пайплайн завершён")



default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email': [''],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5)
}

with DAG(
    dag_id='hello_world',
    default_args=default_args,
    description = 'Hello World!',
    schedule = None,
    start_date=datetime(2026, 9, 14),
) as dag:
    task_start = PythonOperator(
        task_id='start_pipline',
        python_callable=start_pipline,
    )
    task_process = PythonOperator(
        task_id='process_pipline',
        python_callable=proceed_pipline,
    )
    task_end = PythonOperator(
        task_id='end_pipline',
        python_callable=end_pipline,
    )

    task_start >> task_process >> task_end