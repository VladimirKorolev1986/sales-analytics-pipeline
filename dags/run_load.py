from datetime import timedelta, datetime
from airflow.sdk import DAG
from airflow.providers.standard.operators.python import PythonOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook



default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email': [''],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 0,
    'retry_delay': timedelta(minutes=5),
}

def run_load_staging():
    import load_raw
    hook = PostgresHook(postgres_conn_id='sales_db')
    engine = hook.get_sqlalchemy_engine()
    load_raw.load_csv_to_postgres(engine)


with DAG(
    dag_id='load_csv_to_postgres',
    default_args=default_args,
    schedule=None,
    start_date=datetime(2026, 9, 21),
) as dag:



    load_staging = PythonOperator(
        task_id='load_staging',
        python_callable=run_load_staging,
    )
