from datetime import datetime, timedelta
from airflow.sdk import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook

def fetch_data():
    hook = PostgresHook(postgres_conn_id='sales_db')
    sql='select count(*) from core.orders'
    msg = hook.get_records(sql=sql)
    print(msg)


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email': [''],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 0,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id='posgres_hook',
    default_args=default_args,
    description='Postgres hook',
    schedule=None,
    start_date=datetime(2026, 9, 19),
) as dag:
    fetch_count=PythonOperator(
        task_id='fetch_count',
        python_callable=fetch_data,
    )


