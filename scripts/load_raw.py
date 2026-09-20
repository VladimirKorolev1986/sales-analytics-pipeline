import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
from pathlib import Path
import os

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent
DATA_RAW_DIR = PROJECT_ROOT / "data" / "raw"

dct_table = {
'olist_customers_dataset': 'olist_customers_dataset.csv',
'olist_geolocation_dataset':'olist_geolocation_dataset.csv',
'olist_order_items_dataset':'olist_order_items_dataset.csv',
'olist_order_payments_dataset':'olist_order_payments_dataset.csv',
'olist_order_reviews_dataset':'olist_order_reviews_dataset.csv',
'olist_orders_dataset':'olist_orders_dataset.csv',
'olist_products_dataset':'olist_products_dataset.csv',
'olist_sellers_dataset':'olist_sellers_dataset.csv',
'product_category_name_translation':'product_category_name_translation.csv'
}



def load_csv_to_postgres(engine):
	with engine.connect() as conn:
		conn.execute(text("CREATE SCHEMA IF NOT EXISTS staging"))
		conn.commit()

	for table_name, file_name in dct_table.items():
		try:    
			df = pd.read_csv(f"{DATA_RAW_DIR}/{file_name}",
					dtype={'customer_zip_code_prefix': str,
							'geolocation_zip_code_prefix':str,
							'seller_zip_code_prefix':str})
			# Опционально очистить данные перед загрузкой
			# df = df.fillna(0).
			df.to_sql(
				name=table_name,
				con=engine,
				schema='staging',
				if_exists='replace',
				index=False
			)
			print(f'Таблица {table_name} успешно записана')
		except Exception as e:
			print(f'Ошибка при загрузке {table_name}: {e}')
			raise

if __name__ == "__main__":
	load_dotenv()
	db_user = os.getenv('SALES_DB_USER')
	db_password = os.getenv('SALES_DB_PASSWORD')
	db_name = os.getenv('SALES_DB_NAME')
	db_port = os.getenv('SALES_DB_PORT')
	db_host = os.getenv('SALES_DB_HOST')

	DATABASE_URL=f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
	engine = create_engine(DATABASE_URL)
	load_csv_to_postgres(engine)