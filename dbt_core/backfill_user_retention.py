import subprocess
from datetime import datetime, timedelta

def run_dbt_for_date(date_str):
    print(f"\n>>> Running dbt for {date_str}...")
    subprocess.run([
        "dbt", "run",
        "--select", "user_retention",
        "--vars", f'{{"target_date": "{date_str}"}}'
    ], check=True)

def backfill(start_date: str, end_date: str):
    current = datetime.strptime(start_date, "%Y-%m-%d")
    end = datetime.strptime(end_date, "%Y-%m-%d")

    while current <= end:
        run_dbt_for_date(current.strftime("%Y-%m-%d"))
        current += timedelta(days=1)

if __name__ == "__main__":
    # Replace with your desired date range
    backfill("2024-04-02", "2024-06-26")
